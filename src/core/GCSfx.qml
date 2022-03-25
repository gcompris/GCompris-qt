/* GCompris - GCSfx.qml
 *
 * SPDX-FileCopyrightText: 2018 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com> (GCAudio base, 2014)
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtMultimedia 5.12
import GCompris 1.0

/**
 * A QML component for sfx playback.
 * @ingroup components
 *
 * Wrapper component around QtQuick's SoundEffect element, handling all sfx
 * playback in GCompris uniformly.
 *
 *
 * @inherit QtQuick.Item
 */
Item {
    id: gcsfx

    /**
     * type:bool
     * Whether sfx should be muted.
     */
    property alias muted: sfx.muted

    /**
     * type:real
     * Volume of the fx player.
     */
    property alias volume: sfx.volume

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
     * type:bool
     * Status of the fx player.
     */
    property alias playing: sfx.playing

    /**
     * Emitted when playback of sound has finished.
     */
    signal done

    /**
     * Plays back the sfx resource @p file.
     *
     * @param type:string file [optional] URL to an sfx source.
     * @returns @c true if playback has been started, @c false if file does not
     *          exist or sfx is muted
     */
    function play(file) {
        if(file) {
            source = file
        }
        if(!muted) {
            sfx.play()
        }
    }

    /**
     * Stops sfx playback.
     */
    function stop() {
        if(sfx.playing)
            sfx.stop()
    }

    /// @cond INTERNAL_DOCS

    SoundEffect {
        id: sfx
        onPlayingChanged: {
            if(!playing){
                gcsfx.done();
            }
        }
    }

    /// @endcond

}
