import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Dialog {
    id: root

    title: "About"
    modal: true
    width: 400
    height: 300

    background: Rectangle {
        color: Theme.bg
        radius: Theme.rlg
        border.color: Theme.border
        border.width: 1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Text {
            text: "OpenType"
            color: Theme.text
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Open-source typing tutor"
            color: Theme.textMid
            font.pixelSize: 14
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Version 1.0.0"
            color: Theme.textDim
            font.pixelSize: 12
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Reverse engineered from TypingMaster v2.0.1\nby Keshav Bhatt (KTechpit)"
            color: Theme.textDim
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Item { Layout.fillHeight: true }

        AppButton {
            text: "Close"
            Layout.alignment: Qt.AlignHCenter
            onClicked: root.close()
        }
    }
}
