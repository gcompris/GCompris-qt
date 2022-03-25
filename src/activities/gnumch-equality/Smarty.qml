/* GCompris - Smarty.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

// Smarty is smart enough to follow the muncher. So he will go after him.
Monster {
    id: smarty

    frames: 3

    function goAfterMuncher() {
        // Number of cells between muncher and smarty.
        var horizontalCells = muncher.index % 6 - index % 6
        var verticalCells = ((muncher.index - muncher.index % 6) / 6) - ((index - index % 6) / 6)

        if (horizontalCells == 0 && verticalCells == 0)
            return

        if ( Math.abs(horizontalCells) >= Math.abs(verticalCells)) {
            direction = 0.5 - (horizontalCells / Math.abs(horizontalCells))/2
        } else {
            direction = 2.5 - (verticalCells / Math.abs(verticalCells))/2
        }
    }

    monsterType: "smarty"

    onMovingOnChanged: {
        if (movingOn == false) {
            goAfterMuncher()
        }
    }
}
