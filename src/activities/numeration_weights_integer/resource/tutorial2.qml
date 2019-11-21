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
    id: tutorial2

    property bool animationIsRunning: animationIsRunning
    property int unitWeightColumnDragButtonOrigX
    property int unitWeightColumnDragButtonOrigY
    property int thousandClassDragButtonOrigX
    property int thousandClassDragButtonOrigY
    property int animationSequenceIndex: 0
    property int numberClassIndex: 1
    property int numberColumnWeightIndex: 2
    property int numberColumnWeightDragButtonIndex: 0
    property int headerOriginY


    Component.onCompleted: {
        console.log("tutorial2_screen_loaded")
        animUnitColumnWeightX.running = true
        animUnitColumnWeightY.running = true
        headerOriginY = numberClassDropAreaRepeater.itemAt(0).numberWeightsDropAreasRepeater.itemAt(0).mapToItem(activity, 0, 0).y
    }

    NumberAnimation {
        id: animUnitColumnWeightX


        target: numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex)
        property: "x";
        to: numberClassDropAreaRepeater.itemAt(numberClassIndex).numberWeightsDropAreasRepeater.itemAt(numberColumnWeightIndex).mapToItem(activity, 0, 0).x
        duration: 3000
        onStarted: {
            unitWeightColumnDragButtonOrigX = numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x
            unitWeightColumnDragButtonOrigY = numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).y
            animationIsRunning = true
            numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).animationIsRunning = animationIsRunning
        }
        onFinished: {
            numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).Drag.drop()
            animationIsRunning = false
            numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = unitWeightColumnDragButtonOrigX
            numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).z = 1000
            if (animationSequenceIndex === 0) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = unitWeightColumnDragButtonOrigX
                animationSequenceIndex = 1
                numberClassIndex = 1
                numberColumnWeightIndex = 1
                numberColumnWeightDragButtonIndex = 1
                animUnitColumnWeightX.running = true
                animUnitColumnWeightY.running = true
                animUnitColumnWeightX.start()
            } else if (animationSequenceIndex === 1) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = unitWeightColumnDragButtonOrigX
                animationSequenceIndex = 2
                numberClassIndex = 1
                numberColumnWeightIndex = 0
                numberColumnWeightDragButtonIndex = 2
                animUnitColumnWeightX.running = true
                animUnitColumnWeightY.running = true
                animUnitColumnWeightX.start()
                console.log("fail")
            } else if (animationSequenceIndex === 2) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = unitWeightColumnDragButtonOrigX
                animationSequenceIndex = 3
                numberClassIndex = 0
                numberColumnWeightIndex = 2
                numberColumnWeightDragButtonIndex = 0
                animUnitColumnWeightX.running = true
                animUnitColumnWeightY.running = true
                animUnitColumnWeightX.start()
            } else if (animationSequenceIndex === 3) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = unitWeightColumnDragButtonOrigX
                animationSequenceIndex = 4
                numberClassIndex = 0
                numberColumnWeightIndex = 1
                numberColumnWeightDragButtonIndex = 1
                animUnitColumnWeightX.running = true
                animUnitColumnWeightY.running = true
            } else if (animationSequenceIndex === 4) {
                numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).x = unitWeightColumnDragButtonOrigX
                animationSequenceIndex = 5
                numberClassIndex = 0
                numberColumnWeightIndex = 0
                numberColumnWeightDragButtonIndex = 2
                animUnitColumnWeightX.running = true
                animUnitColumnWeightY.running = true
            }
        }
    }

    NumberAnimation {
        id: animUnitColumnWeightY

        target: numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex)
        property: "y";
        //to: numberClassDropAreaRepeater.itemAt(numberClassIndex).numberWeightsDropAreasRepeater.itemAt(numberColumnWeightIndex).mapToItem(activity, 0, 0).y
        to : 33 //headerOriginY
        duration: 3000
        onFinished: {
            numberWeightDragElements.itemAt(numberColumnWeightDragButtonIndex).y = unitWeightColumnDragButtonOrigY
        }
    }




}
