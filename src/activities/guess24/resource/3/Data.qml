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
    objective: qsTr("Multiplication required.")
    difficulty: 4
    data: [
        {
            "count": 20,
            "complexities": [ 2 ],
            "operatorsCount": 3
        }
    ]
}
