import QtQuick
import QtQuick.Layouts
import OpenType 1.0

Item {
    id: root

    signal goHome()

    StatsStore {
        id: statsStore
        Component.onCompleted: {
            var pid = (App.profileManager.activeId || "default")
            statsStore.loadStats(pid)
        }
    }

    property string exportStatus: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

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
            spacing: 16

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
            Layout.fillHeight: true
            pad: 16

            HistoryChart {
                anchors.fill: parent
                values: {
                    var wpmList = []
                    var sessions = statsStore.sessions()
                    for (var i = 0; i < sessions.length; i++) {
                        wpmList.push(sessions[i].wpm || 0)
                    }
                    return wpmList
                }
            }
        }

        AppButton {
            text: "Export to CSV"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                var ok = statsStore.exportCsv("")
                exportStatus = ok ? "Saved to Documents/OpenType-stats.csv" : "Export failed"
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            visible: exportStatus.length > 0
            text: exportStatus
            color: theme.textDim
            font.pixelSize: 12
        }
    }
}