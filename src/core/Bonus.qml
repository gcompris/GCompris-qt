/* GCompris - Bonus.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

// Requires the global property in the scope:
// property GCAudio audioEffects, audioVoices

/**
 * A QML component providing user feedback upon winning/loosing.
 * @ingroup components
 *
 * Usually triggered by an activity when a user has won/lost a level via the
 * @ref good / @ref bad methods. Bonus then provides visual and auditive
 * feedback to the user and emits the @ref win / @ref loose signals when
 * finished.
 *
 * Maintains a list of possible audio voice resources to be playebd back
 * upon winning/loosing events, and selects randomly from them when triggered.
 *
 * @inherit QtQuick.Image
 */
Image {
    id: bonus

    /**
     * type:string
     * Url of the audio resource to be used as winning sound.
     */
    property string winSound: url + "sounds/bonus.wav"

    /**
     * type:string
     * Url of the audio resource to be used as loosing sound.
     */
    property string looseSound

    /**
     * type:int
     * Interval in milliseconds after which the bonus will be played (default is 500ms)
     */
    property alias interval: timer.interval

    /**
     * Emitted when the bonus starts
     */
    signal start

    /**
     * Emitted when the bonus stops
     */
    signal stop

    /**
     * Emitted when the win event is over.
     *
     * After the animation has finished.
     */
    signal win

    /**
     * Emitted when the loose event is over.
     *
     * After the animation has finished.
     */
    signal loose

    /// @cond INTERNAL_DOCS
    property string url: "qrc:/gcompris/src/core/resource/"
    property bool isWin: false
    property var winVoices: [
        "voices-$CA/$LOCALE/misc/congratulation.$CA",
        "voices-$CA/$LOCALE/misc/great.$CA",
        "voices-$CA/$LOCALE/misc/good.$CA",
        "voices-$CA/$LOCALE/misc/awesome.$CA",
        "voices-$CA/$LOCALE/misc/fantastic.$CA",
        "voices-$CA/$LOCALE/misc/waytogo.$CA",
        "voices-$CA/$LOCALE/misc/super.$CA",
        "voices-$CA/$LOCALE/misc/perfect.$CA"
    ]
    property var looseVoices: [
        "voices-$CA/$LOCALE/misc/check_answer.$CA"
    ]
    /// @endcond

    /**
     * type:bool
     * True between the moment we have the win/lose signal emitted and the 
     * bonus image is no more displayed
     */
    property bool isPlaying: animation.running || timer.running
    visible: true
    opacity: 0
    anchors.fill: parent
    anchors.margins: 50 * ApplicationInfo.ratio
    fillMode: Image.PreserveAspectFit
    z: 1000
    sourceSize.width: parent.width * 0.5

    /**
     * Triggers win feedback.
     *
     * Tries to play back a voice resource for winning, if not found fall back
     * to the winSound.
     *
     * @param name Type of win image to show.
     * Possible values are "flower", "gnu", "lion", "note", "smiley", "tux"
     */
    function good(name) {
        source = url + "bonus/" + name + "_good.svg"
        isWin = true
        timer.start()
    }

    /**
     * Triggers loose feedback.
     *
     * Tries to play back a voice resource for loosing, if not found fall back
     * to the looseSound.
     *
     * @param name Type of win image to show.
     * Possible values are "flower", "gnu", "lion", "note", "smiley", "tux"
     */
    function bad(name) {
        source = url + "bonus/" + name + "_bad.svg"
        isWin = false;
        timer.start()
    }

    /**
     * Private: Triggers win feedback after the timer completion
     */
    function _good() {
        if(!audioVoices.play(
                    ApplicationInfo.getAudioFilePath(
                        winVoices[Math.floor(Math.random()*winVoices.length)])))
            if(winSound)
                audioEffects.play(winSound)

        start()
        animation.start()
    }

    /**
     * Private: Triggers loose feedback after the timer completion.
     */
    function _bad(name) {
        if(!audioVoices.play(
                    ApplicationInfo.getAudioFilePath(
                        looseVoices[Math.floor(Math.random()*looseVoices.length)])))
            if(looseSound)
                audioEffects.play(looseSound)
        start()
        animation.start()
    }

    SequentialAnimation {
        id: animation
        NumberAnimation {
            target: bonus
            property: "opacity"
            from: 0; to: 1.0
            duration: 1000
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: bonus
            property: "opacity"
            from: 1.0; to: 0
            duration: 500
            easing.type: Easing.InOutQuad
        }
        onStopped: {
            bonus.stop()
            isWin ? win() : loose()
        }
    }

    // It is useful to launch the bonus after a delay to let the children
    // appreciate the completed level
    Timer {
        id: timer
        interval: 500
        onTriggered: isWin ? bonus._good() : bonus._bad()
    }
}
