/* GCompris - vertical_subtraction - Data.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 */
import core 1.0

Data {
    objective: qsTr("Write and solve subtraction, 2 digits, 2 lines, without carry.")
    difficulty: 1
    data: [
        {   "title": objective,
            "nbSubLevel": 10,
            "nbDigits": 2,
            "nbLines": 2,
            "alreadyLaid": false,
            "withCarry": false
        }
    ]
}
