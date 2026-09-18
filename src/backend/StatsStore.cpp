#include "StatsStore.h"
#include <QFile>
#include <QJsonDocument>
#include <QStandardPaths>
#include <QDateTime>

StatsStore::StatsStore(QObject *parent)
    : QObject(parent)
    , m_profileId("default")
{
    m_dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(m_dataDir);
    loadStats(m_profileId);
}

void StatsStore::recordSession(const QVariantMap &stats)
{
    QJsonObject session;
    session["date"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    session["wpm"] = stats["wpm"].toDouble();
    session["rawWpm"] = stats["rawWpm"].toDouble();
    session["accuracy"] = stats["accuracy"].toDouble();
    session["correct"] = stats["correct"].toInt();
    session["errors"] = stats["errors"].toInt();
    session["totalKeystrokes"] = stats["totalKeystrokes"].toInt();
    session["duration_secs"] = stats["elapsedMs"].toDouble() / 1000.0;
    session["mode"] = stats["mode"].toString();
    session["language"] = stats["language"].toString();
    session["layout"] = stats["layout"].toString();

    m_sessions.append(session);
    QVariantList keys = stats["keyStats"].toList();
    if (!keys.isEmpty()) {
        recordKeys(keys);
    }
    recalculate();
    saveStats();
    emit statsChanged();
}

void StatsStore::recordKeys(const QVariantList &keys)
{
    for (const QVariant &kVar : keys) {
        QVariantMap km = kVar.toMap();
        QString key = km.value("key").toString();
        if (key.isEmpty()) continue;
        QJsonObject cur = m_keyTotals.value(key).toObject();
        cur["attempts"] = cur["attempts"].toInt() + km.value("attempts", 0).toInt();
        cur["errors"] = cur["errors"].toInt() + km.value("errors", 0).toInt();
        cur["totalTime"] = cur["totalTime"].toDouble() + km.value("avgTime", 0).toDouble() * km.value("attempts", 0).toInt();
        m_keyTotals[key] = cur;
    }
    saveStats();
    emit statsChanged();
}

QVariantList StatsStore::sessions() const
{
    QVariantList list;
    for (const auto &val : m_sessions) {
        list.append(val.toObject().toVariantMap());
    }
    return list;
}

QVariantMap StatsStore::keyTotals() const
{
    QVariantMap out;
    for (auto it = m_keyTotals.constBegin(); it != m_keyTotals.constEnd(); ++it) {
        QJsonObject o = it.value().toObject();
        int attempts = o["attempts"].toInt();
        int errors = o["errors"].toInt();
        double totalTime = o["totalTime"].toDouble();
        QVariantMap m;
        m["attempts"] = attempts;
        m["errors"] = errors;
        m["errorRate"] = attempts > 0 ? (double)errors / attempts : 0.0;
        m["accuracy"] = attempts > 0 ? (double)(attempts - errors) / attempts * 100.0 : 0.0;
        m["avgTime"] = attempts > 0 ? totalTime / attempts : 0.0;
        out[it.key()] = m;
    }
    return out;
}

QVariantMap StatsStore::totals() const
{
    QVariantMap totals;
    totals["totalSessions"] = m_totalSessions;
    totals["totalSeconds"] = m_totalSeconds;
    totals["totalKeystrokes"] = m_totalKeystrokes;
    totals["bestWpm"] = m_bestWpm;
    totals["averageWpm"] = m_averageWpm;
    totals["averageAccuracy"] = m_averageAccuracy;
    return totals;
}

QVariantMap StatsStore::recentAverages() const
{
    QVariantMap recent;
    int count = qMin(10, m_sessions.size());
    qreal totalWpm = 0;
    qreal totalAccuracy = 0;

    for (int i = m_sessions.size() - count; i < m_sessions.size(); i++) {
        QJsonObject session = m_sessions.at(i).toObject();
        totalWpm += session["wpm"].toDouble();
        totalAccuracy += session["accuracy"].toDouble();
    }

    if (count > 0) {
        recent["averageWpm"] = totalWpm / count;
        recent["averageAccuracy"] = totalAccuracy / count;
    }

    return recent;
}

bool StatsStore::exportCsv(const QString &path) const
{
    QString outPath = path;
    if (outPath.isEmpty()) {
        outPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)
            + "/OpenType-stats.csv";
    }
    QFile file(outPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return false;

    QTextStream out(&file);
    out << "date,wpm,accuracy,mode,language,layout,duration_secs\n";

    for (const auto &val : m_sessions) {
        QJsonObject session = val.toObject();
        out << session["date"].toString() << ","
            << session["wpm"].toDouble() << ","
            << session["accuracy"].toDouble() << ","
            << session["mode"].toString() << ","
            << session["language"].toString() << ","
            << session["layout"].toString() << ","
            << session["duration_secs"].toDouble() << "\n";
    }

    file.close();
    return true;
}

void StatsStore::loadStats(const QString &profileId)
{
    m_profileId = profileId;
    QString filePath = m_dataDir + "/" + profileId + "/stats.json";
    QFile file(filePath);

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        file.close();

        if (doc.isObject()) {
            QJsonObject obj = doc.object();
            m_sessions = obj["sessions"].toArray();
            m_keyTotals = obj["keyTotals"].toObject();
            recalculate();
            emit statsChanged();
        }
    }
}

void StatsStore::saveStats()
{
    QString profileDir = m_dataDir + "/" + m_profileId;
    QDir().mkpath(profileDir);

    QString filePath = profileDir + "/stats.json";
    QFile file(filePath);

    if (file.open(QIODevice::WriteOnly)) {
        QJsonObject obj;
        obj["sessions"] = m_sessions;
        obj["keyTotals"] = m_keyTotals;

        file.write(QJsonDocument(obj).toJson());
        file.close();
    }
}

void StatsStore::recalculate()
{
    m_totalSessions = m_sessions.size();
    m_bestWpm = 0;
    qreal totalWpm = 0;
    qreal totalAccuracy = 0;
    m_totalSeconds = 0;
    m_totalKeystrokes = 0;

    for (const auto &val : m_sessions) {
        QJsonObject session = val.toObject();
        qreal wpm = session["wpm"].toDouble();
        qreal accuracy = session["accuracy"].toDouble();
        qreal duration = session["duration_secs"].toDouble();
        int keystrokes = session["totalKeystrokes"].toInt();

        if (wpm > m_bestWpm) m_bestWpm = wpm;
        totalWpm += wpm;
        totalAccuracy += accuracy;
        m_totalSeconds += duration;
        m_totalKeystrokes += keystrokes;
    }

    if (m_totalSessions > 0) {
        m_averageWpm = totalWpm / m_totalSessions;
        m_averageAccuracy = totalAccuracy / m_totalSessions;
    }
}
