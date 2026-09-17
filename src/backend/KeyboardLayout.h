#ifndef KEYBOARDLAYOUT_H
#define KEYBOARDLAYOUT_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class KeyboardLayout : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(bool isValid READ isValid NOTIFY isValidChanged)

public:
    explicit KeyboardLayout(QObject *parent = nullptr);
    ~KeyboardLayout() = default;

    QString name() const { return m_name; }
    bool isValid() const { return m_valid; }

    Q_INVOKABLE void loadLayout(const QString &name);
    Q_INVOKABLE QVariantList rows() const;
    Q_INVOKABLE QVariantMap keyInfo(const QString &key) const;
    Q_INVOKABLE int fingerForKey(const QString &key) const;

signals:
    void nameChanged();
    void isValidChanged();

private:
    QString m_name = "qwerty";
    bool m_valid = false;
    QVariantList m_rows;

    void loadDefaultLayout();
    QString defaultFingerForKey(const QString &key) const;
};

#endif // KEYBOARDLAYOUT_H