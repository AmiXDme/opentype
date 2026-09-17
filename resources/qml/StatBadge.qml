import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string value: ""
    property string label: ""
    property string unit: ""
    property color valueColor: theme.text
    property color fillColor: theme.accent

    width: 120
    height: 80
    radius: theme.r
    color: theme.surface

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 4

        Text {
            Layout.fillWidth: true
            text: root.value + root.unit
            color: root.valueColor
            font.pixelSize: 28
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            Layout.fillWidth: true
            text: root.label
            color: theme.textMid
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
