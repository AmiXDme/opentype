import QtQuick

Item {
    id: root

    property string keyChar: ""
    property real mastery: 0
    property int attempts: 0

    width: 38
    height: 38

    readonly property color _tone: mastery >= 0.85 ? theme.good
                                   : mastery >= 0.6 ? theme.accent
                                   : theme.error

    Rectangle {
        anchors.fill: parent
        radius: theme.rsm
        color: "transparent"
        border.color: root._tone
        border.width: 2

        Canvas {
            id: arc
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.strokeStyle = root._tone
                ctx.lineWidth = 3
                ctx.lineCap = "round"

                var m = Math.max(0, Math.min(1, root.mastery))
                var startAngle = -Math.PI / 2
                var endAngle = startAngle + (m * Math.PI * 2)

                ctx.beginPath()
                ctx.arc(width / 2, height / 2, width / 2 - 4, startAngle, endAngle)
                ctx.stroke()
            }
        }

        Text {
            anchors.centerIn: parent
            text: root.keyChar.toUpperCase()
            color: theme.text
            font.pixelSize: 12
            font.weight: Font.DemiBold
        }
    }

    onMasteryChanged: arc.requestPaint()
}
