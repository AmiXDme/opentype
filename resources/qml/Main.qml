import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

ApplicationWindow {
    id: window

    visible: true
    width: 900
    height: 700
    title: "OpenType"
    color: Theme.bg

    property string currentScreen: "home"
    property string currentMode: "words"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: Theme.surface

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8

                ProfileSwitcher {
                    Layout.fillWidth: true
                }

                Text {
                    text: "OpenType"
                    color: Theme.text
                    font.pixelSize: 18
                    font.bold: true
                }

                Row {
                    spacing: 8

                    NavButton {
                        text: "Theme"
                        onClicked: themePicker.open()
                    }

                    NavButton {
                        text: "About"
                        onClicked: aboutDialog.open()
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: {
                switch (window.currentScreen) {
                    case "home": return 0
                    case "practice": return 1
                    case "stats": return 2
                    default: return 0
                }
            }

            HomeScreen {
                onStartPractice: function(mode) {
                    window.currentMode = mode
                    window.currentScreen = "practice"
                    practiceScreen.startSession()
                }
            }

            PracticeScreen {
                id: practiceScreen
                mode: window.currentMode
                onGoHome: window.currentScreen = "home"
                onSessionComplete: function(stats) {
                    window.currentScreen = "home"
                }
            }

            StatsScreen {
                onGoHome: window.currentScreen = "home"
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
        }

        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: Theme.surface

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                Item { Layout.fillWidth: true }

                NavButton {
                    text: "Home"
                    active: window.currentScreen === "home"
                    onClicked: window.currentScreen = "home"
                }

                NavButton {
                    text: "Practice"
                    active: window.currentScreen === "practice"
                    onClicked: window.currentScreen = "practice"
                }

                NavButton {
                    text: "Stats"
                    active: window.currentScreen === "stats"
                    onClicked: window.currentScreen = "stats"
                }

                Item { Layout.fillWidth: true }
            }
        }
    }

    ThemePicker {
        id: themePicker
        anchors.centerIn: parent
    }

    AboutDialog {
        id: aboutDialog
        anchors.centerIn: parent
    }

    AccountDialog {
        id: accountDialog
        anchors.centerIn: parent
    }
}
