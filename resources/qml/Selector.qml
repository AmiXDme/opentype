import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ComboBox {
    id: root

    property string current: ""
    property var options: []
    property string label: ""

    implicitWidth: 200
    implicitHeight: 40

    model: root.options

    background: Rectangle {
        radius: Theme.r
        color: Theme.surface
        border.color: Theme.border
        border.width: 1
    }

    contentItem: Text {
        text: root.displayText
        color: Theme.text
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
        leftPadding: 12
    }

    popup: Popup {
        width: root.width
        height: Math.min(contentItem.implicitHeight + 20, 300)

        background: Rectangle {
            radius: Theme.r
            color: Theme.surface
            border.color: Theme.border
            border.width: 1
        }

        contentItem: ListView {
            clip: true
            model: root.model
            currentIndex: root.currentIndex

            delegate: ItemDelegate {
                width: root.width
                height: 36

                background: Rectangle {
                    color: hovered ? Theme.surface2 : "transparent"
                }

                contentItem: Text {
                    text: modelData
                    color: Theme.text
                    font.pixelSize: 14
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12
                }
            }
        }
    }

    onActivated: {
        root.current = root.options[index]
    }
}
