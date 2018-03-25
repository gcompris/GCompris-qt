/* GCompris - dataset.js
 *
 * Copyright (C) 2016 Rahul Yadav <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

// questions according to operators

/*
format of the dataset
outermost array contains four arrays according to number of operator used in the Questions array.

Question array  = [[operators used],[Questions]]

Question  = [[operands],result]

*/

var dataset = [
            [
                [['+'],[  [[1,2,4],3] , [[3,4,5],7] ,[[6,2,7],8] ,[[5,2,4],7] ,[[9,2,4],11] ,[[4,6,2],6],[[1,6],7] ,[[3,2],5] ,[[13,1],14] ,[[5,8],13]  ]],
                [['-'],[  [[2,1,3],1] , [[3,1,0],2] ,[[7,2,3],5] ,[[6,2,2],4] ,[[9,2,4],7] ,[[8,5,5],3],[[9,5,3],4],[[18,9,8],9],[[5,1,2],4],[[6,3,7],3],[[5,4,1],1] ]  ],
                [['*'],[  [[2,1,3],2] , [[3,1,4],3] ,[[7,2,5],14] ,[[6,2,1],12] ,[[9,2,3],18] ,[[8,5,5],40],[[9,5,6],45],[[1,9,2],9],[[5,1,4],5] ]],
                [['/'],[  [[2,1,4],2] , [[3,1,2],3] ,[[8,2,1],4] ,[[6,2,7],3] ,[[9,3,2],3] ,[[8,4,2 ],2],[[9,3,4],3],[[18,9,3],2]    ]]
            ],

            [
                [['+','-'],[  [[1,2,4,5],5] , [[1,2,4,6],5] ,[[3,4,5,7],2] ,[[8,7,9,7],6] ,[[9,4,6,7],7] ,[[3,4,5,7],6] ,[[6,4,5,7],5]  ]],
                [['+','*'],[  [[1,2,4,6],12] , [[1,2,4,7],9] ,[[3,4,5,8],35] ,[[2,7,9,3],23] ,[[1,4,6,5],30] ,[[2,4,5,6],13] ,[[3,6,5,3],23]  ]],
                [['+','/'],[  [[1,2,4,2],6] , [[1,2,4,1],6] ,[[3,6,5,5],7] ,[[9,3,3,4],3] ,[[1,4,2,2],2] ,[[5,10,15,7],13] ]],
                [['-','*'],[  [[1,2,4,3],4] , [[1,2,4,9],2] ,[[3,4,5,1],8] ,[[8,7,9,3],9] ,[[9,4,6,2],30]  ]],
                [['-','/'],[  [[1,2,4,7],2] , [[1,2,5,2],3] ,[[1,10,5,3],1] ,[[1,3,9,5],2] ,[[12,2,5,1],1]  ]],
                [['*','/'],[  [[1,2,4,3],8] , [[1,2,4,2],2] ,[[3,3,6,2],6] ,[[15,5,4,6],18] ,[[14,7,3,0],6]  ]],
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

// no of Question at each level ( total sublevels)

var levelSchema = [4,4,4,4,3,3,4,5]

// default operators at each level ( in case Built-in mode is activated )

var defaultOperators = [["+"],["-"],["/"],["*"],["+","-"],["/","*"],["/","*",'+'],['-',"*","+","/"]]
