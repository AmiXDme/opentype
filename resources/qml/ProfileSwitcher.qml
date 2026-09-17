import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root

    RowLayout {
        anchors.centerIn: parent
        spacing: 8

        Rectangle {
            width: 32
            height: 32
            radius: 16
            color: App.profileManager.activeColor

            Text {
                anchors.centerIn: parent
                text: App.profileManager.activeName.charAt(0).toUpperCase()
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }
        }

        Text {
            text: App.profileManager.activeName
            color: theme.text
            font.pixelSize: 13
            font.weight: Font.Medium
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        ComboBox {
            id: profileCombo
            implicitWidth: 130
            implicitHeight: 30
            model: App.profileManager.profiles

            background: Rectangle {
                radius: theme.rsm
                color: profileCombo.hovered ? theme.surface2 : "transparent"
                border.color: theme.border
                border.width: 1
            }

            contentItem: Text {
                text: profileCombo.displayText
                color: theme.text
                font.pixelSize: 11
                verticalAlignment: Text.AlignVCenter
                leftPadding: 6
            }

            popup: Popup {
                width: profileCombo.width
                height: Math.min(contentItem.implicitHeight + 20, 200)

                background: Rectangle {
                    radius: theme.rsm
                    color: theme.surface
                    border.color: theme.border
                    border.width: 1
                }

                contentItem: ListView {
                    clip: true
                    model: profileCombo.model
                    currentIndex: profileCombo.currentIndex

                    delegate: ItemDelegate {
                        id: itemDelegate
                        width: profileCombo.width
                        height: 32

                        background: Rectangle {
                            color: itemDelegate.hovered ? theme.surface2 : "transparent"
                        }

                        contentItem: Text {
                            text: modelData
                            color: theme.text
                            font.pixelSize: 12
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 8
                        }
                    }
                }
            }

            onActivated: {
                App.profileManager.setActive(modelData)
            }
        }
    }
}