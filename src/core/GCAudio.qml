/* GCompris - GCAudio.qml
 *
 * Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>
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
import QtQuick 2.6
import QtMultimedia 5.0
import GCompris 1.0

/**
 * A QML component for audio playback.
 * @ingroup components
 *
 * Wrapper component around QtQuick's Audio element, handling all audio
 * playback in GCompris uniformly.
 *
 * It maintains a queue of audio-sources (@ref files) that are played back
 * sequentially, to which the user can enqueue files that should be scheduled
 * for playback.
 *
 * To make sure an audio voice will be localized, replace the locale part
 * of the file by '$LOCALE'.
 *
 * To makes sure that all audio sources are normalized with respect to
 * ApplicationInfo.CompressedAudio replace the 'ogg' part of the file by
 * '$CA'.
 *
 * @inherit QtQuick.Item
 */
Item {
    id: gcaudio

    /**
     * type:bool
     * Whether audio should be muted.
     */
    property bool muted

    /**
     * type:url
     * URL to the audio source to be played back.
     */
    property alias source: audio.source

    /**
     * type:string
     * Detailed error message in case of playback errors.
     */
    property alias errorString: audio.errorString

    /**
     * type:var
     * Current playback state.
     *
     * Possible values taken from Audio.status
     */
    property var playbackState: (audio.error == Audio.NoError) ?
                                    audio.playbackState : Audio.StoppedState;

    /**
     * type:list
     * Playback queue.
     */
    property var files: []

    /**
     * Emitted in case of error.
     */
    signal error

    /**
     * Emitted when playback of all scheduled audio sources has finished.
     */
    signal done

    /**
     *  When mute is changed we set the volume to 0 to mute a potential playing
     * sound.
     */
    onMutedChanged: muted ? audio.volume = 0 : audio.volume = 1

    /**
     * Plays back the audio resource @p file.
     *
     * @param type:string file [optional] URL to an audio source.
     * @returns @c true if playback has been started, @c false if file does not
     *          exist or audio is muted
     */
    function play(file) {
        if(!fileId.exists(file) || muted)
            return false

        if(file) {
            // Setting the source to "" on Linux fix a case where the sound is no more played if you play twice the same sound in a row
            source = ""
            source = file
        }
        if(!muted) {
            audio.play()
        }
        return true
    }

    /**
     * Stops audio playback.
     */
    function stop() {
        if(audio.playbackState != Audio.StoppedState)
            audio.stop()
    }

    /**
     * Schedules a @p file for audio playback.
     *
     * If there is no playback currently running, the new source will be
     * played back immediately. Otherwise it is appended to the file queue of
     * sources.
     *
     * @param type:string file File to the audio file to be played back.
     * @returns @c true upon success, or @c false if @p file does not exist or
     *             audio is muted
     */
    function append(file) {
        if(!fileId.exists(file) || muted)
            return false

        if(audio.playbackState !== Audio.PlayingState
           || audio.status === Audio.EndOfMedia
           || audio.status === Audio.NoMedia
           || audio.status === Audio.InvalidMedia) {
            // Setting the source to "" on Linux fix a case where the sound is no more played
            source = ""
            source = file
            files.push(file)
            silenceTimer.start()
        } else {
            files.push(file)
        }
        return true
    }

    /**
     * Adds a pause of the given duration in ms before playing of the next file.
     *
     * @param type:int duration_ms Pause in milliseconds.
     */
    function silence(duration_ms) {
        silenceTimer.interval = duration_ms
    }

    /**
     * Flushes the list of scheduled files.
     * @sa files
     */
    function clearQueue() {
        while(files.length > 0) {
            files.pop();
        }
    }

    /// @cond INTERNAL_DOCS

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
                silenceTimer.start()
            else
                gcaudio.error()
        }
        onStopped: {
            if(files.length)
                silenceTimer.start()
            else
                gcaudio.done()
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

    File {
        id: fileId
    }

    /// @endcond

}
