import QtQuick
import QtQuick.Controls.Basic

Button {
    id: root

    property bool primary: false
    property bool active: false

    implicitWidth: 100
    implicitHeight: 40

    background: Rectangle {
        radius: Theme.r
        color: root.active ? Theme.accent : (root.hovered ? Theme.surface2 : "transparent")
        border.color: Theme.border
        border.width: 1
    }

    contentItem: Text {
        text: root.text
        color: root.active ? Theme.bg : Theme.text
        font.pixelSize: 14
        font.weight: root.active ? Font.DemiBold : Font.Medium
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
