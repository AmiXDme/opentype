#include "TypingEngine.h"
#include <QJsonObject>
#include <QJsonArray>

TypingEngine::TypingEngine(QObject *parent)
    : QObject(parent)
{
    connect(&m_updateTimer, &QTimer::timeout, this, &TypingEngine::updateElapsed);
    m_updateTimer.setInterval(100);
}

void TypingEngine::startSession(const QString &mode, const QString &language, const QString &layout)
{
    reset();
    m_mode = mode;
    m_language = language;
    m_layout = layout;
    m_running = true;

    m_elapsedTimer.start();
    m_updateTimer.start();

    emit runningChanged();
    emit modeChanged();
    emit languageChanged();
    emit layoutChanged();
}

void TypingEngine::setTargetText(const QString &text)
{
    m_targetText = text;
    m_targetPosition = 0;
    m_typedText.clear();
    emit targetTextChanged();
    emit typedTextChanged();
    emit targetPositionChanged();
}

void TypingEngine::processKey(QChar character)
{
    if (!m_running || m_targetPosition >= m_targetText.length())
        return;

    m_totalKeystrokes++;

    QChar targetChar = m_targetText.at(m_targetPosition);
    bool correct = (character == targetChar);

    QString keyStr = QString(character);
    if (m_keyStats.contains(keyStr)) {
        m_keyStats[keyStr].attempts++;
        if (correct) {
            m_keyStats[keyStr].correct++;
        } else {
            m_keyStats[keyStr].errors++;
        }
        m_keyStats[keyStr].totalTime += m_elapsedMs;
    } else {
        KeyStat stat;
        stat.attempts = 1;
        stat.correct = correct ? 1 : 0;
        stat.errors = correct ? 0 : 1;
        stat.totalTime = m_elapsedMs;
        m_keyStats[keyStr] = stat;
    }

    if (correct) {
        m_correctCount++;
        emit correctCountChanged();
    } else {
        m_errorCount++;
        emit errorCountChanged();
    }

    m_typedText.append(character);
    m_targetPosition++;

    emit typedTextChanged();
    emit targetPositionChanged();
    emit totalKeystrokesChanged();
    emit keyTyped(correct, keyStr);

    calculateStats();

    if (m_targetPosition >= m_targetText.length()) {
        endSession();
    }
}

void TypingEngine::endSession()
{
    if (!m_running) return;

    m_running = false;
    m_updateTimer.stop();

    calculateStats();

    emit runningChanged();
    emit sessionComplete();
}

QVariantMap TypingEngine::getStats() const
{
    QVariantMap stats;
    stats["wpm"] = m_wpm;
    stats["rawWpm"] = m_rawWpm;
    stats["accuracy"] = m_accuracy;
    stats["correct"] = m_correctCount;
    stats["errors"] = m_errorCount;
    stats["totalKeystrokes"] = m_totalKeystrokes;
    stats["elapsedMs"] = m_elapsedMs;
    stats["mode"] = m_mode;
    stats["language"] = m_language;
    stats["layout"] = m_layout;
    return stats;
}

QVariantList TypingEngine::getKeyStats() const
{
    QVariantList list;
    for (auto it = m_keyStats.constBegin(); it != m_keyStats.constEnd(); ++it) {
        QVariantMap stat;
        stat["key"] = it.key();
        stat["attempts"] = it.value().attempts;
        stat["correct"] = it.value().correct;
        stat["errors"] = it.value().errors;
        stat["errorRate"] = it.value().attempts > 0
            ? static_cast<qreal>(it.value().errors) / it.value().attempts
            : 0.0;
        stat["avgTime"] = it.value().attempts > 0
            ? it.value().totalTime / it.value().attempts
            : 0.0;
        list.append(stat);
    }
    return list;
}

QVariantList TypingEngine::getSamples() const
{
    QVariantList samples;
    return samples;
}

qreal TypingEngine::wpm() const
{
    return m_wpm;
}

qreal TypingEngine::rawWpm() const
{
    return m_rawWpm;
}

qreal TypingEngine::accuracy() const
{
    return m_accuracy;
}

void TypingEngine::updateElapsed()
{
    if (m_running && m_elapsedTimer.isValid()) {
        m_elapsedMs = m_elapsedTimer.elapsed();
        emit elapsedMsChanged();
        calculateStats();
        emit wpmChanged();
        emit rawWpmChanged();
    }
}

void TypingEngine::reset()
{
    m_running = false;
    m_targetPosition = 0;
    m_correctCount = 0;
    m_errorCount = 0;
    m_totalKeystrokes = 0;
    m_elapsedMs = 0;
    m_wpm = 0;
    m_rawWpm = 0;
    m_accuracy = 0;
    m_targetText.clear();
    m_typedText.clear();
    m_keyStats.clear();
    m_updateTimer.stop();
}

void TypingEngine::calculateStats()
{
    qreal minutes = m_elapsedMs / 60000.0;
    if (minutes > 0) {
        m_wpm = (m_correctCount / 5.0) / minutes;
        m_rawWpm = (m_totalKeystrokes / 5.0) / minutes;
    }

    if (m_totalKeystrokes > 0) {
        m_accuracy = static_cast<qreal>(m_correctCount) / m_totalKeystrokes * 100.0;
    }
}
