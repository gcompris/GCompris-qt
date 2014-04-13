import QtQuick 2.0
import QtMultimedia 5.0
import GCompris 1.0

Item {
    property bool muted: !ApplicationInfo.isAudioEnabled

    property alias source: audio.source
    property alias autoPlay: audio.autoPlay

    function play() {
        if(!muted) {
            audio.play()
        }
    }

    Audio {
        id: audio
        onError: console.log("error while playing: " + source + ": " + errorString)
        onPlaying: console.log("Playing " + source)
    }
}
