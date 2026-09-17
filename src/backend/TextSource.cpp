#include "TextSource.h"
#include "ContentCatalog.h"
#include <QQmlEngine>
#include <QQmlContext>
#include <QRandomGenerator>

TextSource::TextSource(QObject *parent)
    : QObject(parent)
{
    // Use fallback initially, will be updated when ContentCatalog is available
    m_languages = {"english"};
    m_wordList = {
        "the", "be", "to", "of", "and", "a", "in", "that", "have", "I",
        "it", "for", "not", "on", "with", "he", "as", "you", "do", "at",
        "this", "but", "his", "by", "from", "they", "we", "say", "her", "she",
        "or", "an", "will", "my", "one", "all", "would", "there", "their", "what",
        "so", "up", "out", "if", "about", "who", "get", "which", "go", "me",
        "when", "make", "can", "like", "time", "no", "just", "him", "know", "take",
        "people", "into", "year", "your", "good", "some", "could", "them", "see",
        "other", "than", "then", "now", "look", "only", "come", "its", "over",
        "think", "also", "back", "after", "use", "two", "how", "our", "work",
        "first", "well", "way", "even", "new", "want", "because", "any", "these",
        "give", "day", "most", "us", "great", "between", "need", "large", "under",
        "never", "each", "right", "begin", "too", "same", "tell", "does", "set",
        "three", "high", "keep", "last", "let", "thought", "too", "here", "why",
        "try", "ask", "men", "ran", "own", "say", "she", "many", "some", "would",
        "write", "like", "so", "these", "her", "long", "make", "thing", "see",
        "him", "two", "has", "look", "more", "day", "could", "go", "come", "did"
    };
    m_quotes = {
        "Life is like riding a bicycle. To keep your balance you must keep moving. - Albert Einstein",
        "The only way to do great work is to love what you do. - Steve Jobs",
        "Innovation distinguishes between a leader and a follower. - Steve Jobs",
        "Your time is limited, don't waste it living someone else's life. - Steve Jobs",
        "Stay hungry, stay foolish. - Steve Jobs"
    };
}

void TextSource::setCurrentLanguage(const QString &lang)
{
    if (m_currentLanguage != lang) {
        m_currentLanguage = lang;
        emit currentLanguageChanged();

        // Try to get ContentCatalog from context
        ContentCatalog *catalog = getCatalog();
        if (catalog) {
            m_wordList = catalog->wordsForLanguage(lang);
            m_quotes = catalog->quotes(lang);
        }
    }
}

ContentCatalog* TextSource::getCatalog()
{
    QQmlEngine *engine = qmlEngine(this);
    if (!engine) return nullptr;

    QObject *ctx = engine->rootContext()->contextProperty("ContentCatalog").value<QObject*>();
    if (!ctx) return nullptr;

    return qobject_cast<ContentCatalog*>(ctx);
}

QString TextSource::generateWords(int count)
{
    if (m_wordList.isEmpty()) return "";

    QStringList words;
    auto *rng = QRandomGenerator::global();

    for (int i = 0; i < count; i++) {
        int idx = rng->bounded(m_wordList.size());
        words.append(m_wordList.at(idx));
    }

    return words.join(" ");
}

QString TextSource::generateTimed(int seconds)
{
    int wordCount = seconds * 3;
    return generateWords(wordCount);
}

QString TextSource::generateQuote()
{
    if (m_quotes.isEmpty()) return "";
    auto *rng = QRandomGenerator::global();
    int idx = rng->bounded(m_quotes.size());
    return m_quotes.at(idx);
}

QString TextSource::generateCustom(const QString &text)
{
    return text;
}

QVariantList TextSource::getAdaptiveKeys(int count)
{
    QVariantList keys;
    return keys;
}

QString TextSource::generateAdaptiveText(const QVariantList &weakKeys, int wordCount)
{
    // Filter word list to include words with weak keys
    QStringList filteredWords;
    for (const QString &word : m_wordList) {
        for (const QVariant &kVar : weakKeys) {
            QString k = kVar.toString();
            if (word.contains(k, Qt::CaseInsensitive)) {
                filteredWords.append(word);
                break;
            }
        }
    }

    if (filteredWords.isEmpty()) {
        filteredWords = m_wordList;
    }

    QStringList words;
    auto *rng = QRandomGenerator::global();
    for (int i = 0; i < wordCount; i++) {
        int idx = rng->bounded(filteredWords.size());
        words.append(filteredWords.at(idx));
    }

    return words.join(" ");
}

void TextSource::setWordList(const QStringList &words)
{
    m_wordList = words;
}