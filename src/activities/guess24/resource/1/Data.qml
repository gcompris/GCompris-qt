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

/*
format of the dataset:
outermost array contains four arrays according to number of operator used in the Questions array.
Question array  = [[operators used],[Questions]]
Question  = [[operands],result]
*/
Data {
    objective: qsTr("Practice algebraic calculations with a single operator.")
    difficulty: 3

    data: [
        {
            "dataItems":[
                [

                    [['+'],[  [[1,2,4],3] , [[3,4,5],7] ,[[6,2,7],8] ,[[5,2,4],7] ,[[9,2,4],11] ,[[4,6,2],6],[[1,6,5],7] ,[[3,2,4],5] ,[[13,1,4],14] ,[[5,8,9],13]  ]],
                    [['-'],[  [[2,1,3],1] , [[3,1,0],2] ,[[7,2,3],5] ,[[6,2,2],4] ,[[9,2,4],7] ,[[8,5,5],3],[[9,5,3],4],[[18,9,8],9],[[5,1,2],4],[[6,3,7],3],[[5,4,1],1] ]],
                    [['*'],[  [[2,1,3],2] , [[3,1,4],3] ,[[7,2,5],14] ,[[6,2,1],12] ,[[9,2,3],18] ,[[8,5,5],40],[[9,5,6],45],[[1,9,2],9],[[5,1,4],5] ]],
                    [['/'],[  [[2,1,3],2] , [[3,1,2],3] ,[[8,2,1],4] ,[[6,2,7],3] ,[[9,3,2],3] ,[[6,4,2 ],2],[[9,3,4],3],[[18,9,3],2] ]]
                ]
            ],
            "levelSchema": [4,4,3,3],
            "defaultOperators": [["+"],["-"],["/"],["*"]]
        }
    ]
}
