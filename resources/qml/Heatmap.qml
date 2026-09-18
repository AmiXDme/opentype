import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property var stats: []
    property string metric: "accuracy"
    property bool compact: false
    property string nextKey: ""
    property bool showSpacebar: true

    color: "transparent"

    readonly property real keyU: 36
    readonly property real keyGap: 5
    property var _byKey: ({})

    property var keyRows: [
        ["`","1","2","3","4","5","6","7","8","9","0","-","="],
        ["q","w","e","r","t","y","u","i","o","p","[","]"],
        ["a","s","d","f","g","h","j","k","l",";","'"],
        ["z","x","c","v","b","n","m",",",".","/"]
    ]

    property var keyWidths: [
        [1,1,1,1,1,1,1,1,1,1,1,1,1.5],
        [1.5,1,1,1,1,1,1,1,1,1,1,1.5],
        [1.75,1,1,1,1,1,1,1,1,1,2.25],
        [2.25,1,1,1,1,1,1,1,1,1,2.75]
    ]

    function colorFor(k) {
        var s = _byKey[k]
        if (!s || s.attempts === 0) return theme.surface2
        if (root.metric === "speed") {
            var t = 0
            var maxT = 1
            for (var key in _byKey) {
                var v = _byKey[key]
                if (v && v.avgTime > maxT) maxT = v.avgTime
            }
            t = Math.min(1, (s.avgTime || 0) / (maxT || 1))
            var r = theme.good.r * (1 - t) + theme.error.r * t
            var g = theme.good.g * (1 - t) + theme.error.g * t
            var b = theme.good.b * (1 - t) + theme.error.b * t
            return Qt.rgba(r, g, b, 1)
        }
        var errRate = s.errors / s.attempts
        if (errRate < 0.05) return theme.good
        if (errRate < 0.15) return theme.accent
        if (errRate < 0.30) return Qt.rgba(
            theme.error.r * 0.6 + theme.accent.r * 0.4,
            theme.error.g * 0.6 + theme.accent.g * 0.4,
            theme.error.b * 0.6 + theme.accent.b * 0.4, 1)
        return theme.error
    }

    function hasData(k) {
        var s = _byKey[k]
        return s && s.attempts > 0
    }

    function getKeyLabel(row, col) {
        if (row < keyRows.length && col < keyRows[row].length) {
            return keyRows[row][col]
        }
        return ""
    }

    function _rebuild() {
        var m = {}
        for (var i = 0; i < stats.length; i++) {
            m[stats[i].key] = stats[i]
        }
        _byKey = m
    }

    function rowCount() {
        return root.compact ? 3 : root.keyRows.length
    }

    function keysForRow(r) {
        var rr = root.compact ? r + 1 : r
        var out = []
        if (rr < 0 || rr >= keyRows.length) return out
        var row = keyRows[rr]
        var widths = rr < keyWidths.length ? keyWidths[rr] : []
        for (var c = 0; c < row.length; c++) {
            out.push({ k: row[c], w: c < widths.length ? widths[c] : 1 })
        }
        return out
    }

    function isNext(k) {
        if (root.nextKey === undefined || root.nextKey === "") return false
        return String(root.nextKey).toLowerCase() === String(k).toLowerCase()
    }

    onStatsChanged: _rebuild()

    Column {
        anchors.centerIn: parent
        spacing: root.keyGap

        Repeater {
            model: root.rowCount()
            delegate: Row {
                required property int index
                property int r: index
                spacing: root.keyGap
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: root.keysForRow(r)

                    Rectangle {
                        required property var modelData
                        width: root.keyU * modelData.w + root.keyGap * (modelData.w - 1)
                        height: root.keyU
                        radius: 4
                        color: root.colorFor(modelData.k)
                        border.color: root.isNext(modelData.k) ? theme.accent : "transparent"
                        border.width: root.isNext(modelData.k) ? 2 : 0

                        Text {
                            anchors.centerIn: parent
                            text: modelData.k === " " ? "SPACE" : String(modelData.k).toUpperCase()
                            color: root.hasData(modelData.k) ? "#10131a" : theme.textDim
                            font.pixelSize: 10
                            font.weight: Font.DemiBold
                        }
                    }
                }
            }
        }

        Rectangle {
            visible: root.showSpacebar
            width: root.keyU * 6.25
            height: root.keyU * 0.9
            radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.colorFor(" ")
            border.color: root.isNext(" ") ? theme.accent : "transparent"
            border.width: root.isNext(" ") ? 2 : 0
        }
    }
}
