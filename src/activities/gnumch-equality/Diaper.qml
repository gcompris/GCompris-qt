/* GCompris - Diaper.qml
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

Monster {
    id: diaper

    monsterType: "diaper"
    frames: 3
    frameW: 54
    widthRatio: 0.81

    onMovingOnChanged: {
        if (movingOn == false && opacity == 1) {
            if (Math.random() > 0.5) {
                direction = Math.floor(Math.random()*4)
            }
            modelCells.regenCell(index)
        }
    }
}
