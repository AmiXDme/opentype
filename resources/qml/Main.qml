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

    Theme { id: theme }

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
                    onClicked: screenLoader.source = "qrc:/resources/qml/screens/ThemePicker.qml"
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
            source: "qrc:/resources/qml/screens/HomeScreen.qml"
        }
    }

    signal goHome()

    onGoHome: screenLoader.source = "qrc:/resources/qml/screens/HomeScreen.qml"
}