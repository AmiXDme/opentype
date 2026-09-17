#include "TranslationManager.h"

TranslationManager::TranslationManager(QObject *parent)
    : QObject(parent)
{
}

void TranslationManager::setLanguage(const QString &locale)
{
    if (m_currentLanguage != locale) {
        m_currentLanguage = locale;
        emit currentLanguageChanged();
    }
}

QStringList TranslationManager::availableLanguages() const
{
    return m_availableLanguages;
}
