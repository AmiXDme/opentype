import QtQuick
import QtQuick.Layouts
import OpenType 1.0

Item {
    id: root

    property var resultData: ({})

    property real wpm: resultData.wpm || 0
    property real rawWpm: resultData.rawWpm || 0
    property real accuracy: resultData.accuracy || 0
    property real time: resultData.time || 0
    property int correct: resultData.correct || 0
    property int errors: resultData.errors || 0
    property var samples: resultData.samples || []

    signal goHome()
    signal restart()

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 16

            StatBadge {
                value: Math.round(root.wpm).toString()
                label: "WPM"
            }

            StatBadge {
                value: Math.round(root.accuracy).toString()
                label: "Accuracy"
                unit: "%"
            }

            StatBadge {
                value: root.time >= 60 ? Math.floor(root.time / 60).toString() : Math.round(root.time).toString()
                label: "Time"
                unit: root.time >= 60 ? "m" : "s"
            }

            StatBadge {
                value: root.correct.toString()
                label: "Correct"
            }
        }

        ResultChart {
            Layout.fillWidth: true
            Layout.fillHeight: true
            samples: root.samples
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 16

            NavButton {
                text: "Home"
                onClicked: root.goHome()
            }

            AppButton {
                text: "Type Again"
                primary: true
                onClicked: root.restart()
            }
        }
    }
}