import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import OpenType 1.0

Item {
    id: root

    property string mode: "words"
    property string language: "english"
    property string layout: "qwerty"
    property int timedSeconds: 30
    property bool keyboardVisible: true

    property alias targetText: typingSurface.targetText
    property alias typedText: typingSurface.typedText
    property alias wpm: typingSurface.wpm
    property alias accuracy: typingSurface.accuracy
    property alias progress: typingSurface.progress

    signal sessionComplete(var stats)
    signal goHome()
    signal openSettings()

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
        spacing: 12

        // ---- mode toolbar ----
        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 54
            Layout.maximumHeight: 54
            pad: 10

            RowLayout {
                anchors.fill: parent
                spacing: 6

                Repeater {
                    model: ["time", "words", "quote", "custom", "adaptive"]
                    Rectangle {
                        required property var modelData
                        required property int index
                        Layout.preferredWidth: 72
                        Layout.preferredHeight: 30
                        radius: theme.rsm
                        color: root.mode === modelData || (root.mode === "timed" && modelData === "time")
                            ? theme.accent : "transparent"
                        border.color: theme.border
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: (root.mode === modelData || (root.mode === "timed" && modelData === "time")) ? theme.bg : theme.textDim
                            font.pixelSize: 12
                            font.weight: Font.Medium
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.mode = (modelData === "time") ? "timed" : modelData
                                root.startSession()
                            }
                        }
                    }
                }

                RowLayout {
                    visible: root.mode === "timed"
                    spacing: 6

                    Repeater {
                        model: [15, 30, 60, 120]
                        Rectangle {
                            required property var modelData
                            Layout.preferredWidth: 48
                            Layout.preferredHeight: 30
                            radius: theme.rsm
                            color: root.timedSeconds === modelData ? theme.accent : "transparent"
                            border.color: theme.border
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: modelData + "s"
                                color: root.timedSeconds === modelData ? theme.bg : theme.textDim
                                font.pixelSize: 12
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.timedSeconds = modelData
                                    root.startSession()
                                }
                            }
                        }
                    }
                }

                Repeater {
                    model: ["punctuation", "numbers"]
                    Rectangle {
                        required property var modelData
                        Layout.preferredWidth: 96
                        Layout.preferredHeight: 30
                        radius: theme.rsm
                        color: (modelData === "punctuation" ? typingSurface.punctuation : typingSurface.numbers) ? theme.accent : "transparent"
                        border.color: theme.border
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: (modelData === "punctuation" ? typingSurface.punctuation : typingSurface.numbers) ? theme.bg : theme.textDim
                            font.pixelSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData === "punctuation") typingSurface.punctuation = !typingSurface.punctuation
                                else typingSurface.numbers = !typingSurface.numbers
                                root.startSession()
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                ComboBox {
                    id: langCombo
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 30
                    model: ContentCatalog.languages()
                    displayText: root.language
                    onActivated: {
                        root.language = ContentCatalog.languages()[index]
                        root.startSession()
                    }
                }

                ComboBox {
                    id: layoutCombo
                    Layout.preferredWidth: 110
                    Layout.preferredHeight: 30
                    model: ContentCatalog.layouts()
                    displayText: root.layout
                    onActivated: {
                        root.layout = ContentCatalog.layouts()[index]
                        root.startSession()
                    }
                }
            }
        }

        // ---- stat cards ----
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 96
            Layout.maximumHeight: 96
            spacing: 12

            Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: 96
                pad: 12

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 2

                    Text {
                        text: "WPM"
                        color: theme.textDim
                        font.pixelSize: 10
                    }

                    Text {
                        text: Math.round(wpm).toString()
                        color: theme.accent
                        font.pixelSize: 22
                        font.bold: true
                    }

                    Sparkline {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        values: typingSurface.wpmSamples.map(function(s) { return s.wpm })
                        line: theme.accent
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: 96
                pad: 12

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 2

                    Text {
                        text: "ACCURACY"
                        color: theme.textDim
                        font.pixelSize: 10
                    }

                    Text {
                        text: Math.round(accuracy).toString() + "%"
                        color: theme.text
                        font.pixelSize: 22
                        font.bold: true
                    }

                    Meter {
                        Layout.fillWidth: true
                        value: accuracy
                        cap: 100
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: 96
                pad: 12

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 2

                    Text {
                        text: "ERRORS"
                        color: theme.textDim
                        font.pixelSize: 10
                    }

                    Text {
                        text: typingSurface.errorCount.toString()
                        color: theme.text
                        font.pixelSize: 22
                        font.bold: true
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: 96
                pad: 12

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 2

                    Text {
                        text: root.mode === "timed" ? "TIME" : "PROGRESS"
                        color: theme.textDim
                        font.pixelSize: 10
                    }

                    Text {
                        text: root.mode === "timed"
                            ? Math.floor(typingSurface.elapsedMs / 1000).toString() + "s"
                            : Math.round(progress).toString() + "%"
                        color: theme.text
                        font.pixelSize: 22
                        font.bold: true
                    }

                    Meter {
                        Layout.fillWidth: true
                        value: root.mode === "timed" ? (typingSurface.elapsedMs / 1000) : progress
                        cap: root.mode === "timed" ? root.timedSeconds : 100
                    }
                }
            }
        }

        // ---- focus keys (adaptive) ----
        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 52
            visible: root.mode === "adaptive"
            pad: 10

            RowLayout {
                anchors.fill: parent
                spacing: 8

                ColumnLayout {
                    spacing: 0

                    Text {
                        text: "FOCUS KEYS"
                        color: theme.textDim
                        font.pixelSize: 10
                    }

                    Text {
                        text: "weighted toward your weak keys"
                        color: theme.textDim
                        font.pixelSize: 10
                    }
                }

                Item { Layout.fillWidth: true }

                Repeater {
                    model: typingSurface.weakKeys
                    KeyRing {
                        required property var modelData
                        keyChar: String(modelData)
                        mastery: 0.3
                    }
                }
            }
        }

        // ---- typing card ----
        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 220
            pad: 0

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                RowLayout {
                    visible: root.mode === "custom"
                    Layout.fillWidth: true
                    spacing: 8

                    TextField {
                        id: customInput
                        Layout.fillWidth: true
                        placeholderText: "Paste custom text here..."
                        color: theme.text
                        font.pixelSize: 14
                        background: Rectangle {
                            radius: theme.rsm
                            color: theme.surface2
                            border.color: theme.border
                            border.width: 1
                        }
                    }

                    AppButton {
                        text: "Start"
                        primary: true
                        onClicked: {
                            if (customInput.text.length > 0) typingSurface.startCustom(customInput.text)
                        }
                    }
                }

                TypingSurface {
                    id: typingSurface
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    mode: root.mode
                    language: root.language
                    layout: root.layout
                    timedSeconds: root.timedSeconds
                    keyboardVisible: root.keyboardVisible
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
                        keyStats: typingSurface.keyStats,
                        time: typingSurface.elapsedMs / 1000,
                        elapsedMs: typingSurface.elapsedMs,
                        mode: root.mode,
                        language: root.language,
                        layout: root.layout
                    })
                }
            }
        }

        // ---- bottom action bar ----
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 40
            spacing: 8

            NavButton {
                text: "⚙ Settings"
                implicitWidth: 110
                implicitHeight: 34
                onClicked: root.openSettings()
            }

            NavButton {
                text: root.keyboardVisible ? "⌨ Hide keyboard" : "⌨ Show keyboard"
                implicitWidth: 150
                implicitHeight: 34
                onClicked: root.keyboardVisible = !root.keyboardVisible
            }

            NavButton {
                text: "↻ Restart"
                implicitWidth: 100
                implicitHeight: 34
                onClicked: root.startSession()
            }

            AppButton {
                text: "↝ New text"
                implicitWidth: 110
                implicitHeight: 34
                onClicked: root.startSession()
            }

            NavButton {
                text: "← Home"
                implicitWidth: 100
                implicitHeight: 34
                onClicked: root.goHome()
            }
        }
    }

    function startSession() {
        typingSurface.startSession()
    }

    function endSession(stats) {
        statsStore.recordSession(stats)
        root.sessionComplete(stats)
    }
}
