/* GCompris - Balloon.qml
 *
 * SPDX-FileCopyrightText: 2014 Aruna Sankaranarayanan <arunasank@src.gnome.org>
 *
 * Authors:
 *   Aruna Sankaranarayanan <arunasank@src.gnome.org>
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> Improved Animation
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

/**
* A QML component to visualize countdown.
*
* Balloon usually consists of timeout duration (@ref duration)
* the timeout is called at the end of the down animation
*
* A balloon falls from top to bottom in a given duration on
* calling startMoving method and stops on calling stopMoving method.
*
* @inherit QtQuick.Image
*/
Image {
    id: balloon
    source: "qrc:/gcompris/src/core/resource/tuxballoon.svg";
    sourceSize.width: parent.width * 0.4
    x: parent.width * 0.5
    y: -balloon.height

    /**
     * type:int
     * Height of activity window.
     */
    property int parentHeight: parent.height

    /**
     * Emitted when balloon hits the ground i.e. on completion of time duration.
     */
    signal timeout

    /**
     * type:int
     * Total duration of the countdown.
     */
    property int duration

    property int swingDuration: Math.floor(duration / 10)

    /**
     * type:boolean
     * To know if the activity is running or not
     * Is set to false in stopBalloon, which should be called by activity's onStop
     * to avoid restarting the animation in onParentHeightChanged.
     */
    property bool activityRunning: true

    onHeightChanged: {
        if(activityRunning) {
            startMoving(duration)
        }
    }
    onParentHeightChanged: {
        if(activityRunning) {
            startMoving(duration)
        }
    }

    // Starts the countdown and down animation starts.
    function startMoving(durationIncoming)
    {
        duration = durationIncoming
        down.restart()
    }

    // Stops the countdown and the down animation stops.
    function stopMoving()
    {
        down.stop()
        reinit.restart()
    }

    // Completely stop the ballon when the activity stops.
    function stopBalloon()
    {
        activityRunning = false
        down.stop()
        reinit.stop()
    }

    ParallelAnimation {
        id: reinit
        running: false

        NumberAnimation {
            target: balloon
            property: "y"
            to: - balloon.height
            duration: 0
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: balloon
            property: "rotation"
            to: 0
            duration: 0
            easing.type: Easing.InOutQuad
        }
    }

    SequentialAnimation {
        id: down
        running: false
        ParallelAnimation {
            NumberAnimation {
                target: balloon
                property: "y"
                to: - balloon.height
                duration: 1000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: balloon
                property: "rotation"
                to: 0
                duration: 1000
                easing.type: Easing.InOutQuad
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: balloon
                property: "y"
                to: balloon.parentHeight - balloon.height - 50 * ApplicationInfo.ratio
                duration: balloon.duration
                easing.type: Easing.InOutQuad
            }
            SequentialAnimation {
                NumberAnimation {
                    target: balloon
                    property: "rotation"
                    to: -5
                    duration: balloon.swingDuration
                    easing.type: Easing.InOutQuad
                }
                SequentialAnimation {
                    loops: 1
                    NumberAnimation {
                        target: balloon
                        property: "rotation"
                        from: -5; to: 5
                        duration: balloon.swingDuration * 2
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: balloon
                        property: "rotation"
                        from: 5; to: -5
                        duration: balloon.swingDuration * 2
                        easing.type: Easing.InOutQuad
                    }
                }
                NumberAnimation {
                    target: balloon
                    property: "rotation"
                    to: 0
                    duration: balloon.swingDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }
        ScriptAction { script: balloon.timeout(); }
    }
}
