import QtQuick

Canvas {
    id: root

    property var values: []
    property color line: theme.accent
    property bool autoScale: false

    implicitHeight: 60

    onValuesChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()

        if (values.length < 2) return

        var min = values[0], max = values[0]
        for (var i = 1; i < values.length; i++) {
            min = Math.min(min, values[i])
            max = Math.max(max, values[i])
        }

        if (root.autoScale) {
            min = 0
        }

        var range = max - min
        if (range === 0) range = 1

        var stepX = width / (values.length - 1)

        ctx.strokeStyle = root.line
        ctx.lineWidth = 2
        ctx.lineJoin = "round"

        ctx.beginPath()
        ctx.moveTo(0, height - ((values[0] - min) / range) * height)

        for (var j = 1; j < values.length; j++) {
            var x = j * stepX
            var y = height - ((values[j] - min) / range) * height
            ctx.lineTo(x, y)
        }
        ctx.stroke()
    }
}
