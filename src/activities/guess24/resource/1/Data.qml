/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Solvable with + and -.")
    difficulty: 4
    data: [
        {
            "count": 10,
            "complexities": [ 1 ],
            "operatorsCount": 2
        }
    ]
}
