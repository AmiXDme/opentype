import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    default property alias content: inner.data
    property real pad: 0
    property bool elevated: true
    property real radius: Theme.rlg

    color: Theme.surface
    radius: root.radius

    ColumnLayout {
        id: inner
        anchors.fill: parent
        anchors.margins: root.pad
    }
}
