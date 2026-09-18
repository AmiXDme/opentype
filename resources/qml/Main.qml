import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import OpenType 1.0

Window {
    id: appWindow
    visible: true
    width: 1100
    height: 700
    minimumWidth: 800
    minimumHeight: 500
    title: "OpenType - Typing Tutor"
    color: theme.bg

    property string currentMode: "words"
    property var lastResults: ({})

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            color: theme.surface

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                spacing: 12

                Text {
                    text: "OpenType"
                    color: theme.text
                    font.pixelSize: 16
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                ProfileSwitcher {
                    Layout.preferredWidth: 200
                    Layout.fillHeight: true
                }

                NavButton {
                    text: "\u2699"
                    implicitWidth: 36
                    implicitHeight: 36
                    onClicked: showSettings()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: theme.border
        }

        Loader {
            id: screenLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: homeScreen
        }
    }

    Component {
        id: homeScreen
        HomeScreen {
            onStartPractice: function(mode) { showPractice(mode) }
            onGoStats: showStats()
        }
    }

    Component {
        id: practiceScreen
        PracticeScreen {
            mode: appWindow.currentMode
            onGoHome: showHome()
            onSessionComplete: function(stats) { showResults(stats) }
        }
    }

    Component {
        id: statsScreen
        StatsScreen {
            onGoHome: showHome()
        }
    }

    Component {
        id: resultsView
        ResultsView {
            resultData: appWindow.lastResults
            onGoHome: showHome()
            onRestart: showPractice(appWindow.currentMode)
        }
    }

    Component {
        id: themePickerScreen
        ThemePicker {
            onClosed: showHome()
        }
    }

    Component {
        id: settingsScreen
        SettingsScreen {
            onGoHome: showHome()
        }
    }

    function showHome() {
        screenLoader.sourceComponent = homeScreen
    }

    function showPractice(mode) {
        appWindow.currentMode = mode
        screenLoader.sourceComponent = practiceScreen
    }

    function showStats() {
        screenLoader.sourceComponent = statsScreen
    }

    function showResults(stats) {
        appWindow.lastResults = stats
        screenLoader.sourceComponent = resultsView
    }

    function showThemePicker() {
        var picker = themePickerScreen.createObject(appWindow)
        if (picker) picker.open()
    }

    function showSettings() {
        screenLoader.sourceComponent = settingsScreen
    }

    signal goHome()

    onGoHome: showHome()
}