#ifndef PROFILEMANAGER_H
#define PROFILEMANAGER_H

#include <QObject>
#include <QVariantMap>
#include <QStringList>
#include <QDir>

class ProfileManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList profiles READ profiles NOTIFY profilesChanged)
    Q_PROPERTY(QString activeId READ activeId NOTIFY activeChanged)
    Q_PROPERTY(QString activeName READ activeName NOTIFY activeChanged)
    Q_PROPERTY(QString activeColor READ activeColor NOTIFY activeChanged)
    Q_PROPERTY(QVariantMap settings READ settings NOTIFY settingsChanged)

public:
    explicit ProfileManager(QObject *parent = nullptr);
    ~ProfileManager() = default;

    QStringList profiles() const { return m_profiles; }
    QString activeId() const { return m_activeId; }
    QString activeName() const { return m_activeName; }
    QString activeColor() const { return m_activeColor; }
    QVariantMap settings() const { return m_settings; }

    Q_INVOKABLE void createProfile(const QString &name);
    Q_INVOKABLE void deleteProfile(const QString &id);
    Q_INVOKABLE void setActive(const QString &id);
    Q_INVOKABLE void setSettings(const QVariantMap &settings);
    Q_INVOKABLE QString profileDir(const QString &id) const;

signals:
    void profilesChanged();
    void activeChanged();
    void settingsChanged();

private:
    void loadProfiles();
    void saveProfiles();
    void loadSettings();
    void saveSettings();
    QString generateId() const;
    QString generateColor() const;

    QStringList m_profiles;
    QString m_activeId;
    QString m_activeName;
    QString m_activeColor;
    QVariantMap m_settings;
    QString m_dataDir;
};

#endif // PROFILEMANAGER_H
