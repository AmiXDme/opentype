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

void TextSource::setPunctuation(bool on)
{
    if (m_punctuation != on) {
        m_punctuation = on;
        emit punctuationChanged();
    }
}

void TextSource::setNumbers(bool on)
{
    if (m_numbers != on) {
        m_numbers = on;
        emit numbersChanged();
    }
}

QString TextSource::applyExtras(const QString &word)
{
    if (!m_punctuation && !m_numbers) return word;
    auto *rng = QRandomGenerator::global();
    QString out = word;
    if (m_numbers && rng->bounded(100) < 12) {
        static const QStringList nums = {"0","1","2","3","4","5","6","7","8","9","10","25","100"};
        return nums.at(rng->bounded(nums.size()));
    }
    if (m_punctuation && rng->bounded(100) < 18) {
        static const QStringList marks = {".", ",", ";", ":", "!", "?"};
        out += marks.at(rng->bounded(marks.size()));
        if (rng->bounded(100) < 30) {
            out[0] = out[0].toUpper();
        }
    }
    return out;
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
    QStringList words = m_wordList;
    if (ContentCatalog *catalog = getCatalog()) {
        QStringList live = catalog->wordsForLanguage(m_currentLanguage);
        if (!live.isEmpty()) {
            words = live;
            m_wordList = live;
        }
    }
    if (words.isEmpty()) return "";

    QStringList picked;
    auto *rng = QRandomGenerator::global();

    for (int i = 0; i < count; i++) {
        int idx = rng->bounded(words.size());
        picked.append(applyExtras(words.at(idx)));
    }

    return picked.join(" ");
}

QString TextSource::generateTimed(int seconds)
{
    // ~3 words per 2 seconds at moderate pace, scaled by duration
    int wordCount = qMax(10, seconds * 2);
    return generateWords(wordCount);
}

QString TextSource::generateQuote()
{
    QStringList quotes = m_quotes;
    if (ContentCatalog *catalog = getCatalog()) {
        QStringList live = catalog->quotes(m_currentLanguage);
        if (!live.isEmpty()) {
            quotes = live;
            m_quotes = live;
        }
        QStringList langs = catalog->languages();
        if (!langs.isEmpty() && m_languages != langs) {
            m_languages = langs;
            emit languagesChanged();
        }
    }
    if (quotes.isEmpty()) return "";
    auto *rng = QRandomGenerator::global();
    int idx = rng->bounded(quotes.size());
    return quotes.at(idx);
}

QString TextSource::generateCustom(const QString &text)
{
    return text;
}

QVariantList TextSource::getAdaptiveKeys(int count)
{
    QVariantList keys;
    // Return most common weak keys; real stats-driven selection happens in
    // TypingSurface via keyStats. Keep deterministic fallback so adaptive
    // mode always has content instead of an empty list.
    const QStringList fallback = {"e", "t", "a", "o", "i", "n", "s", "r"};
    for (int i = 0; i < count && i < fallback.size(); ++i) {
        keys.append(fallback.at(i));
    }
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