#include "SoundMixer.h"

SoundMixer::SoundMixer(QObject *parent)
    : QObject(parent)
{
}

void SoundMixer::setVolume(qreal vol)
{
    if (qFuzzyCompare(m_volume, vol)) return;
    m_volume = vol;
    emit volumeChanged();
}

void SoundMixer::playClick(const QString &pack)
{
    if (pack == "off") return;
}

void SoundMixer::playError(const QString &pack)
{
    if (pack == "off") return;
}

void SoundMixer::preview(const QString &pack)
{
    Q_UNUSED(pack)
}
