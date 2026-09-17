#ifndef CONTENTCATALOG_H
#define CONTENTCATALOG_H

#include <QObject>
#include <QStringList>
#include <QVariantMap>
#include <QVariantList>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

class ContentCatalog : public QObject
{
    Q_OBJECT

public:
    explicit ContentCatalog(QObject *parent = nullptr);
    ~ContentCatalog() = default;

    Q_INVOKABLE QStringList languages() const;
    Q_INVOKABLE QStringList layouts() const;
    Q_INVOKABLE QVariantMap languageInfo(const QString &lang) const;
    Q_INVOKABLE QStringList quotes(const QString &language) const;
    Q_INVOKABLE QStringList wordsForLanguage(const QString &lang) const;
    Q_INVOKABLE QVariantMap keyboardLayout(const QString &layout) const;
    Q_INVOKABLE QVariantList allLayouts() const;

private:
    void loadData();
    void loadQuotes();
    void loadKeyboardLayouts();
    void loadWords();
    void loadLanguages();
    void loadDefaultLayouts();
    void loadDefaultWords();
    QVariantMap parseLayout(const QJsonObject &obj) const;

    QStringList m_languages;
    QStringList m_layouts;
    QMap<QString, QStringList> m_words;
    QMap<QString, QStringList> m_quotes;
    QMap<QString, QVariantMap> m_layoutData;
};

#endif // CONTENTCATALOG_H