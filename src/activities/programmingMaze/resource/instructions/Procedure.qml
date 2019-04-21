/* GCompris - Procedure.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Author:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
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
import QtQuick 2.6
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
        var fishX = Activity.mazeBlocks[Activity.currentLevel].fish.x
        var fishY = Activity.mazeBlocks[Activity.currentLevel].fish.y

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
