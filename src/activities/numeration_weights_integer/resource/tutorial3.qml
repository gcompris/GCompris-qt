/* GCompris - tutorial3.qml
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
    //unit weight = 3, ten weight = 4, hunderd weight = 5 etc...    //whange cariable in tutorial2.qml  //?
    property int dragButtonIndex
    property int weightIndex




    Component.onCompleted: {
        console.log("tutorial2_screen_loaded")
        animationSequenceIndex = 0
        numberClassIndex = 1
        numberColumnWeightIndex = 2
        dragButtonIndex = 3
        numberWeightsParallelAnimation.running = true
        weightIndex = 0
    }


    ParallelAnimation {
        id: numberWeightsParallelAnimation

        NumberAnimation {
            id: animUnitColumnWeightX

            target: numberWeightDragElements.itemAt(dragButtonIndex)
            property: "x";
            to: numberClassDropAreaRepeater.itemAt(numberClassIndex).numberWeightsDropAreasRepeater.itemAt(numberColumnWeightIndex).numberWeightsDropTiles.numberWeightDropAreaGridRepeater.itemAt(weightIndex).mapToItem(activity, 0, 0).x
            duration: 3000
        }

        NumberAnimation {
            id: animUnitColumnWeightY

            target: numberWeightDragElements.itemAt(dragButtonIndex)
            property: "y";
            to: numberClassDropAreaRepeater.itemAt(numberClassIndex).numberWeightsDropAreasRepeater.itemAt(numberColumnWeightIndex).numberWeightsDropTiles.numberWeightDropAreaGridRepeater.itemAt(weightIndex).mapToItem(activity, 0, 0).y
            duration: 3000
        }

        onStarted: {
            weightColumnDragButtonOrigX = numberWeightDragElements.itemAt(dragButtonIndex).x
            weightColumnDragButtonOrigY = numberWeightDragElements.itemAt(dragButtonIndex).y
            numberWeightDragElements.itemAt(dragButtonIndex).Drag.start()
            animationIsRunning = true
            numberWeightDragElements.itemAt(dragButtonIndex).animationIsRunning = animationIsRunning
        }

        onFinished: {
            numberWeightDragElements.itemAt(dragButtonIndex).Drag.drop()
            numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
            numberWeightDragElements.itemAt(dragButtonIndex).z = 1000
            if (animationSequenceIndex === 0) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex = 1
                numberClassIndex = 1
                numberColumnWeightIndex = 2
                dragButtonIndex = 3
                weightIndex = 1
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 1) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex = 2
                numberClassIndex = 1
                numberColumnWeightIndex = 2
                dragButtonIndex = 3
                weightIndex = 2
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 2) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex = 3
                numberClassIndex = 1
                numberColumnWeightIndex = 2
                dragButtonIndex = 3
                weightIndex = 3
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 3) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex = 4
                numberClassIndex = 1
                numberColumnWeightIndex = 2
                dragButtonIndex = 3
                weightIndex = 3
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 4) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex = 5
                numberClassIndex = 0
                numberColumnWeightIndex = 0
                dragButtonIndex = 3
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 5) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
            }
        }
    }
}
