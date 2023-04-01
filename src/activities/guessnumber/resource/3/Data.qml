/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Sambhav Kaul <sambhav.kaul12@gmail.com>
 *
 * Authors:
 *   Sambhav Kaul <sambhav.kaul12@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core

Data {
    objective: qsTr("Guess a number between 1 and %1.").arg(Core.convertNumberToLocaleString(Number(1000)))
    difficulty: 3
    data: [
        {
            // first number is the minimum number and second is the maximum number
            "objective" : qsTr("Guess a number between 1 and %1.").arg(10),
            "maxNumber" : 10
        },
        {
            "objective" : qsTr("Guess a number between 1 and %1.").arg(100),
            "maxNumber" : 100
        },
        {
            "objective" : qsTr("Guess a number between 1 and %1.").arg(Core.convertNumberToLocaleString(Number(1000))),
            "maxNumber" : 1000
        }
    ]
}
