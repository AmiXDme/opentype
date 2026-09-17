#ifndef TYPINGENGINE_H
#define TYPINGENGINE_H

#include <QObject>
#include <QTimer>
#include <QElapsedTimer>
#include <QVariantMap>
#include <QVariantList>
#include <QChar>

class TypingEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool running READ isRunning NOTIFY runningChanged)
    Q_PROPERTY(int targetPosition READ targetPosition NOTIFY targetPositionChanged)
    Q_PROPERTY(int correctCount READ correctCount NOTIFY correctCountChanged)
    Q_PROPERTY(int errorCount READ errorCount NOTIFY errorCountChanged)
    Q_PROPERTY(int totalKeystrokes READ totalKeystrokes NOTIFY totalKeystrokesChanged)
    Q_PROPERTY(qreal wpm READ wpm NOTIFY wpmChanged)
    Q_PROPERTY(qreal rawWpm READ rawWpm NOTIFY rawWpmChanged)
    Q_PROPERTY(qreal accuracy READ accuracy NOTIFY accuracyChanged)
    Q_PROPERTY(qreal elapsedMs READ elapsedMs NOTIFY elapsedMsChanged)
    Q_PROPERTY(QString targetText READ targetText NOTIFY targetTextChanged)
    Q_PROPERTY(QString typedText READ typedText NOTIFY typedTextChanged)
    Q_PROPERTY(QString mode READ mode NOTIFY modeChanged)
    Q_PROPERTY(QString language READ language NOTIFY languageChanged)
    Q_PROPERTY(QString layout READ layout NOTIFY layoutChanged)

public:
    explicit TypingEngine(QObject *parent = nullptr);
    ~TypingEngine() = default;

    bool isRunning() const { return m_running; }
    int targetPosition() const { return m_targetPosition; }
    int correctCount() const { return m_correctCount; }
    int errorCount() const { return m_errorCount; }
    int totalKeystrokes() const { return m_totalKeystrokes; }
    qreal wpm() const;
    qreal rawWpm() const;
    qreal accuracy() const;
    qreal elapsedMs() const { return m_elapsedMs; }
    QString targetText() const { return m_targetText; }
    QString typedText() const { return m_typedText; }
    QString mode() const { return m_mode; }
    QString language() const { return m_language; }
    QString layout() const { return m_layout; }

    Q_INVOKABLE void startSession(const QString &mode, const QString &language, const QString &layout);
    Q_INVOKABLE void setTargetText(const QString &text);
    Q_INVOKABLE void processKey(QChar character);
    Q_INVOKABLE void endSession();
    Q_INVOKABLE QVariantMap getStats() const;
    Q_INVOKABLE QVariantList getKeyStats() const;
    Q_INVOKABLE QVariantList getSamples() const;

signals:
    void runningChanged();
    void targetPositionChanged();
    void correctCountChanged();
    void errorCountChanged();
    void totalKeystrokesChanged();
    void wpmChanged();
    void rawWpmChanged();
    void accuracyChanged();
    void elapsedMsChanged();
    void targetTextChanged();
    void typedTextChanged();
    void modeChanged();
    void languageChanged();
    void layoutChanged();
    void sessionComplete();
    void keyTyped(bool correct, const QString &key);

private slots:
    void updateElapsed();

private:
    void reset();
    void calculateStats();

    bool m_running = false;
    int m_targetPosition = 0;
    int m_correctCount = 0;
    int m_errorCount = 0;
    int m_totalKeystrokes = 0;
    qreal m_elapsedMs = 0;
    qreal m_wpm = 0;
    qreal m_rawWpm = 0;
    qreal m_accuracy = 0;

    QString m_targetText;
    QString m_typedText;
    QString m_mode;
    QString m_language;
    QString m_layout;

    QElapsedTimer m_elapsedTimer;
    QTimer m_updateTimer;

    struct KeyStat {
        int attempts = 0;
        int correct = 0;
        int errors = 0;
        qreal totalTime = 0;
    };
    QMap<QString, KeyStat> m_keyStats;
};

#endif // TYPINGENGINE_H
