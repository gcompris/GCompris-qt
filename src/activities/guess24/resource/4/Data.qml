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
    objective: qsTr("Solvable with all operators.")
    difficulty: 4
    data: [
        {
            "count": 20,
            "complexities": [ 2, 3 ],
            "operatorsCount": 4
        }
    ]
}
