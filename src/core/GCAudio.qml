/* GCompris - GCAudio.qml
 *
 * SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtMultimedia
import core 1.0

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
    onMutedChanged: {
        if(muted) {
            audio.stop();
        }
    }
    /**
     * type:url
     * URL to the audio source to be played back.
     */
    property alias source: audio.source

    /**
     * type: positive real number less than 1
     * Determines intensity of the audio.
     */
    property alias volume: audio.volume

    /**
     * type:bool
     * Whether the audio element contains audio.
     */
    property bool hasAudio: audio.hasAudio

    /**
     * type:string
     * Detailed error message in case of playback errors.
     */
    property alias errorString: audio.errorString
    
    /**
     * type:bool
     * check if the player is for background music
     */
    property bool isBackgroundMusic: false
    
    /**
     * type:array
     * background music metadata
     */
    property var metaDataMusic: ["", "", "", ""]
    
    /**
     * Trigger this signal externally to play the next audio in the "files". This, in turn, stops the currently playing audio and check the necessary
     * conditions (see onStopped signal in "audio" element) and decides what needs to be done for the next audio.
     */
    signal nextAudio()
    onNextAudio: stop()

    /**
     * type:var
     * Current playback state.
     *
     * Possible values taken from Audio.status
     */
    property var playbackState: (audio.error === MediaPlayer.NoError) ?
                                    audio.playbackState : MediaPlayer.StoppedState;

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

    //Pauses the currently playing audio
    function pause() {
        if(playbackState === MediaPlayer.PlayingState)
            audio.pause()
    }

    //Resumes the current audio if it had been paused
    function resume() {
        if(playbackState === MediaPlayer.PausedState || playbackState === MediaPlayer.StoppedState)
            audio.play()
    }

    // Helper to know if there is already an audio playing
    function isPlaying() {
        return playbackState === MediaPlayer.PlayingState;
    }
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
        if(audio.playbackState != MediaPlayer.StoppedState)
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

        if(audio.playbackState !== MediaPlayer.PlayingState
           || audio.status === MediaPlayer.EndOfMedia
           || audio.status === MediaPlayer.NoMedia
           || audio.status === MediaPlayer.InvalidMedia) {
            files.push(file)
            silenceTimer.interval = 35
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
        if(files.length == 0) {
            gcaudio.done()
            return
        }

        var nextFile = files.shift()
        if(nextFile === '') {
            source = ""
            gcaudio.done()
        } else {
            // on Ubuntu Touch, emptying the source result in an Audio error which triggers that method again endlessly
            if (ApplicationInfo.platform !== ApplicationInfo.UbuntuTouchOS) {
               source = ""
            }
            source = nextFile
            if(!muted)
                audio.play()
        }
    }

    MediaPlayer {
        id: audio
        property alias volume: audioOutputItem.volume
        audioOutput: AudioOutput {
            id: audioOutputItem
        }

        // Workaround for https://bugreports.qt.io/browse/QTBUG-126592
        // Affects at least Qt 6.6.2, 6.6.3, 6.7.1, 6.7.2
        // Test next versions with letter P (U0070.ogg) in en_US to see when it's fixed
        onPositionChanged: {
            if(audio.position === audio.duration)
                audio.stop()
        }

        onErrorOccurred: (error, errorString) => {
            // This file cannot be played, remove it from the source asap
            source = ""
            if(files.length) {
                silenceTimer.start()
            }
            else {
                gcaudio.error()
            }
        }
        onPlaybackStateChanged: {
            if(playbackState !== MediaPlayer.StoppedState) {
                return;
            }
            if(files.length) {
                silenceTimer.start()
            }
            else {
                gcaudio.done()
            }
        }
        /**
        * Best effort to get the metadata from the audio track
        * audio.audioTracks[audio.activeAudioTrack] seems to work on Linux
        * audio.metaData seems to work on Windows
        */
        function getMetadata(metadataKey) {
            var value = audio.audioTracks[audio.activeAudioTrack].stringValue(metadataKey);
            if(value === "") {
                value = audio.metaData.stringValue(metadataKey);
            }
            return value;
        }
        onMetaDataChanged: {
            if(isBackgroundMusic && audio.activeAudioTrack != -1) {
                var title = getMetadata(MediaMetaData.Title);
                var contributingArtist = getMetadata(MediaMetaData.ContributingArtist);
                var copyright = getMetadata(MediaMetaData.Copyright);
                var metaDate = getMetadata(MediaMetaData.Date);
                var dateYear = ""
                if(metaDate != undefined && metaDate != "") {
                    dateYear = Qt.formatDate(metaDate, "yyyy")
                }
                metaDataMusic = [title, contributingArtist, dateYear, copyright]
            }
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
