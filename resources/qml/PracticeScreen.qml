import QtQuick
import QtQuick.Layouts

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

    signal goResults(var data)
    signal goHome()

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
                Layout.fillWidth: true
                Layout.fillHeight: true
                onSessionComplete: root.endSession({
                    wpm: typingSurface.wpm,
                    accuracy: typingSurface.accuracy,
                    progress: typingSurface.progress,
                    correct: typingSurface.correctCount,
                    errors: typingSurface.errorCount,
                    time: typingSurface.elapsedMs / 1000
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
        root.goResults(stats)
    }
}
