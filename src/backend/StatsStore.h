#ifndef STATSSTORE_H
#define STATSSTORE_H

#include <QObject>
#include <QVariantMap>
#include <QVariantList>
#include <QJsonArray>
#include <QJsonObject>
#include <QDir>

class StatsStore : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int totalSessions READ totalSessions NOTIFY statsChanged)
    Q_PROPERTY(qreal bestWpm READ bestWpm NOTIFY statsChanged)
    Q_PROPERTY(qreal averageWpm READ averageWpm NOTIFY statsChanged)
    Q_PROPERTY(qreal averageAccuracy READ averageAccuracy NOTIFY statsChanged)
    Q_PROPERTY(qreal totalSeconds READ totalSeconds NOTIFY statsChanged)
    Q_PROPERTY(int totalKeystrokes READ totalKeystrokes NOTIFY statsChanged)

public:
    explicit StatsStore(QObject *parent = nullptr);
    ~StatsStore() = default;

    int totalSessions() const { return m_totalSessions; }
    qreal bestWpm() const { return m_bestWpm; }
    qreal averageWpm() const { return m_averageWpm; }
    qreal averageAccuracy() const { return m_averageAccuracy; }
    qreal totalSeconds() const { return m_totalSeconds; }
    int totalKeystrokes() const { return m_totalKeystrokes; }

    Q_INVOKABLE void recordSession(const QVariantMap &stats);
    Q_INVOKABLE void recordKeys(const QVariantList &keys);
    Q_INVOKABLE QVariantList sessions() const;
    Q_INVOKABLE QVariantMap totals() const;
    Q_INVOKABLE QVariantMap recentAverages() const;
    Q_INVOKABLE QVariantMap keyTotals() const;
    Q_INVOKABLE bool exportCsv(const QString &path) const;
    Q_INVOKABLE void loadStats(const QString &profileId);
    Q_INVOKABLE void saveStats();

signals:
    void statsChanged();

private:
    void recalculate();

    int m_totalSessions = 0;
    qreal m_bestWpm = 0;
    qreal m_averageWpm = 0;
    qreal m_averageAccuracy = 0;
    qreal m_totalSeconds = 0;
    int m_totalKeystrokes = 0;

    QJsonArray m_sessions;
    QJsonObject m_keyTotals;
    QString m_profileId;
    QString m_dataDir;
};

#endif // STATSSTORE_H
