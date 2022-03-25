/* GCompris - Diaper.qml
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

Monster {
    id: diaper

    monsterType: "diaper"
    frames: 3

    onMovingOnChanged: {
        if (movingOn == false && opacity == 1) {
            if (Math.random() > 0.5) {
                direction = Math.floor(Math.random()*4)
            }
            modelCells.regenCell(index)
        }
    }
}
