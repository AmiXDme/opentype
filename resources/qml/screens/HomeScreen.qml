import QtQuick
import QtQuick.Layouts
import "../"

Item {
    id: root

    signal startPractice(string mode)
    signal goStats()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 32
        spacing: 32

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "WELCOME BACK"
                color: theme.text
                font.pixelSize: 28
                font.bold: true
            }

            Text {
                text: App.profileManager.activeName
                color: theme.textMid
                font.pixelSize: 14
            }
        }

        Text {
            text: "Choose a mode to start practicing"
            color: theme.textDim
            font.pixelSize: 14
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: 16
            columnSpacing: 16

            Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                pad: 24

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.startPractice("words")
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: Qt.rgba(theme.accent.r, theme.accent.g, theme.accent.b, 0.15)
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            anchors.centerIn: parent
                            text: "W"
                            color: theme.accent
                            font.pixelSize: 22
                            font.bold: true
                        }
                    }

                    Text {
                        text: "Words"
                        color: theme.text
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Type random words\nBuild speed and accuracy"
                        color: theme.textMid
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                pad: 24

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.startPractice("timed")
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: Qt.rgba(theme.accent.r, theme.accent.g, theme.accent.b, 0.15)
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            anchors.centerIn: parent
                            text: "T"
                            color: theme.accent
                            font.pixelSize: 22
                            font.bold: true
                        }
                    }

                    Text {
                        text: "Timed"
                        color: theme.text
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Type for a set time\nTest your endurance"
                        color: theme.textMid
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                pad: 24

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.startPractice("quote")
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: Qt.rgba(theme.accent.r, theme.accent.g, theme.accent.b, 0.15)
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            anchors.centerIn: parent
                            text: "Q"
                            color: theme.accent
                            font.pixelSize: 22
                            font.bold: true
                        }
                    }

                    Text {
                        text: "Quote"
                        color: theme.text
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Type famous quotes\nReal-world text"
                        color: theme.textMid
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                pad: 24

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.startPractice("adaptive")
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: Qt.rgba(theme.accent.r, theme.accent.g, theme.accent.b, 0.15)
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            anchors.centerIn: parent
                            text: "A"
                            color: theme.accent
                            font.pixelSize: 22
                            font.bold: true
                        }
                    }

                    Text {
                        text: "Adaptive"
                        color: theme.text
                        font.pixelSize: 18
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Target your weakest keys\nPersonalized training"
                        color: theme.textMid
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16

            Rectangle {
                id: statsBtn
                width: 100
                height: 40
                radius: theme.r
                color: theme.surface
                border.color: theme.border
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.goStats()
                }

                Text {
                    anchors.centerIn: parent
                    text: "Statistics"
                    color: theme.text
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }
            }
        }
    }
}