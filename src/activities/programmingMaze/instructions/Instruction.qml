/* GCompris - Instruction.qml
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

Item {
    id: instruction

    //stores the movement animation duration of Tux when an instruction is executed.
    property real movementAnimationDuration

    /**
     * This signal is emitted after the movement animation of Tux is complete.
     *
     * It will be caught by checkSuccess function in programmingMaze.qml.
     *
     * And it will check if Tux has reached the fish or will execute the next instruction.
     */
    signal executionComplete

    /**
     * This signal is emitted if Tux cannot move according to the current executed instruction.
     *
     * It will be caught by foundDeadEnd function in programmingMaze.qml.
     */
    signal foundDeadEnd

    Component.onCompleted: {
        foundDeadEnd.connect(Activity.items.background.foundDeadEnd)
        instruction.executionComplete.connect(Activity.items.background.checkSuccess)
    }
}
