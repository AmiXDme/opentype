import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import OpenType 1.0

Dialog {
    id: root

    property string userTheme: "yaru_dark"

    title: "Theme Picker"
    modal: true
    width: 500
    height: 400

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
            text: "Colour themes"
            color: theme.text
            font.pixelSize: 18
            font.weight: Font.Bold
        }

        GridView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 100
            cellHeight: 80
            model: ThemeCatalog.themeNames()

            delegate: Item {
                width: 90
                height: 70

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: theme.rsm
                    color: ThemeCatalog.colors(modelData).bg || "#1a1a1a"
                    border.color: root.userTheme === modelData ? theme.accent : theme.border
                    border.width: root.userTheme === modelData ? 2 : 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 4

                        Rectangle {
                            width: 40
                            height: 16
                            radius: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: ThemeCatalog.colors(modelData).main || "#e2b714"
                        }

                        Text {
                            text: modelData
                            color: ThemeCatalog.colors(modelData).text || "#e0e0e0"
                            font.pixelSize: 9
                            anchors.horizontalCenter: parent.horizontalCenter
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.userTheme = modelData
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Auto light / dark"
                color: theme.text
                font.pixelSize: 14
            }

            Item { Layout.fillWidth: true }

            AppButton {
                text: "Close"
                onClicked: root.close()
            }
        }
    }
}
