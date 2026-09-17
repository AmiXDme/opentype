pragma Singleton
import QtQuick

QtObject {
    id: focusState

    property bool enabled: false
    property bool typing: false
    property bool mouseActive: false

    readonly property bool engaged: enabled && typing && !mouseActive
}
