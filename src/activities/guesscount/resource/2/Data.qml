/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import core 1.0

Data {
    objective: qsTr("Practice algebraic calculations with two operators.")
    difficulty: 4

    data: [
        {
            "dataItems": [
                [
                    [['+','-'],[  [[1,2,4,5],5] , [[1,2,4,6],5] ,[[3,4,5,7],2] ,[[8,7,9,7],6] ,[[9,4,6,7],7] ,[[3,4,5,7],6] ,[[6,4,5,7],5]  ]],
                    [['+','*'],[  [[1,2,4,6],12] , [[1,2,4,7],9] ,[[3,4,5,8],35] ,[[2,7,9,3],23] ,[[1,4,6,5],30] ,[[2,4,5,6],13] ,[[3,6,5,3],23]  ]],
                    [['+','/'],[  [[1,2,4,2],6] , [[1,2,4,1],6] ,[[3,6,5,5],7] ,[[9,3,3,4],3] ,[[1,4,2,2],2] ,[[5,10,15,7],13] ]],
                    [['-','*'],[  [[1,2,4,3],4] , [[1,2,4,9],2] ,[[3,4,5,1],8] ,[[8,7,9,3],9] ,[[9,4,6,2],30]  ]],
                    [['-','/'],[  [[1,2,4,7],2] , [[1,2,5,2],3] ,[[1,10,5,3],1] ,[[1,3,9,5],2] ,[[12,2,5,1],1]  ]],
                    [['*','/'],[  [[1,2,4,3],8] , [[1,2,4,2],2] ,[[3,3,6,2],6] ,[[15,5,4,6],18] ,[[14,7,3,0],6]  ]]
               ],
         ],
            "levelSchema": [4,4,3,3,4,3],
            "defaultOperators": [['+','-'],['+','*'],['+','/'],['-','*'],['-','/'],['*','/']]
        }

    ]
}
