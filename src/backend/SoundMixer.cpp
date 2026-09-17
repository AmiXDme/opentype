#include "SoundMixer.h"
#include <QDir>
#include <QDebug>

SoundMixer::SoundMixer(QObject *parent)
    : QObject(parent)
{
    loadSounds();
}

void SoundMixer::setVolume(qreal vol)
{
    if (qFuzzyCompare(m_volume, vol)) return;
    m_volume = qBound(0.0, vol, 1.0);
    for (auto sound : m_sounds) {
        if (sound) sound->setVolume(m_volume);
    }
    emit volumeChanged();
}

void SoundMixer::loadSounds()
{
    // Click packs (mechanical keyboard sounds)
    m_clickPacks = {"off", "mechanical", "soft", "clicky", "linear", "tactile", "vintage", "modern", "gaming", "office", "silent", "loud"};

    // Error packs
    m_errorPacks = {"off", "buzz", "beep", "chime", "alert", "pop", "click", "ding", "bloop", "snap", "thud", "ping"};

    // Main click sounds (sound_001 through sound_013)
    for (int i = 1; i <= 13; ++i) {
        QString name = QString("click_%1").arg(i, 3, 10, QChar('0'));
        QString path = QString("qrc:/resources/sounds/sound_%1.wav").arg(i, 3, 10, QChar('0'));
        QSoundEffect *effect = new QSoundEffect(this);
        effect->setSource(QUrl(path));
        effect->setVolume(m_volume);
        m_sounds[name] = effect;
    }

    // Error sounds (sound_071 through sound_078)
    for (int i = 71; i <= 78; ++i) {
        QString name = QString("error_%1").arg(i - 70, 3, 10, QChar('0'));
        QString path = QString("qrc:/resources/sounds/sound_%1.wav").arg(i, 3, 10, QChar('0'));
        QSoundEffect *effect = new QSoundEffect(this);
        effect->setSource(QUrl(path));
        effect->setVolume(m_volume);
        m_sounds[name] = effect;
    }

    // Space bar (sound_075)
    {
        QSoundEffect *effect = new QSoundEffect(this);
        effect->setSource(QUrl("qrc:/resources/sounds/sound_075.wav"));
        effect->setVolume(m_volume);
        m_sounds["space"] = effect;
    }

    // Complete/victory sound (sound_000)
    {
        QSoundEffect *effect = new QSoundEffect(this);
        effect->setSource(QUrl("qrc:/resources/sounds/sound_000.wav"));
        effect->setVolume(m_volume);
        m_sounds["complete"] = effect;
    }

    // Notification sounds (sound_079 through sound_091)
    for (int i = 79; i <= 91; ++i) {
        QString name = QString("notify_%1").arg(i - 78, 3, 10, QChar('0'));
        QString path = QString("qrc:/resources/sounds/sound_%1.wav").arg(i, 3, 10, QChar('0'));
        QSoundEffect *effect = new QSoundEffect(this);
        effect->setSource(QUrl(path));
        effect->setVolume(m_volume);
        m_sounds[name] = effect;
    }
}

QSoundEffect* SoundMixer::getSound(const QString &name)
{
    return m_sounds.value(name, nullptr);
}

void SoundMixer::playClick(const QString &pack)
{
    if (pack == "off") return;

    // Map pack name to sound index
    int index = 1;
    if (pack == "mechanical") index = 1;
    else if (pack == "soft") index = 2;
    else if (pack == "clicky") index = 3;
    else if (pack == "linear") index = 4;
    else if (pack == "tactile") index = 5;
    else if (pack == "vintage") index = 6;
    else if (pack == "modern") index = 7;
    else if (pack == "gaming") index = 8;
    else if (pack == "office") index = 9;
    else if (pack == "silent") index = 10;
    else if (pack == "loud") index = 11;

    QString name = QString("click_%1").arg(index, 3, 10, QChar('0'));
    if (auto sound = getSound(name)) {
        sound->play();
    }
}

void SoundMixer::playError(const QString &pack)
{
    if (pack == "off") return;

    int index = 1;
    if (pack == "buzz") index = 1;
    else if (pack == "beep") index = 2;
    else if (pack == "chime") index = 3;
    else if (pack == "alert") index = 4;
    else if (pack == "pop") index = 5;
    else if (pack == "click") index = 6;
    else if (pack == "ding") index = 7;
    else if (pack == "bloop") index = 8;
    else if (pack == "snap") index = 9;
    else if (pack == "thud") index = 10;
    else if (pack == "ping") index = 11;

    QString name = QString("error_%1").arg(index, 3, 10, QChar('0'));
    if (auto sound = getSound(name)) {
        sound->play();
    }
}

void SoundMixer::playComplete()
{
    if (auto sound = getSound("complete")) {
        sound->play();
    }
}

void SoundMixer::playNotification()
{
    if (auto sound = getSound("notify_001")) {
        sound->play();
    }
}

void SoundMixer::preview(const QString &pack)
{
    playClick(pack);
    playError(pack);
}