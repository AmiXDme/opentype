import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string value: ""
    property string label: ""
    property string unit: ""
    property color valueColor: Theme.text
    property color fillColor: Theme.accent

    width: 120
    height: 80
    radius: Theme.r
    color: Theme.surface

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
            color: Theme.textMid
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
