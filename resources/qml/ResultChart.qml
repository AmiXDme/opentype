import QtQuick

Canvas {
    id: root

    property var samples: []

    implicitHeight: 150

    onSamplesChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()

        if (samples.length < 2) return

        var maxWpm = 0
        for (var i = 0; i < samples.length; i++) {
            maxWpm = Math.max(maxWpm, samples[i].wpm || 0)
        }

        if (maxWpm === 0) maxWpm = 1

        var stepX = width / (samples.length - 1)

        ctx.strokeStyle = theme.accent
        ctx.lineWidth = 2
        ctx.lineJoin = "round"

        ctx.beginPath()
        ctx.moveTo(0, height - (samples[0].wpm / maxWpm) * height)

        for (var j = 1; j < samples.length; j++) {
            var x = j * stepX
            var y = height - (samples[j].wpm / maxWpm) * height
            ctx.lineTo(x, y)
        }
        ctx.stroke()

        ctx.fillStyle = theme.error
        for (var k = 0; k < samples.length; k++) {
            if (samples[k].err > 0) {
                var ex = k * stepX
                var ey = height - (samples[k].wpm / maxWpm) * height
                ctx.beginPath()
                ctx.arc(ex, ey, 4, 0, Math.PI * 2)
                ctx.fill()
            }
        }
    }
}
