#ifndef TEXTSOURCE_H
#define TEXTSOURCE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QStringList>
#include <QRandomGenerator>

class ContentCatalog;

class TextSource : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList languages READ languages NOTIFY languagesChanged)
    Q_PROPERTY(QString currentLanguage READ currentLanguage WRITE setCurrentLanguage NOTIFY currentLanguageChanged)

public:
    explicit TextSource(QObject *parent = nullptr);
    ~TextSource() = default;

    QStringList languages() const { return m_languages; }
    QString currentLanguage() const { return m_currentLanguage; }
    void setCurrentLanguage(const QString &lang);

    Q_INVOKABLE QString generateWords(int count);
    Q_INVOKABLE QString generateTimed(int seconds);
    Q_INVOKABLE QString generateQuote();
    Q_INVOKABLE QString generateCustom(const QString &text);
    Q_INVOKABLE QVariantList getAdaptiveKeys(int count);
    Q_INVOKABLE QString generateAdaptiveText(const QVariantList &weakKeys, int wordCount);
    Q_INVOKABLE void setWordList(const QStringList &words);

signals:
    void languagesChanged();
    void currentLanguageChanged();

private:
    QStringList m_languages;
    QString m_currentLanguage = "english";
    QStringList m_wordList;
    QStringList m_quotes;

    ContentCatalog* getCatalog();
};

#endif // TEXTSOURCE_H