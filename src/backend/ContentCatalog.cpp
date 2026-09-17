#include "ContentCatalog.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

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
    info["quoteCount"] = m_quotes.value(lang).size();
    info["wordCount"] = m_words.value(lang).size();
    return info;
}

QStringList ContentCatalog::quotes(const QString &language) const
{
    return m_quotes.value(language, m_quotes.value("english"));
}

QStringList ContentCatalog::wordsForLanguage(const QString &lang) const
{
    return m_words.value(lang, m_words.value("english"));
}

QVariantMap ContentCatalog::keyboardLayout(const QString &layout) const
{
    return m_layoutData.value(layout, m_layoutData.value("qwerty"));
}

QVariantList ContentCatalog::allLayouts() const
{
    QVariantList list;
    for (const QString &layout : m_layouts) {
        QVariantMap map;
        map["id"] = layout;
        map["name"] = layout.toUpper();
        map["data"] = m_layoutData.value(layout);
        list.append(map);
    }
    return list;
}

void ContentCatalog::loadData()
{
    loadQuotes();
    loadKeyboardLayouts();
    loadWords();
    loadLanguages();
}

void ContentCatalog::loadQuotes()
{
    QFile file(":/resources/data/extracted/quotes-extracted.json");
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open quotes-extracted.json";
        return;
    }

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (doc.isNull() || !doc.isArray()) {
        qWarning() << "Failed to parse quotes-extracted.json";
        return;
    }

    QJsonArray collections = doc.array();

    for (const QJsonValue &colVal : collections) {
        QJsonObject col = colVal.toObject();
        QString lang = col["language"].toString().toLower();
        QJsonArray quotes = col["quotes"].toArray();

        QStringList langQuotes;
        langQuotes.reserve(quotes.size());

        for (const QJsonValue &qVal : quotes) {
            QJsonObject q = qVal.toObject();
            QString text = q["text"].toString();
            QString source = q["source"].toString();

            QString quote = text;
            if (!source.isEmpty() && source != "Unknown") {
                quote += " — " + source;
            }
            langQuotes.append(quote);
        }

        if (!langQuotes.isEmpty()) {
            m_quotes[lang] = langQuotes;
            if (!m_languages.contains(lang)) {
                m_languages.append(lang);
            }
        }
    }

    // Ensure english is always available
    if (!m_quotes.contains("english")) {
        m_quotes["english"] = {
            "Life is like riding a bicycle. To keep your balance you must keep moving. - Albert Einstein",
            "The only way to do great work is to love what you do. - Steve Jobs",
            "Innovation distinguishes between a leader and a follower. - Steve Jobs"
        };
    }
    if (!m_languages.contains("english")) {
        m_languages.prepend("english");
    }

    qDebug() << "Loaded" << m_quotes.size() << "quote languages with total quotes";
    for (auto it = m_quotes.begin(); it != m_quotes.end(); ++it) {
        qDebug() << "  " << it.key() << ":" << it.value().size();
    }
}

void ContentCatalog::loadKeyboardLayouts()
{
    QFile file(":/resources/data/extracted/keyboard-layouts-extracted.json");
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open keyboard-layouts-extracted.json";
        loadDefaultLayouts();
        return;
    }

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (doc.isNull() || !doc.isArray()) {
        qWarning() << "Failed to parse keyboard-layouts-extracted.json";
        loadDefaultLayouts();
        return;
    }

    QJsonArray layouts = doc.array();

    // Layout names for each extracted layout
    QStringList layoutNames = {
        "qwerty", "qwerty_alt", "russian", "persian", "arabic", "arabic_morocco",
        "hebrew", "greek", "turkish_f", "turkish_q", "azerty", "qwertz",
        "colemak", "dvorak", "korean", "japanese", "chinese", "thai",
        "vietnamese", "bengali", "devanagari", "tamil", "gujarati", "kannada",
        "malayalam", "sinhala"
    };

    for (int i = 0; i < layouts.size() && i < layoutNames.size(); ++i) {
        QJsonObject obj = layouts[i].toObject();
        QString id = layoutNames[i];

        m_layouts.append(id);
        m_layoutData[id] = parseLayout(obj);
    }

    if (m_layouts.isEmpty()) {
        loadDefaultLayouts();
    }

    qDebug() << "Loaded" << m_layouts.size() << "keyboard layouts";
}

QVariantMap ContentCatalog::parseLayout(const QJsonObject &obj) const
{
    QVariantMap layout;
    layout["id"] = obj.value("id").toString();

    QVariantList rows;
    for (int r = 1; r <= 5; ++r) {
        QString key = QString("row%1").arg(r);
        if (obj.contains(key)) {
            QJsonArray row = obj[key].toArray();
            QVariantList rowKeys;
            for (const QJsonValue &kVal : row) {
                QJsonArray keyPair = kVal.toArray();
                if (keyPair.size() >= 1) {
                    QVariantMap keyMap;
                    keyMap["base"] = keyPair[0].toString();
                    keyMap["shift"] = keyPair.size() > 1 ? keyPair[1].toString() : keyPair[0].toString().toUpper();
                    rowKeys.append(keyMap);
                }
            }
            rows.append(rowKeys);
        }
    }
    layout["rows"] = rows;

    return layout;
}

void ContentCatalog::loadWords()
{
    QFile file(":/resources/data/extracted/words-extracted.json");
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open words-extracted.json, using defaults";
        loadDefaultWords();
        return;
    }

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (doc.isNull() || !doc.isArray()) {
        qWarning() << "Failed to parse words-extracted.json, using defaults";
        loadDefaultWords();
        return;
    }

    QJsonArray words = doc.array();

    QStringList englishWords;
    englishWords.reserve(words.size());

    for (const QJsonValue &wVal : words) {
        QString word = wVal.toString().toLower();
        if (word.length() >= 2 && word.length() <= 12 && word.contains(QRegularExpression("^[a-z]+$"))) {
            englishWords.append(word);
        }
    }

    m_words["english"] = englishWords;

    // Create word lists for other languages using the same base (for now)
    for (const QString &lang : m_languages) {
        if (!m_words.contains(lang) && lang != "english") {
            m_words[lang] = englishWords;
        }
    }

    qDebug() << "Loaded" << englishWords.size() << "words for" << m_words.size() << "languages";
}

void ContentCatalog::loadLanguages()
{
    QFile file(":/resources/data/extracted/languages-extracted.json");
    if (!file.open(QIODevice::ReadOnly)) {
        return;
    }

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (doc.isNull()) return;

    // This file contains RTL language configs, just ensure they're in our list
    if (doc.isObject()) {
        QJsonObject root = doc.object();
        if (root.contains("languages")) {
            QJsonArray langs = root["languages"].toArray();
            for (const QJsonValue &lVal : langs) {
                QJsonObject l = lVal.toObject();
                QString code = l["code"].toString().toLower();
                if (!code.isEmpty() && !m_languages.contains(code)) {
                    m_languages.append(code);
                }
            }
        }
    }
}

void ContentCatalog::loadDefaultLayouts()
{
    m_layouts = {"qwerty", "dvorak", "colemak", "azerty", "qwertz", "russian", "persian", "arabic"};

    // QWERTY
    QVariantMap qwerty;
    qwerty["id"] = "qwerty";
    qwerty["name"] = "QWERTY";
    qwerty["language"] = "english";
    QVariantList qwertyRows;
    auto addRow = [&](const QStringList &keys) {
        QVariantList row;
        for (const QString &k : keys) {
            QVariantMap km; km["base"] = k; km["shift"] = k.toUpper(); row.append(km);
        }
        return row;
    };
    qwertyRows << addRow({"`","1","2","3","4","5","6","7","8","9","0","-","="})
              << addRow({"q","w","e","r","t","y","u","i","o","p","[","]"})
              << addRow({"a","s","d","f","g","h","j","k","l",";","'"})
              << addRow({"z","x","c","v","b","n","m",",",".","/"});
    qwerty["rows"] = qwertyRows;
    m_layoutData["qwerty"] = qwerty;

    // Dvorak
    QVariantMap dvorak;
    dvorak["id"] = "dvorak";
    dvorak["name"] = "Dvorak";
    dvorak["language"] = "english";
    QVariantList dvorakRows;
    dvorakRows << addRow({"`","1","2","3","4","5","6","7","8","9","0","[","]"})
               << addRow({"'","<",">","p","y","f","g","c","r","l","/","="})
               << addRow({"a","o","e","u","i","d","h","t","n","s","-"})
               << addRow({";","q","j","k","x","b","m","w","v","z"});
    dvorak["rows"] = dvorakRows;
    m_layoutData["dvorak"] = dvorak;

    // Colemak
    QVariantMap colemak;
    colemak["id"] = "colemak";
    colemak["name"] = "Colemak";
    colemak["language"] = "english";
    QVariantList colemakRows;
    colemakRows << addRow({"`","1","2","3","4","5","6","7","8","9","0","-","="})
                << addRow({"q","w","f","p","g","j","l","u","y",";","[","]"})
                << addRow({"a","r","s","t","d","h","n","e","i","o","'"})
                << addRow({"z","x","c","v","b","k","m",",",".","/"});
    colemak["rows"] = colemakRows;
    m_layoutData["colemak"] = colemak;

    // Copy for other layouts
    for (const QString &id : {"azerty", "qwertz", "russian", "persian", "arabic"}) {
        if (!m_layoutData.contains(id)) {
            m_layoutData[id] = qwerty;
            m_layoutData[id]["id"] = id;
            m_layoutData[id]["name"] = id.toUpper();
        }
    }
}

void ContentCatalog::loadDefaultWords()
{
    QStringList english = {
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
    m_words["english"] = english;
    if (!m_languages.contains("english")) {
        m_languages = {"english"};
    }
}