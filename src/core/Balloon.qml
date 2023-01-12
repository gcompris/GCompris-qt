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
import GCompris 1.0

/**
* A QML component to visualize countdown.
*
* Balloon usually consists of timeout duration (@ref duration)
* and a boolean to check if animation are running at a moment (@ref disabled).
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
    scale: 0.8
    x: parent.width / 2
    y: - balloon.height

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
     * Emitted when countdown is ready to start.
     */
    signal ready

    /**
     * type:int
     * Total duration of the countdown.
     */
    property int duration

    /**
     * type:boolean
     * To know if countdown is running at a moment.
     */
    property bool disabled

    /**
     * type:boolean
     * To know if the activity is running or not
     * Is set to false in stopBalloon, which should be called by activity's onStop
     * to avoid restarting the animation in onParentHeightChanged.
     */
    property bool activityRunning: true

    onParentHeightChanged: {
        if(activityRunning) {
            startMoving(duration)
        }
    }

    // Starts the countdown and down animation starts.
    function startMoving(durationIncoming)
    {
        stopMoving()
        disabled = false
        duration = durationIncoming
        down.restart()
    }

    // Stops the countdown and the down animation stops.
    function stopMoving()
    {
        disabled = true
        down.stop()
        reinit.start()
    }

    // Completely stop the ballon when the activity stops.
    function stopBalloon()
    {
        activityRunning = false
        disabled = true
        down.stop()
        reinit.stop()
    }

    ParallelAnimation {
        id: reinit
        running: false
        NumberAnimation {
            target: balloon
            property: "scale"
            to: 0.8
            duration: 1000
        }
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

    SequentialAnimation {
        id: down

        onRunningChanged: {
            if (!down.running && !balloon.disabled) {
                timeout()
            }
        }

        ParallelAnimation {

            NumberAnimation {
                target: balloon
                property: "scale"
                to: 0.8
                duration: 1000
            }
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
            running: false
            NumberAnimation {
                target: balloon
                property: "scale"
                to: 1
                duration: balloon.duration
            }
            NumberAnimation {
                target: balloon
                property: "y"
                to: parent.height - balloon.height
                duration: balloon.duration
                easing.type: Easing.InOutQuad
            }
            SequentialAnimation {
                NumberAnimation {
                    target: balloon
                    property: "rotation"
                    to: -5
                    duration: 3000
                    easing.type: Easing.InOutQuad
                }
                SequentialAnimation {
                    loops: 1
                    NumberAnimation {
                        target: balloon
                        property: "rotation"
                        from: -5; to: 5
                        duration: 3000
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: balloon
                        property: "rotation"
                        from: 5; to: -5
                        duration: 3000
                        easing.type: Easing.InOutQuad }
                }
                NumberAnimation {
                    target: balloon
                    property: "rotation"
                    to: 0
                    duration: 3000
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
