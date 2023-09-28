/* GCompris - Procedure.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Author:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../programmingMaze.js" as Activity

Instruction {
    id: callProcedure

    property alias procedureCode: procedureCode

    //Stores the list of instructions to be executed in procedure code area
    ListModel {
        id: procedureCode
    }

    function checkAndExecuteMovement() {
        if(!Activity.deadEndPoint && parent.items.procedureCodeArea.procedureIterator < callProcedure.procedureCode.count - 1) {
            parent.items.procedureCodeArea.procedureIterator++
            var currentInstruction = procedureCode.get(parent.items.procedureCodeArea.procedureIterator).name
            Activity.procedureInstructionObjects[currentInstruction].checkAndExecuteMovement()
        }
        else {
            parent.items.procedureCodeArea.procedureIterator = -1
            executionComplete()
        }
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
            checkAndExecuteMovement()
        }
    }
}
