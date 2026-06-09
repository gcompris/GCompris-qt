/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Sambhav Kaul <sambhav.kaul12@gmail.com>
 *
 * Authors:
 *   Sambhav Kaul <sambhav.kaul12@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0
import "qrc:/gcompris/src/core/core.js" as Core

Data {
    objective: qsTr("Guess a number between %1 and %2.").arg(1).arg(Core.convertNumberToLocaleString(Number(100000)))
    difficulty: 4
    data: [
        {
            "minNumber" : 1,
            "maxNumber" : 5000
        },
        {
            "minNumber" : 1,
            "maxNumber" : 10000
        },
        {
            "minNumber" : 1,
            "maxNumber" : 50000
        },
        {
            "minNumber" : 1,
            "maxNumber" : 100000
        }
    ]
}
