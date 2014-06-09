import QtQuick 2.0
import QtMultimedia 5.0
import GCompris 1.0

Item {
    id: gcaudio
    property bool muted: !ApplicationSettings.isAudioEnabled

    property alias source: audio.source
    property alias errorString: audio.errorString
    property bool autoPlay

    signal error
    signal done

    function play() {
        if(!muted) {
            audio.play()
        }
    }

    function stop() {
        if(audio.playbackState != Audio.StoppedState)
            audio.stop()
    }

    Audio {
        id: audio
        autoPlay: gcaudio.autoPlay && !gcaudio.muted
        onError: {
            console.log("error while playing: " + source + ": " + errorString)
            gcaudio.error()
        }
        onStopped: gcaudio.done()
    }
}
