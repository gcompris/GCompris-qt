/* GCompris - vertical_subtraction_compensation - Data.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 */
import core 1.0

Data {
    objective: qsTr("Write your own subtraction and solve it.")
    difficulty: 1
    data: [
        {   "title": objective,
            "nbSubLevel": 10,
            "nbDigits": 4,
            "nbLines": 4,
            "alreadyLaid": false,
            "withCarry": true,
            "doItYourself": true
        }
    ]
}
