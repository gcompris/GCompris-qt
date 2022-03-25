/* GCompris - Eater.qml
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
    id: eater

    monsterType: "eater"
    frames: 3

    onMovingOnChanged: {
        if (movingOn == false) {
            if (Math.random() > 0.666) {
                modelCells.get(index).show = false
                gridPart.isLevelDone()
            }
        }
    }
}
