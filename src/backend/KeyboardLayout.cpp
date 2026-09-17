#include "KeyboardLayout.h"

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

    QVariantList row0;
    row0.append(QVariantMap{{"key", "`"}, {"shift", "~"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_pinky"}});
    row0.append(QVariantMap{{"key", "1"}, {"shift", "!"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_pinky"}});
    row0.append(QVariantMap{{"key", "2"}, {"shift", "@"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_ring"}});
    row0.append(QVariantMap{{"key", "3"}, {"shift", "#"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_middle"}});
    row0.append(QVariantMap{{"key", "4"}, {"shift", "$"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_index"}});
    row0.append(QVariantMap{{"key", "5"}, {"shift", "%"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_index"}});
    row0.append(QVariantMap{{"key", "6"}, {"shift", "^"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_index"}});
    row0.append(QVariantMap{{"key", "7"}, {"shift", "&"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_index"}});
    row0.append(QVariantMap{{"key", "8"}, {"shift", "*"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_middle"}});
    row0.append(QVariantMap{{"key", "9"}, {"shift", "("}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_ring"}});
    row0.append(QVariantMap{{"key", "0"}, {"shift", ")"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_pinky"}});
    row0.append(QVariantMap{{"key", "-"}, {"shift", "_"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_pinky"}});
    row0.append(QVariantMap{{"key", "="}, {"shift", "+"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_pinky"}});
    m_rows.append(QVariant::fromValue(row0));

    QVariantList row1;
    row1.append(QVariantMap{{"key", "q"}, {"shift", "Q"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_pinky"}});
    row1.append(QVariantMap{{"key", "w"}, {"shift", "W"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_ring"}});
    row1.append(QVariantMap{{"key", "e"}, {"shift", "E"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_middle"}});
    row1.append(QVariantMap{{"key", "r"}, {"shift", "R"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_index"}});
    row1.append(QVariantMap{{"key", "t"}, {"shift", "T"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_index"}});
    row1.append(QVariantMap{{"key", "y"}, {"shift", "Y"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_index"}});
    row1.append(QVariantMap{{"key", "u"}, {"shift", "U"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_index"}});
    row1.append(QVariantMap{{"key", "i"}, {"shift", "I"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_middle"}});
    row1.append(QVariantMap{{"key", "o"}, {"shift", "O"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_ring"}});
    row1.append(QVariantMap{{"key", "p"}, {"shift", "P"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_pinky"}});
    m_rows.append(QVariant::fromValue(row1));

    QVariantList row2;
    row2.append(QVariantMap{{"key", "a"}, {"shift", "A"}, {"home", true}, {"width", 1}, {"space", false}, {"finger", "left_pinky"}});
    row2.append(QVariantMap{{"key", "s"}, {"shift", "S"}, {"home", true}, {"width", 1}, {"space", false}, {"finger", "left_ring"}});
    row2.append(QVariantMap{{"key", "d"}, {"shift", "D"}, {"home", true}, {"width", 1}, {"space", false}, {"finger", "left_middle"}});
    row2.append(QVariantMap{{"key", "f"}, {"shift", "F"}, {"home", true}, {"width", 1}, {"space", false}, {"finger", "left_index"}});
    row2.append(QVariantMap{{"key", "g"}, {"shift", "G"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_index"}});
    row2.append(QVariantMap{{"key", "h"}, {"shift", "H"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_index"}});
    row2.append(QVariantMap{{"key", "j"}, {"shift", "J"}, {"home", true}, {"width", 1}, {"space", false}, {"finger", "right_index"}});
    row2.append(QVariantMap{{"key", "k"}, {"shift", "K"}, {"home", true}, {"width", 1}, {"space", false}, {"finger", "right_middle"}});
    row2.append(QVariantMap{{"key", "l"}, {"shift", "L"}, {"home", true}, {"width", 1}, {"space", false}, {"finger", "right_ring"}});
    row2.append(QVariantMap{{"key", ";"}, {"shift", ":"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_pinky"}});
    row2.append(QVariantMap{{"key", "'"}, {"shift", "\""}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_pinky"}});
    m_rows.append(QVariant::fromValue(row2));

    QVariantList row3;
    row3.append(QVariantMap{{"key", "z"}, {"shift", "Z"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_pinky"}});
    row3.append(QVariantMap{{"key", "x"}, {"shift", "X"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_ring"}});
    row3.append(QVariantMap{{"key", "c"}, {"shift", "C"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_middle"}});
    row3.append(QVariantMap{{"key", "v"}, {"shift", "V"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_index"}});
    row3.append(QVariantMap{{"key", "b"}, {"shift", "B"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "left_index"}});
    row3.append(QVariantMap{{"key", "n"}, {"shift", "N"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_index"}});
    row3.append(QVariantMap{{"key", "m"}, {"shift", "M"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_index"}});
    row3.append(QVariantMap{{"key", ","}, {"shift", "<"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_middle"}});
    row3.append(QVariantMap{{"key", "."}, {"shift", ">"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_ring"}});
    row3.append(QVariantMap{{"key", "/"}, {"shift", "?"}, {"home", false}, {"width", 1}, {"space", false}, {"finger", "right_pinky"}});
    m_rows.append(QVariant::fromValue(row3));

    QVariantList row4;
    row4.append(QVariantMap{{"key", " "}, {"shift", ""}, {"home", false}, {"width", 6}, {"space", true}, {"finger", "thumb"}});
    m_rows.append(QVariant::fromValue(row4));

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
