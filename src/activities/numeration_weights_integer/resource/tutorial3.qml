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
    property int dragButtonIndex
    property int weightRowIndex

    readonly property int unit_CLASS_INDEX: 1
    readonly property int thousand_CLASS_INDEX: 0

    readonly property int unit_COLUMN_INDEX: 2
    readonly property int tenth_COLUMN_INDEX: 1
    readonly property int hundred_COLUMN_INDEX: 0


    readonly property int unit_WEIGHT_BUTTON_INDEX: 3
    readonly property int ten_WEIGHT_BUTTON_INDEX: 4
    readonly property int hundred_WEIGHT_BUTTON_INDEX: 5
    readonly property int thousand_WEIGHT_BUTTON_INDEX: 6

    readonly property int animation_DURATION: 1000


    Component.onCompleted: {
        console.log("tutorial3_screen_loaded")
        animationSequenceIndex = 0
        numberClassIndex = 1
        numberColumnWeightIndex = 2
        dragButtonIndex = unit_WEIGHT_BUTTON_INDEX
        numberWeightsParallelAnimation.running = true
        weightRowIndex = 0
    }


    ParallelAnimation {
        id: numberWeightsParallelAnimation

        NumberAnimation {
            id: animUnitColumnWeightX

            target: numberWeightDragElements.itemAt(dragButtonIndex)
            property: "x";
            to: numberClassDropAreaRepeater.itemAt(numberClassIndex).numberWeightsDropAreasRepeater.itemAt(numberColumnWeightIndex).numberWeightsDropTiles.numberWeightDropAreaGridRepeater.itemAt(weightRowIndex).mapToItem(activity, 0, 0).x
            duration: animation_DURATION
        }

        NumberAnimation {
            id: animUnitColumnWeightY

            target: numberWeightDragElements.itemAt(dragButtonIndex)
            property: "y";
            to: numberClassDropAreaRepeater.itemAt(numberClassIndex).numberWeightsDropAreasRepeater.itemAt(numberColumnWeightIndex).numberWeightsDropTiles.numberWeightDropAreaGridRepeater.itemAt(weightRowIndex).mapToItem(activity, 0, 0).y
            duration: animation_DURATION
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
            numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX   //?
            numberWeightDragElements.itemAt(dragButtonIndex).z = 1000
            if (animationSequenceIndex === 0) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex++
                numberClassIndex = unit_CLASS_INDEX
                numberColumnWeightIndex = 2
                dragButtonIndex = unit_WEIGHT_BUTTON_INDEX
                weightRowIndex = 1
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 1) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex++
                numberClassIndex = unit_CLASS_INDEX
                numberColumnWeightIndex = unit_COLUMN_INDEX
                dragButtonIndex = unit_WEIGHT_BUTTON_INDEX
                weightRowIndex = 2
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 2) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex++
                numberClassIndex = unit_CLASS_INDEX
                numberColumnWeightIndex = unit_COLUMN_INDEX
                dragButtonIndex = unit_WEIGHT_BUTTON_INDEX
                weightRowIndex = 3
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 3) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex++
                numberClassIndex = unit_CLASS_INDEX
                numberColumnWeightIndex = hundred_COLUMN_INDEX
                dragButtonIndex = hundred_WEIGHT_BUTTON_INDEX
                weightRowIndex = 0
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 4) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex++
                numberClassIndex = unit_CLASS_INDEX
                numberColumnWeightIndex = hundred_COLUMN_INDEX
                dragButtonIndex = hundred_WEIGHT_BUTTON_INDEX
                weightRowIndex = 1
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 5) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
                animationSequenceIndex++
                numberClassIndex = thousand_CLASS_INDEX
                numberColumnWeightIndex = unit_COLUMN_INDEX
                dragButtonIndex = thousand_WEIGHT_BUTTON_INDEX
                numberWeightsParallelAnimation.running = true
            } else if (animationSequenceIndex === 6) {
                numberWeightDragElements.itemAt(dragButtonIndex).x = weightColumnDragButtonOrigX
                numberWeightDragElements.itemAt(dragButtonIndex).y = weightColumnDragButtonOrigY
            }
        }
    }
}
