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

Item {
    id: gcaudio
    property bool muted

    property alias source: audio.source
    property alias errorString: audio.errorString
    property var playbackState: (audio.error == Audio.NoError) ? 
                                    audio.playbackState : Audio.StoppedState;
    property var files: []

    signal error
    signal done

    // @param file is optional
    function play(file) {

        if(file)
            source = file

        if(!muted) {
            audio.play()
        }
    }

    function stop() {
        if(audio.playbackState != Audio.StoppedState)
            audio.stop()
    }

    function append(file) {
        if(muted)
            return

        if(audio.playbackState !== Audio.PlayingState
           || audio.status === Audio.EndOfMedia
           || audio.status === Audio.NoMedia
           || audio.status === Audio.InvalidMedia) {
            // Setting the source to "" on Linux fix a case where the sound is no more played
            source = ""
            source = file
            audio.play()
        } else {
            files.push(file)
        }
    }

    // Add the given duration in ms before the play of the next file
    function silence(duration_ms) {
        silenceTimer.interval = duration_ms
    }

    function clearQueue() {
        while(files.length > 0) {
            files.pop();
        }
    }

    function _playNextFile() {
        var nextFile = files.shift()
        if(!nextFile || 0 === nextFile.length) {
            audio.source = ""
            gcaudio.done()
        } else {
            audio.source = ""
            audio.source = nextFile
            if(!muted)
                audio.play()
        }
    }

    Audio {
        id: audio
        onError: {
            // This file cannot be played, remove it from the source asap
            source = ""
            if(files.length)
                _playNextFile()
            else
                gcaudio.error()
        }
        onStopped: {
            if(silenceTimer.interval)
                silenceTimer.start()
            else
                _playNextFile()
        }
    }

    Timer {
        id: silenceTimer
        repeat: false
        onTriggered: {
            interval = 0
            _playNextFile()
        }
    }

}
