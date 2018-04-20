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
    }

    /// @endcond

}
