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

import "../programmingMaze.js" as Activity

Instruction {
    id: callProcedure

    property alias procedureCode: procedureCode
    property int procedureCodeIterator: 0

    //Stores the list of instructions to be executed in procedure code area
    ListModel {
        id: procedureCode
    }

    function checkAndExecuteMovement() {
        if(!Activity.deadEndPoint && callProcedure.procedureCodeIterator < callProcedure.procedureCode.count) {
            var currentInstruction = procedureCode.get(callProcedure.procedureCodeIterator).name
            callProcedure.procedureCodeIterator++
            parent.items.procedureCodeArea.currentIndex += 1
            Activity.procedureCode[currentInstruction].checkAndExecuteMovement()
        }
        else {
            callProcedure.procedureCodeIterator = 0
            parent.items.procedureCodeArea.currentIndex = -1
            executionComplete()
        }
    }

    function deadEnd() {
        foundDeadEnd()
    }

    function checkSuccessAndExecuteNextInstruction() {
        var currentLevelBlocksCoordinates = Activity.mazeBlocks[Activity.currentLevel][Activity.BLOCKS_DATA_INDEX]

        var fishX = Activity.mazeBlocks[Activity.currentLevel][Activity.BLOCKS_FISH_INDEX][0][0]
        var fishY = Activity.mazeBlocks[Activity.currentLevel][Activity.BLOCKS_FISH_INDEX][0][1]
        var tuxX = currentLevelBlocksCoordinates[Activity.tuxIceBlockNumber][0]
        var tuxY = currentLevelBlocksCoordinates[Activity.tuxIceBlockNumber][1]

        if(tuxX === fishX && tuxY === fishY) {
            Activity.codeIterator = 0
            parent.items.bonus.good("tux")
        }
        else if(Activity.codeIterator === Activity.mainFunctionCode.length - 1 && callProcedure.procedureCodeIterator == callProcedure.procedureCode.count) {
            deadEnd()
        }
        else {
            checkAndExecuteMovement()
        }
    }
}
