#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>

#include "backend/TypingEngine.h"
#include "backend/TextSource.h"
#include "backend/StatsStore.h"
#include "backend/ProfileManager.h"
#include "backend/ThemeCatalog.h"
#include "backend/KeyboardLayout.h"
#include "backend/ContentCatalog.h"
#include "backend/SoundMixer.h"
#include "backend/LicenseController.h"
#include "backend/TranslationManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("OpenType");
    app.setApplicationName("OpenType");
    app.setApplicationVersion("1.0.0");

    QQuickStyle::setStyle("Basic");

    qmlRegisterType<TypingEngine>("OpenType", 1, 0, "TypingEngine");
    qmlRegisterType<TextSource>("OpenType", 1, 0, "TextSource");
    qmlRegisterType<StatsStore>("OpenType", 1, 0, "StatsStore");
    qmlRegisterType<KeyboardLayout>("OpenType", 1, 0, "KeyboardLayout");
    qmlRegisterType<ContentCatalog>("OpenType", 1, 0, "ContentCatalog");
    qmlRegisterType<SoundMixer>("OpenType", 1, 0, "SoundMixer");
    qmlRegisterType<TranslationManager>("OpenType", 1, 0, "TranslationManager");

    qmlRegisterSingletonType<ProfileManager>("OpenType", 1, 0, "ProfileManager",
        [](QQmlEngine *engine, QJSEngine *) -> QObject * {
            return new ProfileManager(engine);
        });

    qmlRegisterSingletonType<ThemeCatalog>("OpenType", 1, 0, "ThemeCatalog",
        [](QQmlEngine *engine, QJSEngine *) -> QObject * {
            return new ThemeCatalog(engine);
        });

    qmlRegisterSingletonType<LicenseController>("OpenType", 1, 0, "LicenseController",
        [](QQmlEngine *engine, QJSEngine *) -> QObject * {
            return new LicenseController(engine);
        });

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/resources/qml/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
