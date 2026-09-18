import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import OpenType 1.0

Dialog {
    id: root

    property string userTheme: App.profileManager.settings.theme || "yaru_dark"
    property string searchText: ""
    property string randomMode: App.profileManager.settings.randomMode || "off"

    title: "Theme"
    modal: true
    width: 640
    height: 520

    background: Rectangle {
        color: theme.bg
        radius: theme.rlg
        border.color: theme.border
        border.width: 1
    }

    onClosed: {
        var s = App.profileManager.settings
        var changed = false
        if (s.theme !== root.userTheme) { s.theme = root.userTheme; changed = true }
        if (s.randomMode !== root.randomMode) { s.randomMode = root.randomMode; changed = true }
        if (changed) App.profileManager.setSettings(s)
        theme.activePreset = root.userTheme
    }

    function filteredThemes() {
        var all = App.themeCatalog.themeNames()
        if (searchText.length === 0) return all
        var q = searchText.toLowerCase()
        return all.filter(function(n) { return n.toLowerCase().indexOf(q) !== -1 })
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        RowLayout {
            Layout.fillWidth: true

            ColumnLayout {
                spacing: 0

                Text {
                    text: "Theme"
                    color: theme.text
                    font.pixelSize: 18
                    font.weight: Font.Bold
                }

                Text {
                    text: "Auto light / dark"
                    color: theme.text
                    font.pixelSize: 13
                    font.weight: Font.Medium
                }

                Text {
                    text: "Follow system appearance"
                    color: theme.textDim
                    font.pixelSize: 11
                }
            }

            Item { Layout.fillWidth: true }

            TextField {
                id: searchField
                Layout.preferredWidth: 180
                Layout.preferredHeight: 34
                placeholderText: "Search themes..."
                text: root.searchText
                onTextChanged: root.searchText = text
                color: theme.text
                font.pixelSize: 12
                background: Rectangle {
                    radius: theme.rsm
                    color: theme.surface2
                    border.color: theme.border
                    border.width: 1
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            ColumnLayout {
                spacing: 0

                Text {
                    text: "Random theme"
                    color: theme.text
                    font.pixelSize: 13
                    font.weight: Font.Medium
                }

                Text {
                    text: "Switch to a random preset after each test"
                    color: theme.textDim
                    font.pixelSize: 11
                }
            }

            Item { Layout.fillWidth: true }

            Repeater {
                model: ["off", "on", "light", "dark"]
                Rectangle {
                    required property var modelData
                    Layout.preferredWidth: 52
                    Layout.preferredHeight: 30
                    radius: 15
                    color: root.randomMode === modelData ? theme.accent : theme.surface2
                    border.color: theme.border
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: root.randomMode === modelData ? theme.bg : theme.textDim
                        font.pixelSize: 11
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.randomMode = modelData
                    }
                }
            }
        }

        GridView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            cellWidth: 146
            cellHeight: 44
            model: filteredThemes()

            delegate: Item {
                required property var modelData
                required property int index
                width: 146
                height: 44

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 3
                    radius: theme.rsm
                    color: App.themeCatalog.colors(modelData).bg || "#1a1a1a"
                    border.color: root.userTheme === modelData ? theme.accent : theme.border
                    border.width: root.userTheme === modelData ? 2 : 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 8
                        spacing: 6

                        Text {
                            Layout.fillWidth: true
                            text: modelData
                            color: App.themeCatalog.colors(modelData).text || "#e0e0e0"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }

                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            color: App.themeCatalog.colors(modelData).main || "#e2b714"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.userTheme = modelData
                            theme.activePreset = modelData
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
                text: "Done"
                primary: true
                onClicked: root.close()
            }
        }
    }
}
