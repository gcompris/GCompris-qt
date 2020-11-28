/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0

Data {
    objective: qsTr("Practice algebraic calculations with four operators.")
    difficulty: 6

    data: [
        {
            "dataItems": [
                [
                   [ ['+','-','*','/'],[  [[1,7,2,3,2],13] ,[[8,1,5,2,3],6] ,[[1,7,2,4,2],5] ,[[9,7,8,2,4],4]] ],
                   [ ['+','-','*','/'],[  [[48,2,4,7,3],10] ,[[18,10,5,2,1],4] ,[[6,3,2,4,1],5] ,[[5,1,4,2,9],9]] ],
                   [ ['+','-','*','/'],[  [[10,40,20,6,5],10] ,[[16,2,6,14,10],6] ,[[6,3,2,4,3],7] ,[[5,1,4,2,13],5]] ]

                ]
            ],
            "levelSchema": [3,3,3],
            "defaultOperators": [['+','-','*','/'],['+','-','*','/'],['+','-','*','/']]
        }

    ]
}
