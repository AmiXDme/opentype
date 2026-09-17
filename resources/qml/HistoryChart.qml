import QtQuick

Canvas {
    id: root

    property var values: []

    implicitHeight: 150

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

        min = Math.max(0, min - 10)
        max = max + 10

        var range = max - min
        if (range === 0) range = 1

        var stepX = width / (values.length - 1)

        ctx.strokeStyle = Theme.accent
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

        var gradient = ctx.createLinearGradient(0, 0, 0, height)
        gradient.addColorStop(0, Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.3))
        gradient.addColorStop(1, Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0))

        ctx.fillStyle = gradient
        ctx.lineTo(width, height)
        ctx.lineTo(0, height)
        ctx.closePath()
        ctx.fill()
    }
}
