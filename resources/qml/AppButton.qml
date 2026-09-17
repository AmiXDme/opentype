import QtQuick
import QtQuick.Controls.Basic

Button {
    id: root

    property bool primary: false

    implicitWidth: 120
    implicitHeight: 40

    background: Rectangle {
        radius: Theme.r
        color: root.primary ? Theme.accent : (root.hovered ? Theme.surface2 : Theme.surface)
        border.color: Theme.border
        border.width: 1
    }

    contentItem: Text {
        text: root.text
        color: root.primary ? Theme.bg : Theme.text
        font.pixelSize: 14
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
