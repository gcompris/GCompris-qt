/* GCompris - Smarty.qml
*
* Copyright (C) 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
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
import QtQuick 2.6

// Smarty is smart enough to follow the muncher. So he will go after him.
Monster {
    id: smarty

    frames: 3
    frameW: 66
    widthRatio: 0.93

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
