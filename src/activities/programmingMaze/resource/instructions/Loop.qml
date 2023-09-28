/* GCompris - Loop.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../programmingMaze.js" as Activity

Instruction {
    id: executeLoopBody

    // Counter is set to the number of loops entered by the user.
    property int counter: Activity.loopsNumber
    property alias loopCode: loopCode

    //Stores the list of instructions to be executed in loop code area.
    ListModel {
        id: loopCode
    }

    function checkAndExecuteMovement() {
        if(parent.items.procedureModel.count === 0) {
            executionComplete()
            return;
        }

        parent.items.procedureCodeArea.procedureIterator++
        var currentInstruction = loopCode.get(parent.items.procedureCodeArea.procedureIterator).name
        Activity.loopInstructionObjects[currentInstruction].checkAndExecuteMovement()
    }

    function deadEnd() {
        foundDeadEnd()
    }

    function checkSuccessAndExecuteNextInstruction() {
        var fishX = Activity.mazeBlocks[Activity.items.currentLevel].fish.x
        var fishY = Activity.mazeBlocks[Activity.items.currentLevel].fish.y

        var tuxX = Math.floor(Activity.items.player.playerCenterX / Activity.stepX)
        var tuxY = Math.floor(Activity.items.player.playerCenterY / Activity.stepY)

        if(tuxX === fishX && tuxY === fishY) {
            Activity.codeIterator = 0
            parent.items.bonus.good("tux")
        }
        else {
            if(parent.items.procedureCodeArea.procedureIterator + 1 > executeLoopBody.loopCode.count - 1) {
                if(executeLoopBody.counter !== -1) executeLoopBody.counter--
                parent.items.procedureCodeArea.procedureIterator = -1
            }

            if(executeLoopBody.counter === 0) {
                executeLoopBody.counter = Activity.loopsNumber
                executionComplete()
            }
            else {
                checkAndExecuteMovement()
            }
        }
    }
}
