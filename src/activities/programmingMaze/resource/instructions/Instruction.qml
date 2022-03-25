/* GCompris - Instruction.qml
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

Item {
    id: instruction

    //stores the movement animation duration of Tux when an instruction is executed.
    property real movementAnimationDuration

    /**
     * This signal is emitted after the execution of current instruction is complete.
     *
     * The signal will be caught by ProgrammingMaze.qml/Procedure.qml depending on with whom the connection is made,
     * and it will check if Tux has reached the fish(level is complete) or will execute the next instruction.
     */
    signal executionComplete

    /**
     * This signal is emitted if Tux cannot move according to the current executed instruction.
     *
     * It will be caught by deadEnd() in its parent file.
     */
    signal foundDeadEnd

//     function setCodeAreaHighlightMoveDuration() {
//         Activity.items.mainFunctionCodeArea.highlightMoveDuration = movementAnimationDuration
//         Activity.items.procedureCodeArea.highlightMoveDuration = movementAnimationDuration
//     }
}
