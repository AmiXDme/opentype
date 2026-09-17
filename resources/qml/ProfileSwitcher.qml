import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root

    property string current: ""

    signal activated(string value)

    RowLayout {
        anchors.centerIn: parent
        spacing: 8

        Rectangle {
            width: 32
            height: 32
            radius: 16
            color: ProfileManager.activeColor

            Text {
                anchors.centerIn: parent
                text: ProfileManager.activeName.charAt(0).toUpperCase()
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }
        }

        Text {
            text: ProfileManager.activeName
            color: Theme.text
            font.pixelSize: 14
            font.weight: Font.Medium
        }

        ComboBox {
            id: profileCombo
            implicitWidth: 150
            implicitHeight: 32
            model: ProfileManager.profiles

            background: Rectangle {
                radius: Theme.rsm
                color: hovered ? Theme.surface2 : Theme.surface
                border.color: Theme.border
                border.width: 1
            }

            contentItem: Text {
                text: profileCombo.displayText
                color: Theme.text
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }

            onActivated: {
                ProfileManager.setActive(modelData)
            }
        }
    }
}
