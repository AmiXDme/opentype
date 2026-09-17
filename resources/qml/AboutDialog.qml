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
        color: theme.bg
        radius: theme.rlg
        border.color: theme.border
        border.width: 1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Text {
            text: "OpenType"
            color: theme.text
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Open-source typing tutor"
            color: theme.textMid
            font.pixelSize: 14
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Version 1.0.0"
            color: theme.textDim
            font.pixelSize: 12
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Reverse engineered from TypingMaster v2.0.1\nby Keshav Bhatt (KTechpit)"
            color: theme.textDim
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
