/* GCompris - GCAudio.qml
 *
 * Copyright (C) 2014 Johnny Jazeix
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import QtMultimedia 5.0
import GCompris 1.0

Item {
    id: gcaudio
    property bool muted: !ApplicationSettings.isAudioEnabled

    property alias source: audio.source
    property alias errorString: audio.errorString
    property bool autoPlay
    property var files: []

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

    function append(file) {
        if(audio.playbackState == Audio.StoppedState) {
            source = file
            play()
        } else {
            files.push(file)
        }

    }

    Audio {
        id: audio
        autoPlay: gcaudio.autoPlay && !gcaudio.muted
        onError: {
            console.log("error while playing: " + source + ": " + errorString)
            gcaudio.error()
        }
        onStopped: {
            var nextFile = files.shift()
            if(nextFile) {
                source = nextFile
                play()
            } else
                gcaudio.done()
        }
    }
}
