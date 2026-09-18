import QtQuick
import QtQuick.Layouts
import OpenType 1.0

Rectangle {
    id: root

    property string mode: "words"
    property string language: "english"
    property string layout: "qwerty"
    property int wordCount: 12
    property int timedSeconds: 60

    property alias wpm: engine.wpm
    property alias rawWpm: engine.rawWpm
    property alias accuracy: engine.accuracy
    property alias targetText: engine.targetText
    property alias typedText: engine.typedText
    property alias running: engine.running
    property alias elapsedMs: engine.elapsedMs
    property alias totalKeystrokes: engine.totalKeystrokes
    property int correctCount: engine.correctCount
    property int errorCount: engine.errorCount
    property real progress: 0

    property var keyStats: ([])
    property var wpmSamples: ([])
    property var weakKeys: []
    property bool keyboardVisible: true
    property alias punctuation: textSource.punctuation
    property alias numbers: textSource.numbers

    signal sessionComplete()
    signal keyTyped(bool correct, string key)

    color: "transparent"
    radius: theme.r

    focus: true

    TypingEngine {
        id: engine

        onSessionComplete: {
            root.progress = 100
            root.keyStats = engine.getKeyStats()
            root.wpmSamples = engine.getSamples()
            root.sessionComplete()
        }

        onKeyTyped: function(correct, key) {
            root.keyTyped(correct, key)
        }

        onWpmChanged: {
            if (engine.running) {
                var samples = root.wpmSamples
                samples.push({ wpm: engine.wpm, err: correctCount < errorCount ? 1 : 0 })
                root.wpmSamples = samples
            }
        }

        onTargetTextChanged: {
            root.progress = engine.targetText.length > 0
                ? (engine.targetPosition / engine.targetText.length) * 100
                : 0
        }

        onTargetPositionChanged: {
            root.progress = engine.targetText.length > 0
                ? (engine.targetPosition / engine.targetText.length) * 100
                : 0
        }
    }

    TextSource {
        id: textSource
    }

    Timer {
        id: blinkTimer
        interval: 530
        running: true
        repeat: true
        property bool visible: true
        onTriggered: visible = !visible
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Escape) {
            root.startSession(true)
            event.accepted = true
            return
        }
        if (event.key === Qt.Key_Tab) {
            root.startSession(true)
            event.accepted = true
            return
        }
        if (event.key === Qt.Key_Backspace) {
            event.accepted = true
            return
        }

        if (!engine.running && event.text.length > 0) {
            engine.startSession(root.mode, root.language, root.layout)
        }

        if (event.text.length > 0) {
            engine.processKey(event.text.charAt(0))
        }

        event.accepted = true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            radius: theme.r

            Flickable {
                id: textFlickable
                anchors.fill: parent
                contentWidth: textDisplay.width
                contentHeight: textDisplay.height
                clip: true
                flickableDirection: Flickable.VerticalFlick

                Text {
                    id: textDisplay
                    width: textFlickable.width
                    text: root.buildDisplayText()
                    color: theme.text
                    font.family: theme.mono
                    font.pixelSize: 22
                    wrapMode: Text.WordWrap
                    textFormat: Text.RichText
                    lineHeight: 1.6
                }
            }

            Text {
                anchors.centerIn: parent
                visible: !engine.targetText || engine.targetText.length === 0
                text: "Click here and start typing"
                color: theme.textDim
                font.family: theme.mono
                font.pixelSize: 22
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: theme.border
        }

        Heatmap {
            visible: root.keyboardVisible
            Layout.fillWidth: true
            Layout.preferredHeight: root.keyboardVisible ? 150 : 0
            compact: true
            stats: root.keyStats
            nextKey: engine.targetText.length > engine.targetPosition
                ? engine.targetText.charAt(engine.targetPosition) : ""
        }

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: engine.running ? "Keep going..." : (engine.targetText.length > 0 ? "Click here and start typing" : "")
                color: theme.textDim
                font.pixelSize: 12
                font.family: theme.mono
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "esc restart · tab new text"
                color: theme.textDim
                font.pixelSize: 12
                font.family: theme.mono
            }
        }
    }

    function buildDisplayText() {
        var target = engine.targetText
        var typed = engine.typedText
        if (!target || target.length === 0) return ""

        var result = ""
        for (var i = 0; i < target.length; i++) {
            var ch = target.charAt(i)

            if (i < typed.length) {
                var typedChar = typed.charAt(i)
                if (typedChar === ch) {
                    result += "<span style='color:" + theme.good + "'>" + _escapeHtml(ch) + "</span>"
                } else {
                    result += "<span style='color:" + theme.error + ";background:" + Qt.rgba(theme.error.r, theme.error.g, theme.error.b, 0.2) + ";border-radius:2px'>" + _escapeHtml(ch) + "</span>"
                }
            } else if (i === typed.length) {
                var cursorChar = blinkTimer.visible ? "\u2588" : " "
                result += "<span style='color:" + theme.caret + ";font-weight:bold'>" + cursorChar + "</span>"
                result += "<span style='color:" + theme.textDim + "'>" + _escapeHtml(ch) + "</span>"
            } else {
                result += "<span style='color:" + theme.textDim + "'>" + _escapeHtml(ch) + "</span>"
            }
        }

        if (typed.length >= target.length) {
            var cursorChar2 = blinkTimer.visible ? "\u2588" : " "
            result += "<span style='color:" + theme.caret + ";font-weight:bold'>" + cursorChar2 + "</span>"
        }

        return result
    }

    function _escapeHtml(ch) {
        if (ch === "&") return "&amp;"
        if (ch === "<") return "&lt;"
        if (ch === ">") return "&gt;"
        if (ch === "\"") return "&quot;"
        if (ch === "'") return "&#39;"
        return ch
    }

    function startSession() {
        root.wpmSamples = []
        root.keyStats = []
        root.progress = 0
        root.weakKeys = []

        var text = ""
        if (root.mode === "words") {
            text = textSource.generateWords(root.wordCount)
        } else if (root.mode === "timed") {
            text = textSource.generateTimed(root.timedSeconds)
        } else if (root.mode === "quote") {
            text = textSource.generateQuote()
        } else if (root.mode === "adaptive") {
            var weakKeys = textSource.getAdaptiveKeys(5)
            root.weakKeys = weakKeys
            text = textSource.generateAdaptiveText(weakKeys, root.wordCount)
        } else if (root.mode === "custom") {
            text = textSource.generateWords(root.wordCount)
        }

        engine.startSession(root.mode, root.language, root.layout)
        engine.setTargetText(text)
        root.forceActiveFocus()
    }

    function startCustom(text) {
        root.wpmSamples = []
        root.keyStats = []
        root.progress = 0
        root.weakKeys = []
        engine.startSession("custom", root.language, root.layout)
        engine.setTargetText(textSource.generateCustom(text))
        root.forceActiveFocus()
    }

    function stopSession() {
        engine.endSession()
    }

    function getSessionData() {
        return {
            wpm: engine.wpm,
            rawWpm: engine.rawWpm,
            accuracy: engine.accuracy,
            time: engine.elapsedMs / 1000,
            correct: engine.correctCount,
            errors: engine.errorCount,
            samples: root.wpmSamples,
            keyStats: root.keyStats,
            mode: root.mode
        }
    }
}
