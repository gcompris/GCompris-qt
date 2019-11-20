/* GCompris - tutorial1.qml
 *
 * Copyright (C) 2018 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
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
import QtQuick 2.13
import GCompris 1.0 

import "../../../core"
import "../../../activities"

Rectangle {
    id: tutorial1

    property bool animationIsRunning: animationIsRunning

    Component.onCompleted: {
        console.log("tutorial1_screen_loaded")
        myAnim.running = true
        myAnimY.running = true
    }

    anchors.fill: parent
    color: "#80FFFFFF"


    Rectangle {
        id: myRect
        width: 100; height: 100
        color: "red"
        z: 1000
        y: -200


        NumberAnimation{
            id: myAnim

            target: numberClassDragElements.itemAt(0)
            property: "x";
            to: background.width - background.width/5
            duration: 3000
            onStarted: {
                  animationIsRunning = true
                  numberClassDragElements.itemAt(0).animationIsRunning = animationIsRunning
                  console.log("onStarted")
            }
            onFinished: {
                  numberClassDragElements.itemAt(0).Drag.drop()
                  console.log("Sent Drag drop")
                  animationIsRunning = false
            }
        }

        NumberAnimation{
            id: myAnimY

            target: numberClassDragElements.itemAt(0)
            property: "y";
            to: background.height / 5
            duration: 3000
        }

    }
}
