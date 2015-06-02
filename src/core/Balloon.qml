/* GCompris - Balloon.qml
 *
 * Copyright (C) 2014 Aruna Sankaranarayanan and Bruno Coudoin
 *
 * Authors:
 *   Aruna Sankaranarayanan <arunasank@src.gnome.org>
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> Improved Animation
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

import QtQuick 2.1
import GCompris 1.0

Image {
    id: balloon
    source: "qrc:/gcompris/src/core/resource/tuxballoon.svgz";
    sourceSize.width: parent.width * 0.4
    scale: 0.8
    x: parent.width / 2
    y: - balloon.height
    property int parentHeight: parent.height
    signal timeout
    signal ready

    property int duration
    property bool disabled

    onParentHeightChanged: startMoving(duration)

    function startMoving(durationIncoming)
    {
        stopMoving()
        disabled = false
        duration = durationIncoming
        down.restart()
    }

    function stopMoving()
    {
        disabled = true
        reinit.start()
        down.stop()
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
