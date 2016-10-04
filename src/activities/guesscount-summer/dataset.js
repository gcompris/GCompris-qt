/* GCompris - dataset.js
 *
 * Copyright (C) 2016 Rahul Yadav <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
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

// questions according to operators

var dataset=[
            [
                [['+'],[  [[1,2],3] , [[3,4],7] ,[[6,2],8] ,[[5,2],7] ,[[9,2],11] ,[[4,2],6],[[1,6],7] ,[[3,2],5] ,[[13,1],14] ,[[5,8],13]  ]],
                [['-'],[  [[2,1],1] , [[3,1],2] ,[[7,2],5] ,[[6,2],4] ,[[9,2],7] ,[[8,5],3],[[9,5],4],[[18,9],3],[[5,1],4],[[6,3],3],[[5,4],1] ]],
                [['*'],[  [[2,1],2] , [[3,1],3] ,[[7,2],14] ,[[6,2],12] ,[[9,2],18] ,[[8,5],40],[[9,5],45],[[1,9],9],[[5,1],5],[[6,3],18],[[5,4],20] ]],
                [['/'],[  [[2,1],2] , [[3,1],3] ,[[8,2],4] ,[[6,2],3] ,[[9,3],3] ,[[8,4 ],2],[[9,3],3],[[18,9],2]    ]]
            ],

            [
                [['+','-'],[  [[1,2,4],1] , [[1,2,4],5] ,[[3,4,5],2] ,[[8,7,9],6] ,[[9,4,6],7] ,[[3,4,5],6] ,[[6,4,5],5]  ]],
                [['+','*'],[  [[1,2,4],12] , [[1,2,4],9] ,[[3,4,5],35] ,[[2,7,9],23] ,[[1,4,6],30] ,[[2,4,5],13] ,[[3,6,5],23]  ]],
                [['+','/'],[  [[1,2,4],6] , [[1,2,4],6] ,[[3,6,5],7] ,[[9,3,3],3] ,[[1,4,2],2] ,[[5,10,15],13] ]],
                [['-','*'],[  [[1,2,4],4] , [[1,2,4],2] ,[[3,4,5],8] ,[[8,7,9],9] ,[[9,4,6],30]  ]],
                [['-','/'],[  [[1,2,4],2] , [[1,2,5],3] ,[[1,10,5],1] ,[[1,3,9],2] ,[[12,2,5],1]  ]],
                [['*','/'],[  [[1,2,4],8] , [[1,2,4],2] ,[[3,3,6],9] ,[[15,5,4],20] ,[[14,7,3],21]  ]],
            ],

            [
                [['+','-','*'],[  [[1,4,3,5],10] , [[1,3,3,5],5] ,[[5,4,3,5],30] ,[[1,2,6,5],25]  ]],
                [['-','*','/'],[  [[1,4,3,3],3] ,[[3,4,3,3],1] ,[[7,4,2,1],6] ,[[8,4,2,4],2] ,[[9,4,5,3],3]  ]],
                [['*','/','+'],[  [[1,8,4,3],5] , [[10,8,9,3],5] ,[[9,1,3,3],6] ,[[5,8,4,3],13] ]],
                [['/','+','-'],[  [[2,8,2,3],3] , [[10,2,9,3],11] ,[[9,3,3,2],4] ,[[5,5,4,3],6] ]]
            ],

            [
                [['+','-','*','/'],[  [[1,7,2,3,2],13] ,[[8,1,5,2,3],6] ,[[1,7,2,4,2],5] ,[[9,7,8,2,4],4]]]
            ]

        ]

// no of Question at each level

var levelSchema = [4,4,4,4,3,3]

var defaultOperators=[["+"],["-"],["/"],["*"],["+","-"],["/","*"]]
