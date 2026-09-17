import QtQuick
import OpenType 1.0

Item {
    id: root

    property string clickPack: "off"
    property string errorPack: "off"
    property real volume: 0.5

    SoundMixer {
        id: mixer
        volume: root.volume
    }

    function playClick() {
        mixer.playClick(root.clickPack)
    }

    function playError() {
        mixer.playError(root.errorPack)
    }

    function previewPack(pack) {
        mixer.preview(pack)
    }
}
