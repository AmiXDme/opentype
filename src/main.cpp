#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include <QQmlEngine>

#include "backend/TypingEngine.h"
#include "backend/TextSource.h"
#include "backend/StatsStore.h"
#include "backend/KeyboardLayout.h"
#include "backend/ContentCatalog.h"
#include "backend/SoundMixer.h"
#include "backend/TranslationManager.h"
#include "backend/AppGlobals.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("OpenType");
    app.setApplicationName("OpenType");
    app.setApplicationVersion("1.1.0");

    QQuickStyle::setStyle("Basic");

    qmlRegisterType<TypingEngine>("OpenType", 1, 0, "TypingEngine");
    qmlRegisterType<TextSource>("OpenType", 1, 0, "TextSource");
    qmlRegisterType<StatsStore>("OpenType", 1, 0, "StatsStore");
    qmlRegisterType<KeyboardLayout>("OpenType", 1, 0, "KeyboardLayout");
    qmlRegisterType<SoundMixer>("OpenType", 1, 0, "SoundMixer");
    qmlRegisterType<TranslationManager>("OpenType", 1, 0, "TranslationManager");

    QQmlApplicationEngine engine;

    // Add the qml directory to import path so Card.qml can be found
    engine.addImportPath("qrc:/resources/qml");

    AppGlobals *appGlobals = new AppGlobals(&engine);
    engine.rootContext()->setContextProperty("App", appGlobals);

    ContentCatalog *contentCatalog = new ContentCatalog(&engine);
    engine.rootContext()->setContextProperty("ContentCatalog", contentCatalog);

    engine.load(QUrl(QStringLiteral("qrc:/resources/qml/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}