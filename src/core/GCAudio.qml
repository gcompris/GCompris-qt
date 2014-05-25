import QtQuick 2.0
import QtMultimedia 5.0
import GCompris 1.0

Item {
    id: gcaudio
    property bool muted: !ApplicationSettings.isAudioEnabled

    property alias source: audio.source
    property bool autoPlay

    function play() {
        if(!muted) {
            audio.play()
        }
    }

    Audio {
        id: audio
        autoPlay: gcaudio.autoPlay && !gcaudio.muted
        onError: console.log("error while playing: " + source + ": " + errorString)
    }
}
