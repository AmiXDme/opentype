import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property real wpm: 0
    property real rawWpm: 0
    property real accuracy: 0
    property real time: 0
    property int correct: 0
    property int errors: 0
    property var samples: []

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
                value: Math.floor(root.time / 60).toString()
                label: "Time"
                unit: "m"
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
