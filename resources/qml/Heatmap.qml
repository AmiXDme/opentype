import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property var stats: []
    property string metric: "accuracy"

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
                    model: root.keyWidths[index]

                    Rectangle {
                        width: root.keyU * modelData + root.keyGap * (modelData - 1)
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
                            font.pixelSize: 10
                            font.weight: Font.DemiBold
                        }
                    }
                }
            }
        }
    }
}
