/* GCompris - tutorial2.qml
 *
 * Copyright (C) 2019 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
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
    id: tutorial2

    property bool animationIsRunning: animationIsRunning
    property int weightColumnDragButtonOrigX
    property int weightColumnDragButtonOrigY
    property int animationSequenceIndex
    property int numberClassIndex
    property int numberColumnWeightIndex
    property int numberColumnWeightDragButtonIndex

    readonly property int animation_DURATION: 1000


    Component.onCompleted: {
        console.log("tutorial2_screen_loaded")
        animationSequenceIndex = 0
        numberClassIndex = 0
        numberColumnWeightIndex = 2
        numberColumnWeightDragButtonIndex = 0
        numberWeightsParallelAnimation.running = true
    }


    ParallelAnimation {
        id: numberWeightsParallelAnimation

        NumberAnimation {
            id: animUnitColumnWeightX

            target: numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex)
            property: "x";
            to: numberClassDropAreaRepeater.itemAt(numberClassIndex).numberWeightsDropAreasRepeater.itemAt(numberColumnWeightIndex).mapToItem(activity, 0, 0).x
            duration: animation_DURATION
        }

        NumberAnimation {
            id: animUnitColumnWeightY

            target: numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex)
            property: "y";
            to: numberClassDropAreaRepeater.itemAt(numberClassIndex).numberWeightsDropAreasRepeater.itemAt(numberColumnWeightIndex).numberWeightHeaderElement.mapToItem(activity, 0, 0).y
            //to: numberClassDropAreaRepeater.itemAt(numberClassIndex).numberWeightsDropAreasRepeater.itemAt(numberColumnWeightIndex).numberWeightsDropTiles.numberWeightDropAreaGridRepeater.itemAt(3).mapToItem(activity, 0, 0).y
            duration: animation_DURATION
        }

        onStarted: {
            weightColumnDragButtonOrigX = numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x
            weightColumnDragButtonOrigY = numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).y
            numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).Drag.start()
            animationIsRunning = true
            numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).animationIsRunning = animationIsRunning
        }

        onFinished: {
            numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).Drag.drop()
            numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = weightColumnDragButtonOrigX
            numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).z = 1000
            if (animationSequenceIndex === 0) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex = 1
                numberClassIndex = 0
                numberColumnWeightIndex = 1
                numberColumnWeightDragButtonIndex = 1
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 1) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex = 2
                numberClassIndex = 0
                numberColumnWeightIndex = 0
                numberColumnWeightDragButtonIndex = 2
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 2) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex = 3
                numberClassIndex = 1
                numberColumnWeightIndex = 2
                numberColumnWeightDragButtonIndex = 0
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 3) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex = 4
                numberClassIndex = 1
                numberColumnWeightIndex = 1
                numberColumnWeightDragButtonIndex = 1
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 4) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex = 5
                numberClassIndex = 1
                numberColumnWeightIndex = 0
                numberColumnWeightDragButtonIndex = 2
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 5) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).y = weightColumnDragButtonOrigY
            }
        }
    }
}
