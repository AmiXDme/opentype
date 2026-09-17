#include "ProfileManager.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStandardPaths>
#include <QRandomGenerator>
#include <QDateTime>

ProfileManager::ProfileManager(QObject *parent)
    : QObject(parent)
{
    m_dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(m_dataDir);
    loadProfiles();
}

void ProfileManager::createProfile(const QString &name)
{
    QString id = generateId();
    QString color = generateColor();

    QString profileDir = m_dataDir + "/" + id;
    QDir().mkpath(profileDir);

    QJsonObject profile;
    profile["id"] = id;
    profile["name"] = name;
    profile["color"] = color;
    profile["createdAt"] = QDateTime::currentDateTime().toString(Qt::ISODate);

    QFile file(profileDir + "/profile.json");
    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(profile).toJson());
        file.close();
    }

    m_profiles.append(name);
    saveProfiles();

    if (m_profiles.size() == 1) {
        setActive(id);
    }

    emit profilesChanged();
}

void ProfileManager::deleteProfile(const QString &id)
{
    QString profileDir = m_dataDir + "/" + id;
    QDir dir(profileDir);
    if (dir.exists()) {
        dir.removeRecursively();
    }

    loadProfiles();
    emit profilesChanged();

    if (m_activeId == id && !m_profiles.isEmpty()) {
        // Set first profile as active
        loadProfiles();
    }
}

void ProfileManager::setActive(const QString &id)
{
    m_activeId = id;

    QString profileFile = m_dataDir + "/" + id + "/profile.json";
    QFile file(profileFile);

    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        file.close();

        QJsonObject profile = doc.object();
        m_activeName = profile["name"].toString();
        m_activeColor = profile["color"].toString();
    }

    loadSettings();
    emit activeChanged();
}

void ProfileManager::setSettings(const QVariantMap &settings)
{
    m_settings = settings;
    saveSettings();
    emit settingsChanged();
}

QString ProfileManager::profileDir(const QString &id) const
{
    return m_dataDir + "/" + id;
}

void ProfileManager::loadProfiles()
{
    m_profiles.clear();

    QDir dataDir(m_dataDir);
    QStringList dirs = dataDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);

    for (const QString &dir : dirs) {
        QString profileFile = m_dataDir + "/" + dir + "/profile.json";
        QFile file(profileFile);

        if (file.open(QIODevice::ReadOnly)) {
            QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
            file.close();

            QJsonObject profile = doc.object();
            m_profiles.append(profile["name"].toString());

            if (m_activeId.isEmpty()) {
                m_activeId = dir;
                m_activeName = profile["name"].toString();
                m_activeColor = profile["color"].toString();
            }
        }
    }
}

void ProfileManager::saveProfiles()
{
    QString indexPath = m_dataDir + "/profiles.json";
    QFile file(indexPath);

    if (file.open(QIODevice::WriteOnly)) {
        QJsonObject obj;
        QJsonArray arr;
        for (const QString &name : m_profiles) {
            arr.append(name);
        }
        obj["profiles"] = arr;
        file.write(QJsonDocument(obj).toJson());
        file.close();
    }
}

void ProfileManager::loadSettings()
{
    QString settingsFile = m_dataDir + "/" + m_activeId + "/settings.json";
    QFile file(settingsFile);

    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        file.close();
        m_settings = doc.object().toVariantMap();
    } else {
        m_settings["theme"] = "yaru_dark";
        m_settings["layout"] = "qwerty";
        m_settings["language"] = "english";
        m_settings["soundEnabled"] = true;
        m_settings["clickPack"] = "off";
        m_settings["errorPack"] = "off";
        m_settings["volume"] = 0.5;
        m_settings["focusMode"] = false;
        m_settings["randomMode"] = "off";
    }
}

void ProfileManager::saveSettings()
{
    QString settingsFile = m_dataDir + "/" + m_activeId + "/settings.json";
    QFile file(settingsFile);

    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(QJsonObject::fromVariantMap(m_settings)).toJson());
        file.close();
    }
}

QString ProfileManager::generateId() const
{
    return QString::number(QDateTime::currentMSecsSinceEpoch(), 36);
}

QString ProfileManager::generateColor() const
{
    QStringList colors = {
        "#4aa3ff", "#57c06b", "#e0607e", "#a978f0",
        "#f0894a", "#3fc7c7", "#c9ce4a", "#f6b73c"
    };
    auto *rng = QRandomGenerator::global();
    return colors.at(rng->bounded(colors.size()));
}
