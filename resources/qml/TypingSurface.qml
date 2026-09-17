import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string targetText: ""
    property string typedText: ""
    property real wpm: 0
    property real accuracy: 100
    property real progress: 0
    property bool running: false

    property int targetPosition: 0
    property int correctCount: 0
    property int errorCount: 0
    property int totalKeystrokes: 0
    property real elapsedMs: 0

    property var keyStats: ({})

    color: "transparent"
    radius: theme.r

    focus: true

    Keys.onPressed: function(event) {
        if (!root.running) {
            root.running = true
        }

        if (event.text.length > 0 && root.targetPosition < root.targetText.length) {
            var targetChar = root.targetText.charAt(root.targetPosition)
            var correct = event.text === targetChar

            root.totalKeystrokes++

            if (correct) {
                root.correctCount++
            } else {
                root.errorCount++
            }

            var key = event.text
            if (root.keyStats[key]) {
                root.keyStats[key].attempts++
                if (correct) root.keyStats[key].correct++
                else root.keyStats[key].errors++
                root.keyStats[key].errorRate = root.keyStats[key].errors / root.keyStats[key].attempts
            } else {
                root.keyStats[key] = {
                    key: key,
                    attempts: 1,
                    correct: correct ? 1 : 0,
                    errors: correct ? 0 : 1,
                    errorRate: correct ? 0 : 1
                }
            }

            root.typedText += event.text
            root.targetPosition++

            if (root.totalKeystrokes > 0) {
                root.accuracy = (root.correctCount / root.totalKeystrokes) * 100
            }

            root.progress = (root.targetPosition / root.targetText.length) * 100

            var minutes = root.elapsedMs / 60000
            if (minutes > 0) {
                root.wpm = (root.correctCount / 5) / minutes
            }

            if (root.targetPosition >= root.targetText.length) {
                root.running = false
                root.sessionComplete()
            }
        }

        event.accepted = true
    }

    Timer {
        id: timer
        interval: 100
        running: root.running
        repeat: true
        onTriggered: {
            root.elapsedMs += 100
            var minutes = root.elapsedMs / 60000
            if (minutes > 0) {
                root.wpm = (root.correctCount / 5) / minutes
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        Text {
            Layout.fillWidth: true
            text: root.targetText || "Click here and start typing"
            color: theme.textDim
            font.family: theme.mono
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            maximumLineCount: 3
        }

        Text {
            Layout.fillWidth: true
            text: {
                if (!root.typedText) return ""
                var result = ""
                for (var i = 0; i < root.typedText.length; i++) {
                    var targetChar = root.targetText.charAt(i)
                    var typedChar = root.typedText.charAt(i)
                    if (typedChar === targetChar) {
                        result += "<span style='color:" + theme.good + "'>" + typedChar + "</span>"
                    } else {
                        result += "<span style='color:" + theme.error + ";text-decoration:underline'>" + typedChar + "</span>"
                    }
                }
                return result
            }
            color: theme.text
            font.family: theme.mono
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            maximumLineCount: 3
            textFormat: Text.RichText
        }

        Item { Layout.fillHeight: true }

        Heatmap {
            Layout.fillWidth: true
            Layout.preferredHeight: 160
            stats: {
                var list = []
                for (var key in root.keyStats) {
                    list.push(root.keyStats[key])
                }
                return list
            }
        }
    }

    signal sessionComplete()

    function startSession(mode, language, layout) {
        root.targetText = "the quick brown fox jumps over the lazy dog"
        root.typedText = ""
        root.targetPosition = 0
        root.correctCount = 0
        root.errorCount = 0
        root.totalKeystrokes = 0
        root.elapsedMs = 0
        root.wpm = 0
        root.accuracy = 100
        root.progress = 0
        root.running = false
        root.keyStats = {}
        root.forceActiveFocus()
    }
}
