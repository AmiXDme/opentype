#ifndef SOUNDMIXER_H
#define SOUNDMIXER_H

#include <QObject>

class SoundMixer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal volume READ volume WRITE setVolume NOTIFY volumeChanged)

public:
    explicit SoundMixer(QObject *parent = nullptr);
    ~SoundMixer() = default;

    qreal volume() const { return m_volume; }
    void setVolume(qreal vol);

    Q_INVOKABLE void playClick(const QString &pack);
    Q_INVOKABLE void playError(const QString &pack);
    Q_INVOKABLE void preview(const QString &pack);

signals:
    void volumeChanged();

private:
    qreal m_volume = 0.5;
};

#endif // SOUNDMIXER_H
