#ifndef CONTENTCATALOG_H
#define CONTENTCATALOG_H

#include <QObject>
#include <QStringList>
#include <QVariantMap>
#include <QVariantList>

class ContentCatalog : public QObject
{
    Q_OBJECT

public:
    explicit ContentCatalog(QObject *parent = nullptr);
    ~ContentCatalog() = default;

    Q_INVOKABLE QStringList languages() const;
    Q_INVOKABLE QStringList layouts() const;
    Q_INVOKABLE QVariantMap languageInfo(const QString &lang) const;
    Q_INVOKABLE QStringList quotes() const;
    Q_INVOKABLE QStringList wordsForLanguage(const QString &lang) const;

private:
    void loadData();

    QStringList m_languages;
    QStringList m_layouts;
    QMap<QString, QStringList> m_words;
    QStringList m_quotes;
};

#endif // CONTENTCATALOG_H
