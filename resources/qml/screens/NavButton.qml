import QtQuick
import QtQuick.Controls.Basic

Button {
    id: root

    property bool primary: false
    property bool active: false

    implicitWidth: 100
    implicitHeight: 40

    background: Rectangle {
        radius: theme.r
        color: root.active ? theme.accent : (root.hovered ? theme.surface2 : "transparent")
        border.color: theme.border
        border.width: 1
    }

    contentItem: Text {
        text: root.text
        color: root.active ? theme.bg : theme.text
        font.pixelSize: 14
        font.weight: root.active ? Font.DemiBold : Font.Medium
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
