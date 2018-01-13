/* GCompris - call-procedure.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Siddhesh Suthar <siddhesh.it@gmail.com>
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

    property alias procedureModel: procedureModel

    //Stores the list of instructions to be executed in procedure code area
    ListModel {
        id: procedureModel
    }

    function checkAndExecuteMovement() {
        Activity.runningProcedure = true
        //until all the instructions in the procedureModel are executed, each instruction will be processed and removed.
        if(procedureModel.count > 0) {
            var currentInstruction = procedureModel.get(0).name
            procedureModel.remove(0)

            //Look-up in instructionObjects[] look-up table in programmingMaze.js and call that instruction object's checkAndExecuteMovement()
            Activity.instructionObjects[currentInstruction].checkAndExecuteMovement()
        }
        else {
            Activity.codeIterator++
            Activity.runningProcedure = false
            executionComplete()
        }
    }
}
