#ifndef TRANSLATIONMANAGER_H
#define TRANSLATIONMANAGER_H

#include <QObject>
#include <QStringList>

class TranslationManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentLanguage READ currentLanguage NOTIFY currentLanguageChanged)

public:
    explicit TranslationManager(QObject *parent = nullptr);
    ~TranslationManager() = default;

    QString currentLanguage() const { return m_currentLanguage; }

    Q_INVOKABLE void setLanguage(const QString &locale);
    Q_INVOKABLE QStringList availableLanguages() const;

signals:
    void currentLanguageChanged();

private:
    QString m_currentLanguage = "en";
    QStringList m_availableLanguages = {"en", "es", "fr", "de", "it", "pt"};
};

#endif // TRANSLATIONMANAGER_H
