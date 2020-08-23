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
    objective: qsTr(" Practice algebraic calculations with a single operator.")
    difficulty: 3

    data: [
        {
            "dataItems": [
                [
                    [['+','-'],[  [[1,2,4,5],5] , [[1,2,4,6],5] ,[[3,4,5,7],2] ,[[8,7,9,7],6] ,[[9,4,6,7],7] ,[[3,4,5,7],6] ,[[6,4,5,7],5]  ]],
                    [['+','*'],[  [[1,2,4,6],12] , [[1,2,4,7],9] ,[[3,4,5,8],35] ,[[2,7,9,3],23] ,[[1,4,6,5],30] ,[[2,4,5,6],13] ,[[3,6,5,3],23]  ]],
                    [['+','/'],[  [[1,2,4,2],6] , [[1,2,4,1],6] ,[[3,6,5,5],7] ,[[9,3,3,4],3] ,[[1,4,2,2],2] ,[[5,10,15,7],13] ]],
                    [['-','*'],[  [[1,2,4,3],4] , [[1,2,4,9],2] ,[[3,4,5,1],8] ,[[8,7,9,3],9] ,[[9,4,6,2],30]  ]],
                    [['-','/'],[  [[1,2,4,7],2] , [[1,2,5,2],3] ,[[1,10,5,3],1] ,[[1,3,9,5],2] ,[[12,2,5,1],1]  ]],
                    [['*','/'],[  [[1,2,4,3],8] , [[1,2,4,2],2] ,[[3,3,6,2],6] ,[[15,5,4,6],18] ,[[14,7,3,0],6]  ]],
                ]
              ],
            "levelSchema": [3,3],
            "defaultOperators": [["+","-"],["/","*"]]
        }

    ]
}

