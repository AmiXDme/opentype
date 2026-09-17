#include "ThemeCatalog.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QRandomGenerator>
#include <QDebug>

ThemeCatalog::ThemeCatalog(QObject *parent)
    : QObject(parent)
{
    loadThemes();
}

QVariantMap ThemeCatalog::colors(const QString &name) const
{
    QVariantMap map;
    if (m_themes.contains(name)) {
        const ThemeColors &c = m_themes[name];
        map["bg"] = c.bg;
        map["main"] = c.main;
        map["caret"] = c.caret;
        map["sub"] = c.sub;
        map["subAlt"] = c.subAlt;
        map["text"] = c.text;
        map["error"] = c.error;
        map["errorExtra"] = c.errorExtra;
    }
    return map;
}

QStringList ThemeCatalog::presetNames() const
{
    return m_themes.keys();
}

QStringList ThemeCatalog::themeNames() const
{
    return m_themes.keys();
}

QString ThemeCatalog::randomTheme(const QString &mode) const
{
    QStringList names = m_themes.keys();
    if (names.isEmpty()) return "serika_dark";

    auto *rng = QRandomGenerator::global();
    return names.at(rng->bounded(names.size()));
}

void ThemeCatalog::loadThemes()
{
    // Try loading from extracted themes.json first
    QFile file(":/resources/data/themes.json");
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull()) {
            parseJsonThemes(doc);
            qDebug() << "Loaded" << m_themes.size() << "themes from themes.json";
            return;
        }
    }

    // Fallback to built-in themes
    loadBuiltinThemes();
    qDebug() << "Loaded" << m_themes.size() << "builtin themes";
}

void ThemeCatalog::parseJsonThemes(const QJsonDocument &doc)
{
    QJsonObject root = doc.object();
    if (root.contains("themes")) {
        QJsonValue themesVal = root["themes"];

        if (themesVal.isArray()) {
            // Array format: [{"id": "name", ...}]
            QJsonArray themes = themesVal.toArray();
            for (const QJsonValue &tVal : themes) {
                QJsonObject theme = tVal.toObject();
                QString id = theme["id"].toString();
                if (id.isEmpty()) continue;

                ThemeColors c;
                c.bg = theme["bg"].toString();
                c.main = theme["main"].toString();
                c.caret = theme["caret"].toString();
                c.sub = theme["sub"].toString();
                c.subAlt = theme["subAlt"].toString();
                c.text = theme["text"].toString();
                c.error = theme["error"].toString();
                c.errorExtra = theme["errorExtra"].toString();

                if (!c.bg.isEmpty() && !c.main.isEmpty()) {
                    m_themes[id] = c;
                }
            }
        } else if (themesVal.isObject()) {
            // Object format: {"theme_id": {"bg": "...", ...}}
            QJsonObject themesObj = themesVal.toObject();
            for (auto it = themesObj.begin(); it != themesObj.end(); ++it) {
                QString id = it.key();
                QJsonObject theme = it.value().toObject();

                ThemeColors c;
                c.bg = theme["bg"].toString();
                c.main = theme["main"].toString();
                c.caret = theme["caret"].toString();
                c.sub = theme["sub"].toString();
                c.subAlt = theme["subAlt"].toString();
                c.text = theme["text"].toString();
                c.error = theme["error"].toString();
                c.errorExtra = theme["errorExtra"].toString();

                if (!c.bg.isEmpty() && !c.main.isEmpty()) {
                    m_themes[id] = c;
                }
            }
        }
    }
}

void ThemeCatalog::loadBuiltinThemes()
{
    // Dark themes
    m_themes["yaru_dark"] = {"#2d2d2d", "#e95420", "#e95420", "#77767b", "#242424", "#ffffff", "#ff5555", "#ff5555"};
    m_themes["serika_dark"] = {"#1a1a1a", "#e2b714", "#e2b714", "#5a5a5a", "#151515", "#e0e0e0", "#ca4747", "#ca4747"};
    m_themes["catppuccin"] = {"#1e1e2e", "#89b4fa", "#f5e0dc", "#6c7086", "#181825", "#cdd6f4", "#f38ba8", "#eba0ac"};
    m_themes["dracula"] = {"#282a36", "#bd93f9", "#bd93f9", "#6272a4", "#222236", "#f8f8f2", "#ff5555", "#ff5555"};
    m_themes["monokai"] = {"#272822", "#a6e22e", "#a6e22e", "#75715e", "#1e1f1c", "#f8f8f2", "#f92672", "#f92672"};
    m_themes["nord"] = {"#2e3440", "#88c0d0", "#88c0d0", "#4c566a", "#292e38", "#eceff4", "#bf616a", "#bf616a"};
    m_themes["onedark"] = {"#282c34", "#61afef", "#61afef", "#5c6370", "#21252b", "#abb2bf", "#e06c75", "#e06c75"};
    m_themes["gruvbox_dark"] = {"#282828", "#d79921", "#d79921", "#928374", "#1d2021", "#ebdbb2", "#cc241d", "#fb4934"};
    m_themes["solarized_dark"] = {"#002b36", "#b58900", "#b58900", "#657b83", "#001f27", "#839496", "#dc322f", "#cb4b16"};
    m_themes["tokyo_night"] = {"#1a1b26", "#7aa2f7", "#7aa2f7", "#565f89", "#16161e", "#c0caf5", "#f7768e", "#f7768e"};
    m_themes["rose_pine"] = {"#191724", "#ebbcba", "#ebbcba", "#6e6a86", "#16141f", "#e0def4", "#eb6f92", "#eb6f92"};
    m_themes["ayu_dark"] = {"#0f1419", "#e6b450", "#e6b450", "#4d5b69", "#0d1117", "#e6e6e6", "#ff3333", "#ff3333"};
    m_themes["sonokai"] = {"#2c2e34", "#a277ff", "#a277ff", "#6d6d6d", "#282a30", "#ededef", "#ff6b6b", "#ff6b6b"};
    m_themes["horizon"] = {"#1c1e26", "#e0954f", "#e0954f", "#6c6f93", "#181a22", "#c5c8db", "#e06c75", "#e06c75"};
    m_themes["carbon"] = {"#161616", "#42be65", "#42be65", "#525252", "#111111", "#e0e0e0", "#ff6161", "#ff6161"};
    m_themes["mocha"] = {"#1e1e2e", "#cba6f7", "#f5e0dc", "#6c7086", "#181825", "#cdd6f4", "#f38ba8", "#eba0ac"};
    m_themes["ocean"] = {"#1c262b", "#5fb3b3", "#5fb3b3", "#65737e", "#172024", "#c5c8c6", "#c594c5", "#c594c5"};
    m_themes["breeze"] = {"#23252b", "#3daee9", "#3daee9", "#546779", "#1f2127", "#fcfcfc", "#da4453", "#da4453"};

    // Light themes
    m_themes["yaru"] = {"#f6f5f4", "#e95420", "#e95420", "#77767b", "#deddda", "#2e3436", "#e01b24", "#c01c28"};
    m_themes["serika"] = {"#f6f1eb", "#e2b714", "#e2b714", "#a0a0a0", "#e8e2d6", "#373737", "#ca4747", "#ca4747"};
    m_themes["solarized_light"] = {"#fdf6e3", "#268bd2", "#268bd2", "#93a1a1", "#eee8d5", "#657b83", "#dc322f", "#cb4b16"};
    m_themes["catppuccin_latte"] = {"#eff1f5", "#1e66f5", "#dc8a78", "#9ca0b0", "#e6e9ef", "#4c4f69", "#d20f39", "#e64553"};
    m_themes["gruvbox_light"] = {"#fbf1c7", "#b57614", "#b57614", "#928374", "#f0e8c8", "#3c3836", "#cc241d", "#fb4934"};
    m_themes["paper"] = {"#f4f1ea", "#1280bf", "#1280bf", "#8c8c8c", "#eae7df", "#282c34", "#e06c75", "#e06c75"};
    m_themes["winter"] = {"#e8e8e8", "#4a8af4", "#4a8af4", "#8c8c8c", "#dcdcdc", "#383838", "#e06c75", "#e06c75"};
    m_themes["rose_pine_dawn"] = {"#faf4ed", "#907aa9", "#907aa9", "#9893a5", "#f2e9e1", "#575279", "#b4637a", "#b4637a"};

    // Extra themes
    m_themes["8008"] = {"#343a42", "#f67549", "#f67549", "#526170", "#2a313a", "#d4d4d4", "#ac2f31", "#ac2f31"};
    m_themes["abyss"] = {"#0b0e14", "#39bae6", "#39bae6", "#3e4451", "#0b0e14", "#bfbdb6", "#ff6b6b", "#ff6b6b"};
    m_themes["argon"] = {"#151521", "#7c3aed", "#7c3aed", "#44475a", "#121220", "#f8f8f2", "#ff5555", "#ff5555"};
    m_themes["bento"] = {"#2d2d2d", "#ff7b7b", "#ff7b7b", "#555555", "#2a2a2a", "#bbbbbb", "#ff5555", "#ff5555"};
    m_themes["black_diamond"] = {"#111111", "#ffffff", "#ffffff", "#444444", "#0a0a0a", "#ffffff", "#ff5555", "#ff5555"};
    m_themes["blastoise"] = {"#05051a", "#00d4ff", "#00d4ff", "#2b3d5b", "#040415", "#eeeeff", "#ff5555", "#ff5555"};
    m_themes["bleu"] = {"#0b1021", "#65c2ff", "#65c2ff", "#314162", "#0a0e1c", "#d1e7ff", "#ff6b6b", "#ff6b6b"};
    m_themes["blue_checkers"] = {"#1c2030", "#6d8cff", "#6d8cff", "#3a4569", "#171b29", "#bec6ff", "#ff5555", "#ff5555"};
    m_themes["cobalt"] = {"#132738", "#f8c60c", "#f8c60c", "#274060", "#0e1f2d", "#d3dae8", "#ff3231", "#ff3231"};
    m_themes["cyberspace"] = {"#0d1017", "#ad6fa9", "#ad6fa9", "#4d5b69", "#0b0e14", "#b3aeab", "#ff6b6b", "#ff6b6b"};
    m_themes["evil_eye"] = {"#0b0e14", "#39bae6", "#39bae6", "#3e4451", "#0b0e14", "#bfbdb6", "#ff6b6b", "#ff6b6b"};
    m_themes["fire"] = {"#1a0a00", "#ff6600", "#ff6600", "#553300", "#140800", "#ffccaa", "#ff0000", "#ff0000"};
    m_themes["gothic"] = {"#0e100a", "#728e9c", "#728e9c", "#3a4a52", "#0b0d08", "#c0c0b0", "#ff6b6b", "#ff6b6b"};
    m_themes["home_row"] = {"#1c1c1c", "#fafafa", "#fafafa", "#5a5a5a", "#181818", "#e0e0e0", "#ff5555", "#ff5555"};
    m_themes["hulk"] = {"#0b1a0b", "#48a648", "#48a648", "#2a5a2a", "#081508", "#b8d8b8", "#ff6b6b", "#ff6b6b"};
    m_themes["ice_age"] = {"#0e1419", "#56b6c2", "#56b6c2", "#3e4e56", "#0b1115", "#b8c4cc", "#e06c75", "#e06c75"};
    m_themes["index"] = {"#101010", "#0099ff", "#0099ff", "#444444", "#0c0c0c", "#eeeeee", "#ff5555", "#ff5555"};
    m_themes["ink"] = {"#101010", "#ffffff", "#ffffff", "#444444", "#0c0c0c", "#ffffff", "#ff5555", "#ff5555"};
    m_themes["iridium"] = {"#1c1c1c", "#b4c5d8", "#b4c5d8", "#5a5a5a", "#181818", "#e0e0e0", "#ff5555", "#ff5555"};
    m_themes["joker"] = {"#12122c", "#a374db", "#a374db", "#4a4a6a", "#0e0e26", "#e0d8f0", "#ff6b6b", "#ff6b6b"};
    m_themes["keanu"] = {"#1c1c1c", "#48c8ff", "#48c8ff", "#5a5a5a", "#181818", "#e0e0e0", "#ff5555", "#ff5555"};
    m_themes["kitty"] = {"#1e1e2e", "#89b4fa", "#f5e0dc", "#6c7086", "#181825", "#cdd6f4", "#f38ba8", "#eba0ac"};
    m_themes["lavender"] = {"#1a1a2e", "#b4a7d6", "#b4a7d6", "#4a4a6a", "#15152a", "#e0d8f0", "#ff6b6b", "#ff6b6b"};
    m_themes["leaf"] = {"#1a1c10", "#90b75d", "#90b75d", "#5a6b48", "#151a0e", "#d0deb8", "#ff6b6b", "#ff6b6b"};
    m_themes["lil_fang"] = {"#1a0a1a", "#d88fd0", "#d88fd0", "#5c3a5c", "#150815", "#e8d8f8", "#ff6b6b", "#ff6b6b"};
    m_themes["m87"] = {"#1a1a1a", "#d7d7d7", "#d7d7d7", "#5a5a5a", "#151515", "#e8e8e8", "#ff5555", "#ff5555"};
    m_themes["magic_girl"] = {"#1a1424", "#ff79c6", "#ff79c6", "#5c4a6e", "#151020", "#f8d8f8", "#ff6b6b", "#ff6b6b"};
    m_themes["melon_soda"] = {"#0b1a15", "#70d8a0", "#70d8a0", "#3a5a48", "#081510", "#b8e8d8", "#ff6b6b", "#ff6b6b"};
    m_themes["midnight"] = {"#0b0e14", "#39bae6", "#39bae6", "#3e4451", "#0b0e14", "#bfbdb6", "#ff6b6b", "#ff6b6b"};
    m_themes["molokai"] = {"#121212", "#78a0c4", "#78a0c4", "#555555", "#0e0e0e", "#d0d0d0", "#ff5555", "#ff5555"};
    m_themes["moonlight"] = {"#1a1b26", "#7aa2f7", "#7aa2f7", "#565f89", "#16161e", "#c0caf5", "#f7768e", "#f7768e"};
    m_themes["outrun"] = {"#0d0221", "#ff2a6d", "#ff2a6d", "#5a3a6a", "#0b011c", "#f0d0ff", "#ff6b6b", "#ff6b6b"};
    m_themes["overwatch"] = {"#1c1c1c", "#f9a825", "#f9a825", "#5a5a5a", "#181818", "#e0e0e0", "#ff5555", "#ff5555"};
    m_themes["palate_night"] = {"#1e1e2e", "#c0a36e", "#c0a36e", "#6c6c6c", "#1a1a2a", "#d4d4d4", "#ff5555", "#ff5555"};
    m_themes["panda"] = {"#1e1e1e", "#a6e22e", "#a6e22e", "#5a5a5a", "#1a1a1a", "#e0e0e0", "#ff5555", "#ff5555"};
    m_themes["peachy_keen"] = {"#1a1412", "#e8a07c", "#e8a07c", "#5c4a42", "#15100e", "#f0d8c8", "#ff6b6b", "#ff6b6b"};
    m_themes["phosphorus"] = {"#0b1a15", "#70d8a0", "#70d8a0", "#3a5a48", "#081510", "#b8e8d8", "#ff6b6b", "#ff6b6b"};
    m_themes["plant"] = {"#1a1c10", "#90b75d", "#90b75d", "#5a6b48", "#151a0e", "#d0deb8", "#ff6b6b", "#ff6b6b"};
    m_themes["purple_rain"] = {"#1a0a2e", "#bb77ff", "#bb77ff", "#4a2a6e", "#150828", "#e0d0ff", "#ff6b6b", "#ff6b6b"};
    m_themes["rage"] = {"#1a0a0a", "#ff4444", "#ff4444", "#5a2a2a", "#150808", "#f0d0d0", "#ff0000", "#ff0000"};
    m_themes["red_samurai"] = {"#1c0c0c", "#ff6666", "#ff6666", "#5a3a3a", "#170a0a", "#f0d8d8", "#ff0000", "#ff0000"};
    m_themes["retrowave"] = {"#0d0221", "#ff2a6d", "#ff2a6d", "#5a3a6a", "#0b011c", "#f0d0ff", "#ff6b6b", "#ff6b6b"};
    m_themes["rss"] = {"#1a1a2e", "#ff9900", "#ff9900", "#4a4a6a", "#15152a", "#e0e0e0", "#ff6b6b", "#ff6b6b"};
    m_themes["ryujin"] = {"#1c1c1c", "#ff6b6b", "#ff6b6b", "#5a5a5a", "#181818", "#e0e0e0", "#ff0000", "#ff0000"};
    m_themes["sakura"] = {"#1c1015", "#f0a0b0", "#f0a0b0", "#5c3d4e", "#170c11", "#f0d0e0", "#ff6b6b", "#ff6b6b"};
    m_themes["spearmint"] = {"#1c1c1c", "#72d072", "#72d072", "#5a5a5a", "#181818", "#e0e0e0", "#ff5555", "#ff5555"};
    m_themes["starfighter"] = {"#1c1c2e", "#6c5ce7", "#6c5ce7", "#4a4a6a", "#17172a", "#e0d8f0", "#ff6b6b", "#ff6b6b"};
    m_themes["strawberry"] = {"#1c0c0c", "#ff6666", "#ff6666", "#5a3a3a", "#170a0a", "#f0d8d8", "#ff0000", "#ff0000"};
    m_themes["sunset"] = {"#1a1412", "#e8a07c", "#e8a07c", "#5c4a42", "#15100e", "#f0d8c8", "#ff6b6b", "#ff6b6b"};
    m_themes["valentine"] = {"#1c1015", "#f0a0b0", "#f0a0b0", "#5c3d4e", "#170c11", "#f0d0e0", "#ff6b6b", "#ff6b6b"};
    m_themes["vaporwave"] = {"#0d0221", "#ff2a6d", "#ff2a6d", "#5a3a6a", "#0b011c", "#f0d0ff", "#ff6b6b", "#ff6b6b"};
    m_themes["walrus"] = {"#1c1c1c", "#b4c5d8", "#b4c5d8", "#5a5a5a", "#181818", "#e0e0e0", "#ff5555", "#ff5555"};
    m_themes["watermelon"] = {"#1a1c10", "#90b75d", "#90b75d", "#5a6b48", "#151a0e", "#d0deb8", "#ff6b6b", "#ff6b6b"};
    m_themes["yuzu"] = {"#1c1c1c", "#f5c842", "#f5c842", "#5a5a5a", "#181818", "#e0e0e0", "#ff5555", "#ff5555"};
}