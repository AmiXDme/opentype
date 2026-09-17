import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    id: root

    property var stats: []
    property string metric: "accuracy"

    color: "transparent"

    readonly property real keyU: 38
    readonly property real keyGap: 6
    property var _byKey: ({})

    function colorFor(k) {
        var s = _byKey[k]
        if (!s || s.attempts === 0) return Theme.textDim
        var t = Math.min(1, s.errorRate / 0.25)
        return Qt.rgba(
            Theme.good.r * (1 - t) + Theme.error.r * t,
            Theme.good.g * (1 - t) + Theme.error.g * t,
            Theme.good.b * (1 - t) + Theme.error.b * t,
            1
        )
    }

    function hasData(k) {
        var s = _byKey[k]
        return s && s.attempts > 0
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
                    model: index === 0 ? 13 : (index === 1 ? 12 : (index === 2 ? 11 : 1))

                    Rectangle {
                        width: index === 0 && Repeater.index === 0 ? root.keyU * 6 : root.keyU
                        height: root.keyU
                        radius: 4
                        color: {
                            var keys = ["`","1","2","3","4","5","6","7","8","9","0","-","="]
                            var keys2 = ["q","w","e","r","t","y","u","i","o","p","[","]"]
                            var keys3 = ["a","s","d","f","g","h","j","k","l",";","'"]
                            var keys4 = [" "]
                            var allKeys = [keys, keys2, keys3, keys4]
                            var k = allKeys[Repeater.index][index]
                            return root.colorFor(k)
                        }

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var keys = ["`","1","2","3","4","5","6","7","8","9","0","-","="]
                                var keys2 = ["q","w","e","r","t","y","u","i","o","p","[","]"]
                                var keys3 = ["a","s","d","f","g","h","j","k","l",";","'"]
                                var keys4 = [" "]
                                var allKeys = [keys, keys2, keys3, keys4]
                                var k = allKeys[Repeater.index][index]
                                return k === " " ? "SPACE" : k.toUpperCase()
                            }
                            color: root.hasData({
                                var keys = ["`","1","2","3","4","5","6","7","8","9","0","-","="]
                                var keys2 = ["q","w","e","r","t","y","u","i","o","p","[","]"]
                                var keys3 = ["a","s","d","f","g","h","j","k","l",";","'"]
                                var keys4 = [" "]
                                var allKeys = [keys, keys2, keys3, keys4]
                                return allKeys[Repeater.index][index]
                            }) ? "#10131a" : Theme.textDim
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                        }
                    }
                }
            }
        }
    }
}
