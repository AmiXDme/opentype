import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import OpenType 1.0

Dialog {
    id: root

    property string userTheme: App.profileManager.settings.theme || "yaru_dark"

    title: "Theme Picker"
    modal: true
    width: 600
    height: 500

    background: Rectangle {
        color: theme.bg
        radius: theme.rlg
        border.color: theme.border
        border.width: 1
    }

    onClosed: {
        if (App.profileManager.settings.theme !== root.userTheme) {
            var s = App.profileManager.settings
            s.theme = root.userTheme
            App.profileManager.setSettings(s)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Text {
            text: "Colour Themes"
            color: theme.text
            font.pixelSize: 18
            font.weight: Font.Bold
        }

        GridView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 110
            cellHeight: 90
            model: App.themeCatalog.themeNames()

            delegate: Item {
                width: 100
                height: 80

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: theme.rsm
                    color: App.themeCatalog.colors(modelData).bg || "#1a1a1a"
                    border.color: root.userTheme === modelData ? theme.accent : theme.border
                    border.width: root.userTheme === modelData ? 2 : 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 4

                        Rectangle {
                            width: 50
                            height: 18
                            radius: 4
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: App.themeCatalog.colors(modelData).main || "#e2b714"
                        }

                        Text {
                            text: modelData
                            color: App.themeCatalog.colors(modelData).text || "#e0e0e0"
                            font.pixelSize: 9
                            anchors.horizontalCenter: parent.horizontalCenter
                            elide: Text.ElideRight
                            width: 80
                            horizontalAlignment: Text.AlignHCenter
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
                text: "Selected: " + root.userTheme
                color: theme.textMid
                font.pixelSize: 12
            }

            Item { Layout.fillWidth: true }

            AppButton {
                text: "Apply"
                primary: true
                onClicked: root.close()
            }

            AppButton {
                text: "Cancel"
                onClicked: root.close()
            }
        }
    }
}