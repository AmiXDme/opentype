#include "KeyboardLayout.h"
#include "ContentCatalog.h"
#include <QQmlEngine>
#include <QQmlContext>

KeyboardLayout::KeyboardLayout(QObject *parent)
    : QObject(parent)
{
    loadLayout("qwerty");
}

void KeyboardLayout::loadLayout(const QString &name)
{
    m_name = name;
    m_valid = true;

    m_rows.clear();

    // Get ContentCatalog instance from QML engine
    ContentCatalog *catalog = nullptr;
    QQmlEngine *engine = qmlEngine(this);
    if (engine) {
        QObject *ctx = engine->rootContext()->contextProperty("ContentCatalog").value<QObject*>();
        if (ctx) {
            catalog = qobject_cast<ContentCatalog*>(ctx);
        }
    }

    QVariantMap layoutData;
    if (catalog) {
        layoutData = catalog->keyboardLayout(name);
    }

    if (!layoutData.isEmpty() && layoutData.contains("rows")) {
        QVariantList rows = layoutData["rows"].toList();
        for (const QVariant &rowVar : rows) {
            QVariantList row = rowVar.toList();
            QVariantList newRow;
            for (const QVariant &keyVar : row) {
                QVariantMap keyMap = keyVar.toMap();
                QVariantMap fullKey;
                fullKey["key"] = keyMap.value("base", "");
                fullKey["shift"] = keyMap.value("shift", "");
                fullKey["home"] = keyMap.value("home", false);
                fullKey["width"] = keyMap.value("width", 1);
                fullKey["space"] = keyMap.value("space", false);
                fullKey["finger"] = keyMap.value("finger", defaultFingerForKey(fullKey["key"].toString()));
                newRow.append(fullKey);
            }
            m_rows.append(QVariant::fromValue(newRow));
        }
        // Add space row if not present
        bool hasSpace = false;
        for (const QVariant &rowVar : m_rows) {
            QVariantList row = rowVar.toList();
            for (const QVariant &keyVar : row) {
                if (keyVar.toMap().value("space").toBool()) {
                    hasSpace = true;
                    break;
                }
            }
        }
        if (!hasSpace) {
            QVariantList spaceRow;
            spaceRow.append(QVariantMap{{"key", " "}, {"shift", ""}, {"home", false}, {"width", 6}, {"space", true}, {"finger", "thumb"}});
            m_rows.append(QVariant::fromValue(spaceRow));
        }
    } else {
        // Fallback to QWERTY
        loadDefaultLayout();
    }

    emit nameChanged();
    emit isValidChanged();
}

void KeyboardLayout::loadDefaultLayout()
{
    m_name = "qwerty";
    m_valid = true;
    m_rows.clear();

    auto addRow = [&](const QStringList &keys, const QStringList &fingers) {
        QVariantList row;
        for (int i = 0; i < keys.size(); ++i) {
            QString key = keys[i];
            QString finger = (i < fingers.size()) ? fingers[i] : "left_index";
            bool isHome = (key == "a" || key == "s" || key == "d" || key == "f" || key == "j" || key == "k" || key == "l");
            row.append(QVariantMap{{"key", key}, {"shift", key.toUpper()}, {"home", isHome}, {"width", 1}, {"space", false}, {"finger", finger}});
        }
        m_rows.append(QVariant::fromValue(row));
    };

    addRow({"`","1","2","3","4","5","6","7","8","9","0","-","="}, {"left_pinky","left_pinky","left_ring","left_middle","left_index","left_index","right_index","right_index","right_middle","right_ring","right_pinky","right_pinky","right_pinky"});
    addRow({"q","w","e","r","t","y","u","i","o","p","[","]"}, {"left_pinky","left_ring","left_middle","left_index","left_index","right_index","right_index","right_middle","right_ring","right_pinky","right_pinky","right_pinky"});
    addRow({"a","s","d","f","g","h","j","k","l",";","'"}, {"left_pinky","left_ring","left_middle","left_index","left_index","right_index","right_index","right_middle","right_ring","right_pinky","right_pinky"});
    addRow({"z","x","c","v","b","n","m",",",".","/"}, {"left_pinky","left_ring","left_middle","left_index","left_index","right_index","right_index","right_middle","right_ring","right_pinky"});

    // Space row
    QVariantList spaceRow;
    spaceRow.append(QVariantMap{{"key", " "}, {"shift", ""}, {"home", false}, {"width", 6}, {"space", true}, {"finger", "thumb"}});
    m_rows.append(QVariant::fromValue(spaceRow));

    emit nameChanged();
    emit isValidChanged();
}

QVariantList KeyboardLayout::rows() const
{
    return m_rows;
}

QVariantMap KeyboardLayout::keyInfo(const QString &key) const
{
    for (const QVariant &rowVar : m_rows) {
        QVariantList row = rowVar.toList();
        for (const QVariant &keyVar : row) {
            QVariantMap keyMap = keyVar.toMap();
            if (keyMap["key"].toString() == key) {
                return keyMap;
            }
        }
    }
    return QVariantMap();
}

QString KeyboardLayout::defaultFingerForKey(const QString &key) const
{
    if (key == "a") return "left_pinky";
    if (key == "s") return "left_ring";
    if (key == "d") return "left_middle";
    if (key == "f") return "left_index";
    if (key == "g") return "left_index";
    if (key == "h") return "right_index";
    if (key == "j") return "right_index";
    if (key == "k") return "right_middle";
    if (key == "l") return "right_ring";
    if (key == ";") return "right_pinky";
    if (key == "'") return "right_pinky";
    if (key == "z") return "left_pinky";
    if (key == "x") return "left_ring";
    if (key == "c") return "left_middle";
    if (key == "v") return "left_index";
    if (key == "b") return "left_index";
    if (key == "n") return "right_index";
    if (key == "m") return "right_index";
    if (key == ",") return "right_middle";
    if (key == ".") return "right_ring";
    if (key == "/") return "right_pinky";
    if (key == " ") return "thumb";
    if (key == "q") return "left_pinky";
    if (key == "w") return "left_ring";
    if (key == "e") return "left_middle";
    if (key == "r") return "left_index";
    if (key == "t") return "left_index";
    if (key == "y") return "right_index";
    if (key == "u") return "right_index";
    if (key == "i") return "right_middle";
    if (key == "o") return "right_ring";
    if (key == "p") return "right_pinky";
    if (key == "[") return "right_pinky";
    if (key == "]") return "right_pinky";
    if (key == "`") return "left_pinky";
    if (key == "1") return "left_pinky";
    if (key == "2") return "left_ring";
    if (key == "3") return "left_middle";
    if (key == "4") return "left_index";
    if (key == "5") return "left_index";
    if (key == "6") return "right_index";
    if (key == "7") return "right_index";
    if (key == "8") return "right_middle";
    if (key == "9") return "right_ring";
    if (key == "0") return "right_pinky";
    if (key == "-") return "right_pinky";
    if (key == "=") return "right_pinky";
    return "left_index";
}

int KeyboardLayout::fingerForKey(const QString &key) const
{
    QVariantMap info = keyInfo(key);
    QString finger = info["finger"].toString();

    if (finger == "left_pinky") return 0;
    if (finger == "left_ring") return 1;
    if (finger == "left_middle") return 2;
    if (finger == "left_index") return 3;
    if (finger == "thumb") return 4;
    if (finger == "right_index") return 5;
    if (finger == "right_middle") return 6;
    if (finger == "right_ring") return 7;
    if (finger == "right_pinky") return 8;

    return -1;
}