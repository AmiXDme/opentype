#ifndef SOUNDMIXER_H
#define SOUNDMIXER_H

#include <QObject>
#include <QSoundEffect>
#include <QMap>

class SoundMixer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(QStringList clickPacks READ clickPacks CONSTANT)
    Q_PROPERTY(QStringList errorPacks READ errorPacks CONSTANT)

public:
    explicit SoundMixer(QObject *parent = nullptr);
    ~SoundMixer() = default;

    qreal volume() const { return m_volume; }
    void setVolume(qreal vol);

    QStringList clickPacks() const { return m_clickPacks; }
    QStringList errorPacks() const { return m_errorPacks; }

    Q_INVOKABLE void playClick(const QString &pack);
    Q_INVOKABLE void playError(const QString &pack);
    Q_INVOKABLE void playComplete();
    Q_INVOKABLE void playNotification();
    Q_INVOKABLE void preview(const QString &pack);

signals:
    void volumeChanged();

private:
    qreal m_volume = 0.5;
    QStringList m_clickPacks;
    QStringList m_errorPacks;
    QMap<QString, QSoundEffect*> m_sounds;
    void loadSounds();
    QSoundEffect* getSound(const QString &name);
};

#endif // SOUNDMIXER_H