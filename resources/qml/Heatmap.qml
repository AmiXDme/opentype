import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property var stats: []
    property string metric: "accuracy"

    color: "transparent"

    readonly property real keyU: 38
    readonly property real keyGap: 6
    property var _byKey: ({})

    property var keyRows: [
        ["`","1","2","3","4","5","6","7","8","9","0","-","="],
        ["q","w","e","r","t","y","u","i","o","p","[","]"],
        ["a","s","d","f","g","h","j","k","l",";","'"],
        ["z","x","c","v","b","n","m",",",".","/"]
    ]

    function colorFor(k) {
        var s = _byKey[k]
        if (!s || s.attempts === 0) return theme.textDim
        var t = Math.min(1, s.errorRate / 0.25)
        var r = theme.good.r * (1 - t) + theme.error.r * t
        var g = theme.good.g * (1 - t) + theme.error.g * t
        var b = theme.good.b * (1 - t) + theme.error.b * t
        return Qt.rgba(r, g, b, 1)
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

    onStatsChanged: _rebuild()

    Column {
        anchors.centerIn: parent
        spacing: root.keyGap

        Repeater {
            model: 4
            Row {
                spacing: root.keyGap
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: {
                        if (index === 0) return 13
                        if (index === 1) return 12
                        if (index === 2) return 11
                        return 10
                    }

                    Rectangle {
                        width: root.keyU
                        height: root.keyU
                        radius: 4
                        color: root.colorFor(root.getKeyLabel(Repeater.index, index))

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var k = root.getKeyLabel(Repeater.index, index)
                                return k === " " ? "SPACE" : k.toUpperCase()
                            }
                            color: root.hasData(root.getKeyLabel(Repeater.index, index)) ? "#10131a" : theme.textDim
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                        }
                    }
                }
            }
        }
    }
}
