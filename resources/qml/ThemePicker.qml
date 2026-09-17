import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Dialog {
    id: root

    property string userTheme: "yaru_dark"

    title: "Theme Picker"
    modal: true
    width: 500
    height: 400

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
            text: "Colour themes"
            color: Theme.text
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
                    radius: Theme.rsm
                    color: ThemeCatalog.colors(modelData).bg || "#1a1a1a"
                    border.color: root.userTheme === modelData ? Theme.accent : Theme.border
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
                color: Theme.text
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
