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
    objective: qsTr("Practice algebraic calculations with three operators.")
    difficulty: 5

    data: [
        {
            "dataItems": [ [
                    [['+','-','*'],[  [[1,4,3,5],10] , [[1,3,3,5],5] ,[[5,4,3,5],30] ,[[1,2,6,5],25]  ]],
                    [['-','*','/'],[  [[1,4,3,3],3] ,[[3,4,3,3],1] ,[[7,4,2,1],6] ,[[8,4,2,4],2] ,[[9,4,5,3],3]  ]],
                    [['*','/','+'],[  [[1,8,4,3],5] , [[10,8,9,3],5] ,[[9,1,3,3],6] ,[[5,8,4,3],13] ]],
                    [['/','+','-'],[  [[2,8,2,3],3] , [[10,2,9,3],11] ,[[9,3,3,2],4] ,[[5,5,4,3],6] ]]
            ] ],
            "levelSchema": [3,3,3,3],
            "defaultOperators": [['+','-','*'],['-','*','/'],['*','/','+'],['/','+','-']]
        }

    ]
}
