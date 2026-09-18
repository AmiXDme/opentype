import QtQuick
import QtQuick.Layouts
import OpenType 1.0

Item {
    id: root

    signal goHome()

    property string heatMetric: "accuracy"
    property string exportStatus: ""

    StatsStore {
        id: statsStore
        Component.onCompleted: {
            var pid = (App.profileManager.activeId || "default")
            statsStore.loadStats(pid)
        }
    }

    function keyList() {
        var totals = statsStore.keyTotals()
        var out = []
        for (var k in totals) {
            var t = totals[k]
            out.push({ key: k, attempts: t.attempts, errors: t.errors,
                accuracy: t.accuracy, avgTime: t.avgTime })
        }
        return out
    }

    function strongestKeys() {
        var list = keyList().filter(function(e) { return e.attempts >= 3 })
        list.sort(function(a, b) { return b.accuracy - a.accuracy })
        return list.slice(0, 6)
    }

    function weakestKeys() {
        var list = keyList().filter(function(e) { return e.attempts >= 3 })
        list.sort(function(a, b) { return a.accuracy - b.accuracy })
        return list.slice(0, 6)
    }

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentCol.implicitHeight + 32
        clip: true
        flickableDirection: Flickable.VerticalFlick

        ColumnLayout {
            id: contentCol
            width: parent.width
            anchors.margins: 16
            spacing: 12

            RowLayout {
                Layout.fillWidth: true

                NavButton {
                    text: "Home"
                    onClicked: root.goHome()
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "Statistics"
                    color: theme.text
                    font.pixelSize: 18
                    font.weight: Font.Bold
                }

                Item { Layout.fillWidth: true }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                StatBadge {
                    value: statsStore.totalSessions.toString()
                    label: "Sessions"
                }

                StatBadge {
                    value: Math.round(statsStore.bestWpm).toString()
                    label: "Best WPM"
                }

                StatBadge {
                    value: Math.round(statsStore.averageWpm).toString()
                    label: "Avg WPM"
                }

                StatBadge {
                    value: Math.round(statsStore.averageAccuracy).toString()
                    label: "Avg Accuracy"
                    unit: "%"
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 190
                pad: 16

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 6

                    Text {
                        text: "ACCURACY OVER TIME"
                        color: theme.textDim
                        font.pixelSize: 11
                    }

                    HistoryChart {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        values: {
                            var accList = []
                            var sessions = statsStore.sessions()
                            for (var i = 0; i < sessions.length; i++) {
                                accList.push(sessions[i].accuracy || 0)
                            }
                            return accList
                        }
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                pad: 16

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 8

                    Text {
                        text: "STRONGEST KEYS"
                        color: theme.textDim
                        font.pixelSize: 11
                    }

                    RowLayout {
                        spacing: 8

                        Repeater {
                            model: strongestKeys()
                            Rectangle {
                                required property var modelData
                                width: 52
                                height: 44
                                radius: theme.rsm
                                color: "transparent"
                                border.color: theme.accent
                                border.width: 1

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 0

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: String(modelData.key).toUpperCase()
                                        color: theme.accent
                                        font.pixelSize: 14
                                        font.bold: true
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: Math.round(modelData.accuracy) + "%"
                                        color: theme.textDim
                                        font.pixelSize: 10
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        text: "NEEDS WORK"
                        color: theme.textDim
                        font.pixelSize: 11
                    }

                    RowLayout {
                        spacing: 8

                        Repeater {
                            model: weakestKeys()
                            Rectangle {
                                required property var modelData
                                width: 52
                                height: 44
                                radius: theme.rsm
                                color: "transparent"
                                border.color: theme.error
                                border.width: 1

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 0

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: String(modelData.key).toUpperCase()
                                        color: theme.error
                                        font.pixelSize: 14
                                        font.bold: true
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: Math.round(modelData.accuracy) + "%"
                                        color: theme.textDim
                                        font.pixelSize: 10
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                pad: 16

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 6

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "PER-KEY ACCURACY"
                            color: theme.textDim
                            font.pixelSize: 11
                        }

                        Item { Layout.fillWidth: true }

                        Rectangle {
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 28
                            radius: 14
                            color: theme.surface2

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 2
                                spacing: 2

                                Repeater {
                                    model: ["accuracy", "speed"]
                                    Rectangle {
                                        required property var modelData
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        radius: 12
                                        color: root.heatMetric === modelData ? theme.surface : "transparent"

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData
                                            color: theme.textDim
                                            font.pixelSize: 11
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: root.heatMetric = modelData
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Heatmap {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        compact: true
                        showSpacebar: true
                        metric: root.heatMetric
                        stats: keyList()
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 8

                        Text {
                            text: heatMetric === "accuracy" ? "accurate" : "fast"
                            color: theme.textDim
                            font.pixelSize: 10
                        }

                        Rectangle {
                            Layout.preferredWidth: 120
                            Layout.preferredHeight: 6
                            radius: 3
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0; color: theme.good }
                                GradientStop { position: 0.5; color: theme.accent }
                                GradientStop { position: 1; color: theme.error }
                            }
                        }

                        Text {
                            text: "errors"
                            color: theme.textDim
                            font.pixelSize: 10
                        }
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 12

                AppButton {
                    text: "Export to CSV"
                    onClicked: {
                        var ok = statsStore.exportCsv("")
                        exportStatus = ok ? "Saved to Documents/OpenType-stats.csv" : "Export failed"
                    }
                }

                Text {
                    visible: exportStatus.length > 0
                    text: exportStatus
                    color: theme.textDim
                    font.pixelSize: 12
                }
            }
        }
    }
}
