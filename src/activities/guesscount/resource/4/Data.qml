/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
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
