import QtQuick
import QtQuick.Controls.Basic

Button {
    id: root

    property bool primary: false

    implicitWidth: 120
    implicitHeight: 40

    background: Rectangle {
        radius: theme.r
        color: root.primary ? theme.accent : (root.hovered ? theme.surface2 : theme.surface)
        border.color: theme.border
        border.width: 1
    }

    contentItem: Text {
        text: root.text
        color: root.primary ? theme.bg : theme.text
        font.pixelSize: 14
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
