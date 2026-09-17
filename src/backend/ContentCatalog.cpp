#include "ContentCatalog.h"

ContentCatalog::ContentCatalog(QObject *parent)
    : QObject(parent)
{
    loadData();
}

QStringList ContentCatalog::languages() const
{
    return m_languages;
}

QStringList ContentCatalog::layouts() const
{
    return m_layouts;
}

QVariantMap ContentCatalog::languageInfo(const QString &lang) const
{
    QVariantMap info;
    info["name"] = lang;
    info["layout"] = "qwerty";
    return info;
}

QStringList ContentCatalog::quotes() const
{
    return m_quotes;
}

QStringList ContentCatalog::wordsForLanguage(const QString &lang) const
{
    return m_words.value(lang, m_words.value("english"));
}

void ContentCatalog::loadData()
{
    m_languages = {"english", "spanish", "french", "german", "italian", "portuguese", "russian", "japanese"};
    m_layouts = {"qwerty", "dvorak", "colemak"};

    m_words["english"] = {
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
        "Life is like riding a bicycle. To keep your balance you must keep moving.",
        "The only way to do great work is to love what you do.",
        "Innovation distinguishes between a leader and a follower.",
        "Your time is limited, don't waste it living someone else's life.",
        "Stay hungry, stay foolish.",
        "The greatest glory in living lies not in never falling, but in rising every time we fall.",
        "Tell me and I forget. Teach me and I remember. Involve me and I learn.",
        "The way to get started is to quit talking and begin doing.",
        "If life were predictable it would cease to be life, and be without flavor.",
        "Spread love everywhere you go. Let no one ever come to you without leaving happier."
    };
}
