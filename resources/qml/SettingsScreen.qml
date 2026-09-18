import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import OpenType 1.0

Item {
    id: root

    signal goHome()

    property bool soundEnabled: true
    property string selectedLayout: "qwerty"
    property string selectedLanguage: "english"
    property bool focusMode: false

    property var layouts: ["qwerty", "dvorak", "colemak", "azerty", "qwertz"]
    property var languages: ["english", "spanish", "french", "german", "italian", "portuguese"]

    ThemePicker {
        id: themePicker
    }

    AboutDialog {
        id: aboutDialog
    }

    AccountDialog {
        id: accountDialog
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        RowLayout {
            Layout.fillWidth: true

            NavButton {
                text: "\u2190 Home"
                onClicked: root.goHome()
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Settings"
                color: theme.text
                font.pixelSize: 18
                font.weight: Font.Bold
            }

            Item { Layout.fillWidth: true }
        }

        Card {
            Layout.fillWidth: true
            pad: 20

            ColumnLayout {
                anchors.fill: parent
                spacing: 16

                Text {
                    text: "Appearance"
                    color: theme.text
                    font.pixelSize: 16
                    font.weight: Font.Bold
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Text {
                        text: "Theme"
                        color: theme.textMid
                        font.pixelSize: 14
                        Layout.preferredWidth: 120
                    }

                    Item { Layout.fillWidth: true }

                    AppButton {
                        text: "Change Theme"
                        onClicked: themePicker.open()
                    }
                }
            }
        }

        Card {
            Layout.fillWidth: true
            pad: 20

            ColumnLayout {
                anchors.fill: parent
                spacing: 16

                Text {
                    text: "Profile"
                    color: theme.text
                    font.pixelSize: 16
                    font.weight: Font.Bold
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Text {
                        text: "Current Profile"
                        color: theme.textMid
                        font.pixelSize: 14
                        Layout.preferredWidth: 120
                    }

                    Text {
                        text: App.profileManager.activeName
                        color: theme.text
                        font.pixelSize: 14
                        font.weight: Font.Medium
                    }

                    Item { Layout.fillWidth: true }

                    AppButton {
                        text: "Account"
                        onClicked: accountDialog.open()
                    }
                }
            }
        }

        Card {
            Layout.fillWidth: true
            pad: 20

            ColumnLayout {
                anchors.fill: parent
                spacing: 16

                Text {
                    text: "Sound"
                    color: theme.text
                    font.pixelSize: 16
                    font.weight: Font.Bold
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Text {
                        text: "Key Sounds"
                        color: theme.textMid
                        font.pixelSize: 14
                        Layout.preferredWidth: 120
                    }

                    Switch {
                        checked: root.soundEnabled
                        onCheckedChanged: root.soundEnabled = checked

                        background: Rectangle {
                            radius: height / 2
                            color: checked ? theme.accent : theme.surface2
                            border.color: theme.border
                            border.width: 1
                        }

                        contentItem: Text {
                            text: checked ? "ON" : "OFF"
                            color: checked ? theme.bg : theme.textDim
                            font.pixelSize: 11
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }

        Card {
            Layout.fillWidth: true
            pad: 20

            ColumnLayout {
                anchors.fill: parent
                spacing: 16

                Text {
                    text: "Input"
                    color: theme.text
                    font.pixelSize: 16
                    font.weight: Font.Bold
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Text {
                        text: "Keyboard Layout"
                        color: theme.textMid
                        font.pixelSize: 14
                        Layout.preferredWidth: 120
                    }

                    Selector {
                        id: layoutSelector
                        Layout.preferredWidth: 200
                        current: root.selectedLayout
                        options: root.layouts
                        label: "Layout"
                        onActivated: root.selectedLayout = current
                    }

                    Item { Layout.fillWidth: true }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Text {
                        text: "Language"
                        color: theme.textMid
                        font.pixelSize: 14
                        Layout.preferredWidth: 120
                    }

                    Selector {
                        id: langSelector
                        Layout.preferredWidth: 200
                        current: root.selectedLanguage
                        options: root.languages
                        label: "Language"
                        onActivated: root.selectedLanguage = current
                    }

                    Item { Layout.fillWidth: true }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Text {
                        text: "Focus Mode"
                        color: theme.textMid
                        font.pixelSize: 14
                        Layout.preferredWidth: 120
                    }

                    Switch {
                        checked: root.focusMode
                        onCheckedChanged: root.focusMode = checked

                        background: Rectangle {
                            radius: height / 2
                            color: checked ? theme.accent : theme.surface2
                            border.color: theme.border
                            border.width: 1
                        }

                        contentItem: Text {
                            text: checked ? "ON" : "OFF"
                            color: checked ? theme.bg : theme.textDim
                            font.pixelSize: 11
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Item { Layout.fillWidth: true }
                }
            }
        }

        Item { Layout.fillHeight: true }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 16

            AppButton {
                text: "About"
                onClicked: aboutDialog.open()
            }
        }
    }
}
