import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property real value: 0
    property real cap: 0
    property color line: Theme.accent
    property color fill: Theme.good
    property bool on: false
    property color onColor: Theme.text

    implicitHeight: 8

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Theme.surface

        Rectangle {
            width: parent.width * Math.min(1, root.value / (root.cap > 0 ? root.cap : 1))
            height: parent.height
            radius: height / 2
            color: root.on ? root.onColor : root.fill

            Behavior on width {
                NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
            }
        }
    }
}
