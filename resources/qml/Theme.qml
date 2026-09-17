pragma Singleton
import QtQuick

QtObject {
    id: theme

    property var _c: ThemeCatalog.colors(activePreset)
    property bool dark: Qt.colorEqual(_c.bg, "#000000") || _lum(_c.bg) < 0.5

    readonly property color bg: _c.bg || "#1a1a1a"
    readonly property color main: _c.main || "#e2b714"
    readonly property color caret: _c.caret || "#e2b714"
    readonly property color sub: _c.sub || "#5a5a5a"
    readonly property color subAlt: _c.subAlt || "#151515"
    readonly property color text: _c.text || "#e0e0e0"
    readonly property color error: _c.error || "#ca4747"
    readonly property color errorExtra: _c.errorExtra || "#ca4747"

    readonly property color accent: main
    readonly property color good: main
    readonly property color surface: subAlt
    readonly property color surface2: Qt.lighter(subAlt, 1.1)
    readonly property color border: Qt.darker(subAlt, 1.2)
    readonly property color textDim: Qt.darker(text, 1.5)
    readonly property color textMid: Qt.lighter(text, 0.7)
    readonly property color shadow: "#000000"
    readonly property real shadowOpacity: dark ? 0.5 : 0.16

    readonly property int r: 12
    readonly property int rlg: 18
    readonly property int rsm: 8

    readonly property string mono: "monospace"
    readonly property string ui: Qt.application.font.family

    property string activePreset: "yaru_dark"

    function _lum(c) {
        var r = Qt.red(c) / 255
        var g = Qt.green(c) / 255
        var b = Qt.blue(c) / 255
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }

    function _mix(a, b, t) {
        var r = Qt.red(a) * (1 - t) + Qt.red(b) * t
        var g = Qt.green(a) * (1 - t) + Qt.green(b) * t
        var bb = Qt.blue(a) * (1 - t) + Qt.blue(b) * t
        return Qt.rgba(r / 255, g / 255, bb / 255, 1)
    }
}
