import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    default property alias cardContent: inner.data
    property real pad: 0
    property bool elevated: true

    color: theme.surface
    radius: theme.rlg

    Item {
        id: inner
        anchors.fill: parent
        anchors.margins: root.pad
    }
}
