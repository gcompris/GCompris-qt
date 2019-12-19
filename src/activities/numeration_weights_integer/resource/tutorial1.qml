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

Item {
    id: tutorial1

    property bool animationIsRunning: animationIsRunning
    property int numberClassDragButtonOrigX
    property int numberClassDragButtonOrigY
    property int numberClassDragButtonIndex
    property int animationSequenceIndex

    readonly property int animation_DURATION: 1000

    Component.onCompleted: {
        console.log("tutorial1_screen_loaded")
        numberClassParallelAnimation.running = true
        numberClassDragButtonIndex = 0
    }


    ParallelAnimation {
        id: numberClassParallelAnimation

        NumberAnimation {
            id: animUnitColumnWeightX

            target: numberClassDragElements.itemAt(numberClassDragButtonIndex)
            property: "x";
            to: background.width * (2-animationSequenceIndex)/3
            duration: animation_DURATION
        }

        NumberAnimation {
            id: animUnitColumnWeightY

            target: numberClassDragElements.itemAt(numberClassDragButtonIndex)
            property: "y";
            to: background.height * 1/3
            duration: animation_DURATION
        }

        onStarted: {
            numberClassDragButtonOrigX = numberClassDragElements.itemAt(numberClassDragButtonIndex).x
            numberClassDragButtonOrigY = numberClassDragElements.itemAt(numberClassDragButtonIndex).y
            numberClassDragElements.itemAt(numberClassDragButtonIndex).Drag.start()
            animationIsRunning = true
            numberClassDragElements.itemAt(numberClassDragButtonIndex).animationIsRunning = animationIsRunning
        }

        onFinished: {
            numberClassDragElements.itemAt(numberClassDragButtonIndex).Drag.drop()
            numberClassDragElements.itemAt(numberClassDragButtonIndex).z = 1000
            if (animationSequenceIndex === 0) {
                numberClassDragElements.itemAt(numberClassDragButtonIndex).x = numberClassDragButtonOrigX
                numberClassDragElements.itemAt(numberClassDragButtonIndex).y = numberClassDragButtonOrigY
                animationSequenceIndex++
                numberClassDragButtonIndex = 1
                numberClassParallelAnimation.running = true
            } else if (animationSequenceIndex === 1) {
                numberClassDragElements.itemAt(numberClassDragButtonIndex).x = numberClassDragButtonOrigX
                numberClassDragElements.itemAt(numberClassDragButtonIndex).y = numberClassDragButtonOrigY
            }
        }
    }
}
