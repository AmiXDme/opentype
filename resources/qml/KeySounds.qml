import QtQuick

Item {
    id: root

    property string clickPack: "off"
    property string errorPack: "off"
    property real volume: 0.5

    function playClick() {
        SoundMixer.playClick(clickPack)
    }

    function playError() {
        SoundMixer.playError(errorPack)
    }

    function previewPack(pack) {
        SoundMixer.preview(pack)
    }
}
