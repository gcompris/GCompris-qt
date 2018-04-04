/* GCompris - GCSoundEffect.qml
 *
 * Copyright (C) 2018 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com> (GCAudio base, 2014)
 *   Timothée Giet <animtim@gmail.com>
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
 * A QML component for sfx playback.
 * @ingroup components
 *
 * Wrapper component around QtQuick's SoundEffect element, handling all sfx
 * playback in GCompris uniformly.
 *
 * It maintains a queue of sfx-sources (@ref files) that are played back
 * sequentially, to which the user can enqueue files that should be scheduled
 * for playback.
 *
 * To make sure an sfx voice will be localized, replace the locale part
 * of the file by '$LOCALE'.
 *
 * To makes sure that all sfx sources are normalized with respect to
 * ApplicationInfo.CompressedSoundEffect replace the 'ogg' part of the file by
 * '$CA'.
 *
 * @inherit QtQuick.Item
 */
Item {
    id: gcsfx

    /**
     * type:bool
     * Whether sfx should be muted.
     */
    property bool muted

    /**
     * type:url
     * URL to the sfx source to be played back.
     */
    property alias source: sfx.source

    /**
     * type:string
     * Status of the fx player.
     */
    property alias status: sfx.status

    /**
     * type:var
     * Current playback state.
     *
     * Possible values taken from SoundEffect.status
     */
    property var playbackState: (sfx.error == SoundEffect.NoError) ?
                                    sfx.playbackState : SoundEffect.StoppedState;

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
     * Emitted when playback of all scheduled sfx sources has finished.
     */
    signal done

    /**
     *  When mute is changed we set the volume to 0 to mute a potential playing
     * sound.
     */
    onMutedChanged: muted ? sfx.volume = 0 : sfx.volume = 1

    /**
     * Plays back the sfx resource @p file.
     *
     * @param type:string file [optional] URL to an sfx source.
     * @returns @c true if playback has been started, @c false if file does not
     *          exist or sfx is muted
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
            sfx.play()
        }
        return true
    }

    /**
     * Stops sfx playback.
     */
    function stop() {
        if(sfx.playbackState != SoundEffect.StoppedState)
            sfx.stop()
    }

    /**
     * Schedules a @p file for sfx playback.
     *
     * If there is no playback currently running, the new source will be
     * played back immediately. Otherwise it is appended to the file queue of
     * sources.
     *
     * @param type:string file File to the sfx file to be played back.
     * @returns @c true upon success, or @c false if @p file does not exist or
     *             sfx is muted
     */
    function append(file) {
        if(!fileId.exists(file) || muted)
            return false

        if(sfx.playbackState !== SoundEffect.PlayingState
           || sfx.status === SoundEffect.EndOfMedia
           || sfx.status === SoundEffect.NoMedia
           || sfx.status === SoundEffect.InvalidMedia) {
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
            sfx.source = ""
            gcsfxdone()
        } else {
            sfx.source = ""
            sfx.source = nextFile
            if(!muted)
                sfx.play()
        }
    }

    SoundEffect {
        id: sfx
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
