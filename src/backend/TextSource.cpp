#include "TextSource.h"

TextSource::TextSource(QObject *parent)
    : QObject(parent)
{
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
    }
}

QString TextSource::generateWords(int count)
{
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
    return generateWords(wordCount);
}

void TextSource::setWordList(const QStringList &words)
{
    m_wordList = words;
}
