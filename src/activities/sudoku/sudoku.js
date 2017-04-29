/* gcompris - sudoku.js

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

.pragma library
.import QtQuick 2.6 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core


// Hard coded level definitions
var levels = [
            [ // Level 1
             [
                 ['.','C','B'],
                 ['.','B','A'],
                 ['.','A','C']
             ],
             [
                 ['C','A','B'],
                 ['.','.','.'],
                 ['B','C','A']
             ],
             [
                 ['C','A','B'],
                 ['A','B','C'],
                 ['.','.','.']
             ],
             [
                 ['A','.','C'],
                 ['C','.','B'],
                 ['B','.','A']
             ],
             [
                 ['A','.','C'],
                 ['B','C','.'],
                 ['.','A','B']
             ],
             [
                 ['A','B','C'],
                 ['B','.','A'],
                 ['.','A','.']
             ],
             [
                 ['.','B','A'],
                 ['B','.','C'],
                 ['A','C','.']
             ],        [
                 ['A','B','C'],
                 ['.','C','A'],
                 ['.','A','.']
             ],
            ],
            [ // Level 2
             [
                 ['A','.','.'],
                 ['D','.','.'],
                 ['C','A','.'],
             ],
             [
                 ['C','.','D'],
                 ['.','.','B'],
                 ['.','D','C'],
             ],
             [
                 ['.','B','D'],
                 ['D','.','.'],
                 ['B','.','C'],
             ],
             [
                 ['A','.','.'],
                 ['.','D','A'],
                 ['D','.','C'],
             ],
             [
                 ['C','.','D'],
                 ['.','C','.'],
                 ['B','.','C'],
             ],
            ],
            [ // Level 3
             [
                 ['.','A','.'],
                 ['A','C','.'],
                 ['.','B','.'],
             ],
             [
                 ['B','A','.'],
                 ['A','C','.'],
                 ['.','.','.'],
             ],
             [
                 ['.','A','C'],
                 ['.','.','B'],
                 ['C','.','.'],
             ],
             [
                 ['.','.','C'],
                 ['D','.','A'],
                 ['C','.','.'],
             ],
             [
                 ['.','.','C'],
                 ['D','.','A'],
                 ['.','A','.'],
             ],
            ],
            [ // Level 4
             [
                 ['.','B','C','D'],
                 ['D','C','.','A'],
                 ['.','D','A','B'],
                 ['B','A','.','C'],
             ],
             [
                 ['A','.','.','D'],
                 ['D','C','B','.'],
                 ['C','D','A','.'],
                 ['.','.','D','C'],
             ],
             [
                 ['.','B','.','.'],
                 ['.','C','B','A'],
                 ['C','D','A','.'],
                 ['.','.','D','.'],
             ],

             [
                 ['.','B','A','.'],
                 ['D','.','B','C'],
                 ['A','C','.','B'],
                 ['.','D','C','.']
             ],
             [
                 ['.','.','.','.'],
                 ['D','A','B','C'],
                 ['A','C','D','B'],
                 ['.','.','.','.']
             ],
            ],
            [ // Level 5
             [
                 ['.','.','.','.'],
                 ['D','A','B','.'],
                 ['C','.','A','B'],
                 ['.','.','.','D']
             ],
             [
                 ['A','B','C','D'],
                 ['.','.','.','.'],
                 ['.','.','.','.'],
                 ['B','C','D','A']
             ],
             [
                 ['.','.','A','D'],
                 ['D','.','.','C'],
                 ['A','.','.','B'],
                 ['B','D','.','.']
             ],
             [
                 ['.','.','A','.'],
                 ['D','A','B','.'],
                 ['.','C','D','B'],
                 ['.','D','.','.']
             ],
             [
                 ['C','B','.','D'],
                 ['.','.','.','C'],
                 ['A','.','.','.'],
                 ['B','.','C','A']
             ],
            ],
            [ // Level 6
             [
                 ['C','.','.','D'],
                 ['.','.','B','.'],
                 ['A','.','.','.'],
                 ['.','.','D','.']
             ],
             [
                 ['.','B','.','A'],
                 ['.','.','B','.'],
                 ['C','.','D','.'],
                 ['.','.','.','C']
             ],
             [
                 ['A','.','B','.'],
                 ['.','C','.','A'],
                 ['.','.','.','D'],
                 ['D','.','C','.']
             ],
             [
                 ['.','A','.','.'],
                 ['C','.','A','B'],
                 ['.','.','C','.'],
                 ['D','.','.','A']
             ],
             [
                 ['C','.','.','D'],
                 ['B','.','A','.'],
                 ['.','B','.','A'],
                 ['.','.','.','.']
             ],
             [
                 ['.','A','C','.'],
                 ['.','.','.','D'],
                 ['C','.','.','A'],
                 ['.','B','.','.']
             ],
             [
                 ['.','C','.','D'],
                 ['B','.','.','.'],
                 ['.','.','.','.'],
                 ['C','A','.','B']
             ],
             [
                 ['B','.','.','C'],
                 ['.','A','.','.'],
                 ['.','.','D','.'],
                 ['.','B','.','.']
             ],
            ],
            [ // Level 7
             [
                 ['A','B','C','D','E'],
                 ['.','A','B','C','D'],
                 ['.','.','A','B','C'],
                 ['.','.','.','A','B'],
                 ['.','.','.','.','A']
             ],
             [
                 ['A','B','.','D','.'],
                 ['.','.','D','E','A'],
                 ['C','.','.','A','.'],
                 ['D','E','.','.','C'],
                 ['.','A','B','.','D']
             ],
             [
                 ['.','C','.','A','.'],
                 ['A','.','B','.','C'],
                 ['.','B','.','C','.'],
                 ['D','.','C','.','A'],
                 ['.','A','E','.','B']
             ],
             [
                 ['C','B','.','.','D'],
                 ['.','.','D','C','.'],
                 ['D','.','B','.','E'],
                 ['.','A','.','D','C'],
                 ['E','.','.','B','.']
             ],
             [
                 ['D','.','.','B','E'],
                 ['.','E','A','.','.'],
                 ['A','C','.','.','B'],
                 ['.','.','B','C','.'],
                 ['C','B','.','A','.']
             ],
             [
                 ['.','.','C','D','.'],
                 ['B','.','.','.','C'],
                 ['.','C','.','B','D'],
                 ['C','.','D','A','.'],
                 ['D','E','.','.','A']
             ],
            ],
            [ // Level 8
             [
                 ['1','2','3','4','5'],
                 ['.','1','2','3','4'],
                 ['.','.','1','2','3'],
                 ['.','.','.','1','2'],
                 ['.','.','.','.','1']
             ],
             [
                 ['1','2','.','4','.'],
                 ['.','.','4','5','1'],
                 ['3','.','.','1','.'],
                 ['4','5','.','.','3'],
                 ['.','1','2','.','4']
             ],
             [
                 ['.','3','.','1','.'],
                 ['1','.','2','.','3'],
                 ['.','2','.','3','.'],
                 ['4','.','3','.','1'],
                 ['.','1','5','.','2']
             ],
             [
                 ['3','2','.','.','4'],
                 ['.','.','4','3','.'],
                 ['4','.','2','.','5'],
                 ['.','1','.','4','3'],
                 ['5','.','.','2','.']
             ],
             [
                 ['4','.','.','2','5'],
                 ['.','5','1','.','.'],
                 ['1','3','.','.','2'],
                 ['.','.','2','3','.'],
                 ['3','2','.','1','.']
             ],
             [
                 ['.','.','3','4','.'],
                 ['2','.','.','.','3'],
                 ['.','3','.','2','4'],
                 ['3','.','4','1','.'],
                 ['4','5','.','.','1']
             ],
            ],
            [ // Level 9
             [
                 ['8', '9', '3', '4', '5', '2', '6', '7', '1'],
                 ['7', '1', '6', '3', '9', '8', '5', '.', '2'],
                 ['2', '4', '5', '1', '7', '6', '9', '8', '3'],
                 ['5', '2', '1', '8', '4', '9', '3', '6', '7'],
                 ['9', '6', '.', '2', '3', '7', '1', '5', '8'],
                 ['3', '8', '7', '5', '6', '1', '4', '2', '9'],
                 ['4', '7', '.', '9', '1', '5', '8', '.', '6'],
                 ['6', '5', '9', '7', '8', '3', '2', '1', '4'],
                 ['1', '3', '8', '6', '.', '4', '.', '9', '5']
             ],
             [
                 ['7', '9', '4', '6', '3', '5', '8', '1', '2'],
                 ['8', '3', '2', '4', '9', '1', '5', '7', '6'],
                 ['6', '1', '5', '.', '8', '2', '4', '.', '3'],
                 ['5', '2', '8', '1', '7', '3', '6', '4', '9'],
                 ['4', '7', '3', '2', '6', '9', '1', '5', '8'],
                 ['9', '6', '1', '8', '5', '4', '3', '2', '7'],
                 ['3', '8', '9', '5', '1', '7', '2', '6', '4'],
                 ['2', '5', '6', '.', '4', '.', '7', '3', '1'],
                 ['1', '4', '7', '3', '2', '6', '9', '8', '5'],
             ],
             [
                 ['5', '6', '2', '1', '7', '9', '4', '3', '8'],
                 ['.', '3', '4', '8', '5', '6', '7', '1', '2'],
                 ['1', '8', '7', '4', '3', '2', '5', '9', '6'],
                 ['6', '9', '.', '7', '1', '5', '3', '2', '4'],
                 ['4', '1', '3', '9', '2', '8', '6', '.', '5'],
                 ['7', '2', '5', '3', '6', '4', '9', '8', '1'],
                 ['8', '5', '9', '2', '4', '3', '1', '6', '7'],
                 ['2', '7', '6', '5', '9', '1', '8', '4', '3'],
                 ['3', '4', '1', '.', '8', '7', '2', '5', '9'],
             ],
             [
                 ['2', '1', '6', '4', '7', '8', '9', '5', '3'],
                 ['4', '9', '7', '.', '5', '3', '2', '6', '8'],
                 ['5', '3', '8', '2', '6', '9', '4', '1', '7'],
                 ['8', '.', '4', '9', '3', '6', '1', '7', '5'],
                 ['6', '5', '.', '7', '4', '1', '8', '2', '9'],
                 ['1', '7', '9', '8', '2', '5', '3', '4', '6'],
                 ['3', '4', '1', '6', '9', '7', '5', '8', '2'],
                 ['7', '8', '5', '3', '1', '2', '6', '.', '4'],
                 ['9', '6', '2', '5', '8', '4', '7', '3', '1'],
             ]
            ],
            [ // Level 10
             [
                 ['3', '8', '4', '9', '5', '6', '2', '7', '1'],
                 ['9', '.', '6', '8', '7', '2', '5', '3', '4'],
                 ['2', '5', '7', '1', '4', '.', '6', '9', '8'],
                 ['8', '9', '3', '.', '.', '5', '1', '.', '7'],
                 ['7', '2', '1', '4', '3', '9', '8', '5', '6'],
                 ['6', '4', '5', '7', '1', '8', '9', '2', '.'],
                 ['1', '3', '9', '.', '8', '7', '.', '6', '2'],
                 ['4', '6', '2', '3', '9', '1', '7', '.', '5'],
                 ['5', '7', '8', '2', '6', '4', '.', '1', '.'],
             ],
             [
                 ['1', '2', '8', '4', '9', '3', '.', '6', '5'],
                 ['6', '.', '4', '5', '7', '8', '2', '9', '1'],
                 ['5', '7', '9', '2', '1', '6', '8', '4', '3'],
                 ['2', '6', '1', '3', '8', '5', '4', '7', '9'],
                 ['8', '5', '3', '.', '4', '9', '1', '2', '6'],
                 ['9', '.', '7', '6', '.', '1', '3', '5', '8'],
                 ['.', '.', '6', '1', '5', '.', '9', '3', '2'],
                 ['3', '9', '2', '8', '6', '7', '5', '1', '.'],
                 ['4', '1', '5', '9', '3', '2', '6', '.', '.'],
             ],
             [
                 ['.', '8', '.', '4', '9', '2', '5', '1', '6'],
                 ['5', '.', '.', '7', '1', '6', '8', '.', '3'],
                 ['.', '6', '1', '3', '5', '.', '2', '4', '7'],
                 ['1', '2', '6', '.', '3', '7', '4', '5', '9'],
                 ['.', '9', '5', '2', '6', '1', '3', '7', '8'],
                 ['8', '7', '3', '.', '4', '5', '6', '2', '1'],
                 ['.', '3', '9', '1', '2', '4', '7', '8', '5'],
                 ['7', '1', '4', '5', '8', '3', '9', '6', '2'],
                 ['2', '5', '8', '6', '7', '9', '1', '3', '4'],
             ],
             [
                 ['3', '7', '.', '4', '1', '.', '8', '5', '9'],
                 ['9', '5', '.', '8', '7', '3', '6', '.', '2'],
                 ['6', '1', '8', '2', '9', '5', '3', '4', '7'],
                 ['4', '3', '9', '1', '8', '.', '2', '6', '5'],
                 ['1', '2', '7', '5', '6', '4', '9', '8', '3'],
                 ['.', '8', '6', '3', '2', '9', '4', '7', '1'],
                 ['8', '9', '.', '7', '.', '2', '5', '3', '.'],
                 ['7', '6', '5', '9', '3', '8', '1', '2', '4'],
                 ['2', '4', '3', '6', '5', '.', '7', '9', '.'],
             ]
            ],
            [ // Level 11
             [
                 ['6', '1', '7', '5', '2', '9', '3', '.', '8'],
                 ['.', '4', '.', '.', '8', '6', '9', '2', '7'],
                 ['8', '9', '.', '.', '7', '4', '5', '6', '.'],
                 ['1', '8', '.', '.', '5', '7', '4', '.', '2'],
                 ['.', '2', '6', '9', '3', '1', '7', '.', '5'],
                 ['7', '.', '5', '2', '4', '8', '.', '1', '9'],
                 ['9', '7', '8', '4', '.', '2', '1', '5', '3'],
                 ['3', '.', '1', '8', '.', '.', '.', '7', '4'],
                 ['.', '5', '4', '7', '1', '3', '8', '.', '6'],
             ],
             [
                 ['8', '5', '2', '4', '3', '1', '9', '6', '7'],
                 ['1', '9', '6', '2', '.', '5', '4', '.', '8'],
                 ['.', '.', '.', '6', '8', '9', '5', '2', '1'],
                 ['2', '1', '5', '.', '6', '8', '.', '4', '9'],
                 ['7', '.', '.', '1', '2', '4', '3', '.', '.'],
                 ['6', '.', '3', '9', '5', '7', '1', '8', '.'],
                 ['.', '2', '1', '7', '4', '6', '8', '9', '3'],
                 ['.', '6', '.', '5', '1', '3', '2', '7', '4'],
                 ['3', '.', '4', '.', '.', '.', '6', '.', '5'],
             ],
             [
                 ['.', '3', '2', '8', '5', '1', '6', '.', '.'],
                 ['6', '8', '9', '3', '4', '2', '.', '7', '1'],
                 ['4', '1', '5', '.', '9', '7', '8', '2', '3'],
                 ['2', '4', '.', '.', '.', '9', '7', '3', '.'],
                 ['5', '.', '7', '2', '3', '.', '1', '6', '8'],
                 ['1', '6', '3', '7', '8', '5', '4', '9', '2'],
                 ['9', '7', '.', '4', '.', '8', '3', '5', '.'],
                 ['3', '2', '.', '.', '1', '6', '9', '.', '7'],
                 ['8', '.', '6', '.', '7', '3', '2', '.', '.'],
             ],
             [
                 ['9', '5', '8', '6', '4', '.', '1', '7', '2'],
                 ['2', '6', '4', '.', '5', '1', '.', '8', '3'],
                 ['1', '3', '7', '.', '8', '2', '4', '.', '6'],
                 ['3', '4', '9', '8', '2', '.', '6', '1', '7'],
                 ['6', '1', '2', '4', '9', '7', '8', '3', '.'],
                 ['.', '.', '.', '1', '3', '6', '2', '9', '4'],
                 ['5', '.', '1', '.', '.', '9', '7', '.', '8'],
                 ['7', '8', '6', '.', '.', '.', '3', '.', '9'],
                 ['4', '9', '3', '2', '.', '8', '5', '.', '.'],
             ]
            ],
            [ // Level 12
             [
                 ['.', '1', '7', '3', '.', '8', '.', '.', '2'],
                 ['2', '9', '8', '.', '1', '6', '3', '7', '.'],
                 ['3', '5', '.', '9', '7', '2', '.', '.', '4'],
                 ['6', '3', '9', '5', '4', '.', '7', '.', '8'],
                 ['.', '.', '4', '.', '.', '3', '5', '1', '9'],
                 ['1', '8', '.', '2', '9', '.', '4', '.', '.'],
                 ['5', '.', '3', '.', '.', '9', '2', '.', '7'],
                 ['.', '7', '.', '6', '3', '5', '9', '.', '.'],
                 ['.', '.', '1', '7', '2', '4', '.', '5', '.'],
             ],
             [
                 ['.', '5', '8', '6', '7', '.', '3', '9', '2'],
                 ['2', '.', '.', '4', '5', '.', '.', '7', '6'],
                 ['.', '.', '6', '.', '.', '.', '8', '5', '4'],
                 ['.', '8', '.', '7', '2', '6', '5', '4', '.'],
                 ['5', '.', '2', '9', '.', '4', '.', '3', '.'],
                 ['1', '7', '4', '5', '.', '3', '2', '6', '.'],
                 ['3', '.', '.', '8', '6', '.', '4', '1', '.'],
                 ['8', '9', '5', '.', '4', '.', '6', '.', '.'],
                 ['6', '4', '.', '.', '.', '5', '9', '8', '7'],
             ],
             [
                 ['4', '.', '5', '7', '3', '1', '9', '6', '2'],
                 ['3', '.', '6', '4', '.', '.', '.', '8', '.'],
                 ['9', '1', '7', '.', '.', '2', '4', '5', '3'],
                 ['.', '9', '8', '5', '2', '7', '.', '1', '.'],
                 ['.', '7', '.', '.', '.', '4', '.', '.', '8'],
                 ['.', '.', '1', '3', '6', '8', '.', '7', '.'],
                 ['.', '3', '2', '.', '.', '9', '7', '4', '.'],
                 ['7', '.', '.', '.', '.', '.', '2', '3', '1'],
                 ['1', '6', '.', '2', '7', '3', '8', '9', '5'],
             ],
             [
                 ['6', '5', '1', '8', '4', '7', '3', '.', '9'],
                 ['.', '4', '9', '.', '1', '5', '6', '.', '.'],
                 ['7', '.', '3', '.', '2', '9', '4', '.', '.'],
                 ['.', '2', '.', '7', '9', '6', '8', '4', '1'],
                 ['.', '9', '.', '4', '3', '.', '5', '.', '2'],
                 ['1', '6', '4', '.', '.', '2', '.', '.', '3'],
                 ['4', '1', '.', '9', '.', '.', '7', '5', '.'],
                 ['5', '3', '6', '.', '.', '.', '.', '9', '.'],
                 ['.', '7', '8', '1', '5', '.', '.', '3', '6'],
             ]
            ],
            [ // Level 13
             [
                 ['.', '2', '.', '1', '.', '5', '.', '.', '9'],
                 ['.', '.', '1', '4', '7', '6', '2', '8', '.'],
                 ['3', '7', '4', '.', '8', '2', '.', '.', '6'],
                 ['.', '6', '3', '.', '4', '1', '.', '9', '2'],
                 ['4', '5', '9', '.', '.', '.', '8', '.', '7'],
                 ['.', '.', '2', '7', '5', '.', '6', '3', '.'],
                 ['.', '4', '7', '.', '.', '8', '3', '.', '1'],
                 ['.', '3', '.', '6', '.', '4', '.', '2', '5'],
                 ['6', '.', '.', '3', '.', '.', '.', '.', '8'],
             ],
             [
                 ['4', '.', '5', '.', '2', '.', '7', '.', '1'],
                 ['.', '.', '.', '3', '4', '.', '5', '6', '8'],
                 ['6', '.', '.', '8', '5', '7', '2', '.', '.'],
                 ['.', '.', '4', '.', '.', '5', '.', '7', '.'],
                 ['.', '3', '.', '2', '.', '.', '8', '.', '.'],
                 ['5', '.', '.', '.', '.', '9', '.', '.', '2'],
                 ['.', '7', '1', '.', '.', '.', '4', '2', '.'],
                 ['2', '.', '6', '.', '9', '.', '3', '.', '.'],
                 ['3', '.', '9', '1', '.', '2', '6', '.', '.'],
             ],
             [
                 ['5', '7', '8', '.', '.', '3', '.', '9', '.'],
                 ['.', '6', '.', '4', '.', '9', '7', '.', '8'],
                 ['2', '4', '9', '7', '8', '1', '5', '3', '.'],
                 ['.', '1', '.', '.', '9', '7', '.', '.', '.'],
                 ['.', '.', '.', '5', '.', '.', '4', '.', '3'],
                 ['6', '8', '5', '2', '3', '.', '.', '.', '.'],
                 ['.', '5', '1', '9', '.', '.', '.', '.', '2'],
                 ['4', '.', '6', '3', '.', '2', '.', '5', '1'],
                 ['.', '.', '2', '.', '4', '5', '.', '7', '.'],
             ],
             [
                 ['9', '.', '.', '.', '7', '2', '.', '3', '.'],
                 ['4', '1', '.', '8', '5', '.', '9', '.', '.'],
                 ['2', '7', '3', '9', '.', '.', '.', '.', '.'],
                 ['.', '3', '.', '.', '.', '.', '7', '.', '.'],
                 ['1', '9', '7', '.', '3', '.', '.', '.', '5'],
                 ['6', '5', '2', '1', '.', '.', '4', '8', '3'],
                 ['.', '.', '9', '.', '.', '4', '.', '1', '8'],
                 ['.', '.', '.', '2', '.', '5', '3', '4', '.'],
                 ['5', '.', '8', '.', '.', '.', '.', '6', '7'],
             ]
            ]
        ]

var currentLevel = 0
var numberOfLevel = levels.length
var items
var symbolizeLevelMax = 7 // Last level in which we set symbols

var url = "qrc:/gcompris/src/activities/sudoku/resource/"

var symbols = [
            {"imgName": "circle", "text": 'A', "extension": ".svg"},
            {"imgName": "rectangle", "text": 'B', "extension": ".svg"},
            {"imgName": "rhombus", "text": 'C', "extension": ".svg"},
            {"imgName": "star", "text": 'D', "extension": ".svg"},
            {"imgName": "triangle", "text": 'E', "extension": ".svg"}
        ]

function start(items_) {
    items = items_
    currentLevel = 0
    items.score.currentSubLevel = 1

    // Shuffle all levels
    for(var nb = 0 ; nb < levels.length ; ++ nb) {
        Core.shuffle(levels[nb]);
    }

    // Shuffle the symbols
    Core.shuffle(symbols);
    for(var s = 0 ; s < symbols.length ; ++ s) {
        // Change the letter
        symbols[s].text = String.fromCharCode('A'.charCodeAt() +s);
    }

    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    items.score.numberOfSubLevels = levels[currentLevel].length

    for(var i = items.availablePiecesModel.model.count-1 ; i >= 0 ; -- i) {
        items.availablePiecesModel.model.remove(i);
    }

    items.sudokuModel.clear();

    // Copy current sudoku in local variable
    var initialSudoku = levels[currentLevel][items.score.currentSubLevel-1];

    items.columns = initialSudoku.length
    items.rows = items.columns

    // Compute number of regions
    var nbLines = Math.floor(Math.sqrt(items.columns));
    items.background.nbRegions = nbLines*nbLines == items.columns ? nbLines : 1;

    // Create grid
    for(var i = 0 ; i < initialSudoku.length ; ++ i) {
        var line = [];
        for(var j = 0 ; j < initialSudoku[i].length ; ++ j) {
            items.sudokuModel.append({
                                         'textValue': initialSudoku[i][j],
                                         'initial': initialSudoku[i][j] != ".",
                                         'mState': initialSudoku[i][j] != "." ? "initial" : "default",
                                     })
        }
    }

    if(currentLevel < symbolizeLevelMax) { // Play with symbols
        // Randomize symbols
        for(var i = 0 ; i < symbols.length ; ++ i) {
            for(var line = 0 ; line < items.sudokuModel.count ; ++ line) {
                if(items.sudokuModel.get(line).textValue == symbols[i].text) {
                    items.availablePiecesModel.model.append(symbols[i]);
                    break; // break to pass to the next symbol
                }
            }
        }
    }
    else { // Play with numbers
        for(var i = 1 ; i < items.columns+1 ; ++ i) {
            items.availablePiecesModel.model.append({"imgName": i.toString(),
                                                        "text": i.toString(),
                                                        "extension": ".svg"});
        }
    }
}

function nextLevel() {
    items.score.currentSubLevel = 1
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    items.score.currentSubLevel = 1
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

/*
 Code that increments the sublevel and level
 And bail out if no more levels are available
*/
function incrementLevel() {

    items.score.currentSubLevel ++

    if(items.score.currentSubLevel > items.score.numberOfSubLevels) {
        // Try the next level
        items.score.currentSubLevel = 1
        currentLevel ++
    }
    if(currentLevel > numberOfLevel) {
        currentLevel = numberOfLevel
    }
    initLevel();
}

function clickOn(caseX, caseY) {
    var initialSudoku = levels[currentLevel][items.score.currentSubLevel-1];

    var currentCase = caseX + caseY * initialSudoku.length;

    if(initialSudoku[caseY][caseX] == '.') { // Don't update fixed cases.
        var currentSymbol = items.availablePiecesModel.model.get(items.availablePiecesModel.view.currentIndex);
        var isGood = isLegal(caseX, caseY, currentSymbol.text);
        /*
            If current case is empty, we look if it is legal and put the symbol.
            Else, we colorize the existing cases in conflict with the one pressed
        */
        if(items.sudokuModel.get(currentCase).textValue == '.') {
            if(isGood) {
                items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/win.wav')
                items.sudokuModel.get(currentCase).textValue = currentSymbol.text
            } else {
                items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
            }
        }
        else {
            // Already a symbol in this case, we remove it
            items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/darken.wav')
            items.sudokuModel.get(currentCase).textValue = '.'
        }
    }

    if(isSolved()) {
        items.bonus.good("flower")
    }
}

// return true or false if the given number is possible
function isLegal(posX, posY, value) {

    var possible = true

    // Check this number is not already in a row
    var firstX = posY * items.columns;
    var lastX = firstX + items.columns-1;

    var clickedCase = posX + posY * items.columns;

    for (var x = firstX ; x <= lastX ; ++ x) {
        if (x == clickedCase)
            continue

        var rowValue = items.sudokuModel.get(x)

        if(value == rowValue.textValue) {
            items.sudokuModel.get(x).mState = "error";
            possible = false
        }
    }

    var firstY = posX;
    var lastY = items.sudokuModel.count - items.columns + firstY;

    // Check this number is not already in a column
    for (var y = firstY ; y <= lastY ; y += items.columns) {

        if (y == clickedCase)
            continue

        var colValue = items.sudokuModel.get(y)

        if(value == colValue.textValue) {
            items.sudokuModel.get(y).mState = "error";
            possible = false
        }
    }

    // Check this number is in a region
    if(items.background.nbRegions > 1) {
        // First, find the top-left square of the region
        var firstSquareX = Math.floor(posX/items.background.nbRegions)*items.background.nbRegions;
        var firstSquareY = Math.floor(posY/items.background.nbRegions)*items.background.nbRegions;

        for(var x = firstSquareX ; x < firstSquareX +items.background.nbRegions ; x ++) {
            for(var y = firstSquareY ; y < firstSquareY + items.background.nbRegions ; y ++) {
                if(x == posX && y == posY) {
                    // Do not check the current square
                    continue;
                }

                var checkedCase = x + y * items.columns;
                var checkedCaseValue = items.sudokuModel.get(checkedCase)

                if(value == checkedCaseValue.textValue) {
                    items.sudokuModel.get(checkedCase).mState = "error";
                    possible = false
                }
            }
        }
    }

    return possible
}

/*
 Return true or false if the given sudoku is solved
 We don't really check it's solved, only that all squares
 have a value. This works because only valid numbers can
 be entered up front.
*/
function isSolved() {
    for(var i = 0 ; i < items.sudokuModel.count ; ++ i) {
        var value = items.sudokuModel.get(i).textValue
        if(value == '.')
            return false
    }
    return true
}

function restoreState(mCase) {
    items.sudokuModel.get(mCase.gridIndex).mState = mCase.isInitial ? "initial" : "default"
}

function dataToImageSource(data) {
    var imageName = "";

    if(currentLevel < symbolizeLevelMax) { // Play with symbols
        for(var i = 0 ; i < symbols.length ; ++ i) {
            if(symbols[i].text == data) {
                imageName = url + symbols[i].imgName+symbols[i].extension;
                break;
            }
        }
    }
    else { // numbers
        if(data != ".") {
            imageName = url+data+".svg";
        }
    }

    return imageName;
}

function onKeyPressed(event) {
    var keyValue = -1;
    switch(event.key)
    {
    case Qt.Key_1:
        keyValue = 0;
        break;
    case Qt.Key_2:
        keyValue = 1;
        break;
    case Qt.Key_3:
        keyValue = 2;
        break;
    case Qt.Key_4:
        keyValue = 3;
        break;
    case Qt.Key_5:
        keyValue = 4;
        break;
    case Qt.Key_6:
        keyValue = 5;
        break;
    case Qt.Key_7:
        keyValue = 6;
        break;
    case Qt.Key_8:
        keyValue = 7;
        break;
    case Qt.Key_9:
        keyValue = 8;
        break;
    }
    if(keyValue >= 0 && keyValue < items.availablePiecesModel.model.count) {
        items.availablePiecesModel.view.currentIndex = keyValue;
        event.accepted=true;
    }
}
