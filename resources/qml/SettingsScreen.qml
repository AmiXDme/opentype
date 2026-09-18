import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import OpenType 1.0

Item {
    id: root

    signal goHome()

    property var clickPacks: ["off", "mechanical", "soft", "clicky", "linear", "tactile", "vintage", "modern", "gaming", "office", "silent", "loud"]
    property var errorPacks: ["off", "buzz", "beep", "chime", "alert", "pop", "click", "ding", "bloop", "snap", "thud", "ping"]

    function currentSettings() {
        return App.profileManager.settings
    }

    function saveSettings(s) {
        App.profileManager.setSettings(s)
    }

    ThemePicker {
        id: themePicker
    }

    AboutDialog {
        id: aboutDialog
    }

    AccountDialog {
        id: accountDialog
    }

    SoundMixer {
        id: previewMixer
        volume: App.profileManager.settings.volume !== undefined ? App.profileManager.settings.volume : 0.5
    }

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentCol.implicitHeight + 32
        clip: true
        flickableDirection: Flickable.VerticalFlick

        ColumnLayout {
            id: contentCol
            width: parent.width - 32
            x: 16
            y: 16
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
                Layout.preferredHeight: 150
                pad: 20

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

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

                        Text {
                            text: App.profileManager.settings.theme || "yaru_dark"
                            color: theme.textDim
                            font.pixelSize: 12
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        AppButton {
                            text: "Change Theme"
                            onClicked: themePicker.open()
                        }
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                pad: 20

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

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
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        AppButton {
                            text: "Account"
                            onClicked: accountDialog.open()
                        }
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                pad: 20

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

                    Text {
                        text: "Sound"
                        color: theme.text
                        font.pixelSize: 16
                        font.weight: Font.Bold
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text {
                            text: "Volume"
                            color: theme.textMid
                            font.pixelSize: 14
                            Layout.preferredWidth: 120
                        }

                        Slider {
                            Layout.fillWidth: true
                            from: 0
                            to: 1
                            stepSize: 0.05
                            value: App.profileManager.settings.volume !== undefined ? App.profileManager.settings.volume : 0.5
                            onMoved: {
                                var s = currentSettings()
                                s.volume = value
                                saveSettings(s)
                            }
                        }

                        Text {
                            text: Number(App.profileManager.settings.volume !== undefined ? App.profileManager.settings.volume : 0.5).toFixed(2)
                            color: theme.textDim
                            font.pixelSize: 12
                            Layout.preferredWidth: 36
                        }
                    }

                    Text {
                        text: "SOUND ON CLICK"
                        color: theme.textDim
                        font.pixelSize: 11
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 6
                        rowSpacing: 6
                        columnSpacing: 6

                        Repeater {
                            model: root.clickPacks
                            Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 30
                                radius: theme.rsm
                                color: (App.profileManager.settings.clickPack || "off") === modelData ? theme.accent : theme.surface2
                                border.color: theme.border
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: (App.profileManager.settings.clickPack || "off") === modelData ? theme.bg : theme.textDim
                                    font.pixelSize: 11
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        var s = currentSettings()
                                        s.clickPack = modelData
                                        saveSettings(s)
                                        previewMixer.playClick(modelData)
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        text: "SOUND ON ERROR"
                        color: theme.textDim
                        font.pixelSize: 11
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 6
                        rowSpacing: 6
                        columnSpacing: 6

                        Repeater {
                            model: root.errorPacks
                            Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 30
                                radius: theme.rsm
                                color: (App.profileManager.settings.errorPack || "off") === modelData ? theme.accent : theme.surface2
                                border.color: theme.border
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: (App.profileManager.settings.errorPack || "off") === modelData ? theme.bg : theme.textDim
                                    font.pixelSize: 11
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        var s = currentSettings()
                                        s.errorPack = modelData
                                        saveSettings(s)
                                        previewMixer.playError(modelData)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 210
                pad: 20

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

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
                            current: App.profileManager.settings.layout || "qwerty"
                            options: ContentCatalog.layouts()
                            label: "Layout"
                            onActivated: {
                                var s = currentSettings()
                                s.layout = current
                                saveSettings(s)
                            }
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
                            current: App.profileManager.settings.language || "english"
                            options: ContentCatalog.languages()
                            label: "Language"
                            onActivated: {
                                var s = currentSettings()
                                s.language = current
                                saveSettings(s)
                            }
                        }

                        Item { Layout.fillWidth: true }
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 16

                AppButton {
                    text: "About"
                    onClicked: aboutDialog.open()
                }
            }
        }
    }
}
