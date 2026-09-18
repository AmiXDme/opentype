import QtQuick
import QtQuick.Layouts
import OpenType 1.0

Item {
    id: root

    property string mode: "words"
    property string language: "english"
    property string layout: "qwerty"

    property alias targetText: typingSurface.targetText
    property alias typedText: typingSurface.typedText
    property alias wpm: typingSurface.wpm
    property alias accuracy: typingSurface.accuracy
    property alias progress: typingSurface.progress

    signal sessionComplete(var stats)
    signal goHome()

    StatsStore {
        id: statsStore
        Component.onCompleted: {
            var pid = (App.profileManager.activeId || "default")
            statsStore.loadStats(pid)
        }
    }

    KeySounds {
        id: sounds
        clickPack: App.profileManager.settings.clickPack || "off"
        errorPack: App.profileManager.settings.errorPack || "off"
        volume: App.profileManager.settings.volume !== undefined ? App.profileManager.settings.volume : 0.5
    }

    Component.onCompleted: {
        // Delay slightly to ensure all bindings and components are initialized
        initTimer.start()
    }

    Timer {
        id: initTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: root.startSession()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        RowLayout {
            Layout.fillWidth: true

            NavButton {
                text: "Home"
                onClicked: root.goHome()
            }

            Item { Layout.fillWidth: true }

            Text {
                text: root.mode.charAt(0).toUpperCase() + root.mode.slice(1) + " Practice"
                color: theme.text
                font.pixelSize: 18
                font.weight: Font.Bold
            }

            Item { Layout.fillWidth: true }
        }

        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true
            pad: 24

            TypingSurface {
                id: typingSurface
                anchors.fill: parent
                mode: root.mode
                language: root.language
                layout: root.layout
                onKeyTyped: function(correct, key) {
                    if (correct) sounds.playClick()
                    else sounds.playError()
                }
                onSessionComplete: root.endSession({
                    wpm: typingSurface.wpm,
                    rawWpm: typingSurface.rawWpm,
                    accuracy: typingSurface.accuracy,
                    progress: typingSurface.progress,
                    correct: typingSurface.correctCount,
                    errors: typingSurface.errorCount,
                    totalKeystrokes: typingSurface.totalKeystrokes,
                    time: typingSurface.elapsedMs / 1000,
                    elapsedMs: typingSurface.elapsedMs,
                    mode: root.mode,
                    language: root.language,
                    layout: root.layout
                })
            }
        }

        RowLayout {
            Layout.fillWidth: true

            StatBadge {
                value: Math.round(wpm).toString()
                label: "WPM"
            }

            StatBadge {
                value: Math.round(accuracy).toString()
                label: "Accuracy"
                unit: "%"
            }

            Item { Layout.fillWidth: true }

            Meter {
                Layout.fillWidth: true
                value: progress
                cap: 100
            }
        }
    }

    function startSession() {
        typingSurface.startSession(root.mode, root.language, root.layout)
    }

    function endSession(stats) {
        statsStore.recordSession(stats)
        root.sessionComplete(stats)
    }
}