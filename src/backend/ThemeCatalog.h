#ifndef THEMECATALOG_H
#define THEMECATALOG_H

#include <QObject>
#include <QVariantMap>
#include <QStringList>
#include <QVariant>

class ThemeCatalog : public QObject
{
    Q_OBJECT

public:
    explicit ThemeCatalog(QObject *parent = nullptr);
    ~ThemeCatalog() = default;

    Q_INVOKABLE QVariantMap colors(const QString &name) const;
    Q_INVOKABLE QStringList presetNames() const;
    Q_INVOKABLE QString randomTheme(const QString &mode) const;
    Q_INVOKABLE QStringList themeNames() const;

private:
    void loadThemes();

    struct ThemeColors {
        QString bg;
        QString main;
        QString caret;
        QString sub;
        QString subAlt;
        QString text;
        QString error;
        QString errorExtra;
    };

    QMap<QString, ThemeColors> m_themes;
};

#endif // THEMECATALOG_H
