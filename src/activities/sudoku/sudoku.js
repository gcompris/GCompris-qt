/*
 gcompris - sudoku.js

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
.import QtQuick 2.0 as Quick
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
        ]

var currentLevel = 0
var numberOfLevel = levels.length
var items
var hoveredCase = {"x":-1, "y":-1}

var url = "qrc:/gcompris/src/activities/sudoku/resource/"

var symbols = [
            {"imgName": "circle", "text": 'A'},
            {"imgName": "rectangle", "text": 'B'},
            {"imgName": "rhombus", "text": 'C'},
            {"imgName": "star", "text": 'D'},
            {"imgName": "triangle", "text": 'E'}
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

    for(var i = 0 ; i < initialSudoku.length ; ++ i) {
        var line = [];
        for(var j = 0 ; j < initialSudoku[i].length ; ++ j) {
            items.sudokuModel.append({
                                         'textValue': initialSudoku[i][j],
                                         'initial': initialSudoku[i][j] != ".",
                                         'mState': initialSudoku[i][j] != "." ? "initial" : "default",
                                         'error': false,
                                     })
        }
    }

    if(currentLevel < 9) { // Play with symbols
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
        for(var i = 0 ; i < items.sudokuModel.count ; ++ i) {
            items.availablePiecesModel.model.append(i);
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
    print("Click on: " + caseX + " " + caseY + " (" + currentCase + ") " + items.sudokuModel.get(currentCase).textValue)

    if(initialSudoku[caseY][caseX] == '.') { // Don't update fixed cases.
        var currentSymbol = items.availablePiecesModel.model.get(items.availablePiecesModel.view.currentIndex);
        print("isLegal : " + isLegal(caseX, caseY, currentSymbol.text))
        /*
            If current case is empty, we look if it is legal and put the symbol.
            Else, we colorize the existing cases in conflict with the one pressed
        */
        if(items.sudokuModel.get(currentCase).textValue == '.') {
            if(isLegal(caseX, caseY, currentSymbol.text)) {
                items.sudokuModel.get(currentCase).textValue = currentSymbol.text
                print("Case " + currentCase + ":" + items.sudokuModel.get(currentCase).textValue)
            }
            else {
                // TODO Set error
            }
        }
        else {
            // Already a symbol in this case, we remove it
            items.sudokuModel.get(currentCase).textValue = '.'
        }
    }

    if(isSolved()) {
        items.bonus.good("flower")
    }

    //if(isCasePossible()) drawImage();

    //    ckeckWin();
    //    if(currentSudoku.contains('.')) {
    //        print("contains .")
    //    }
}

// return true or false if the given number is possible
function isLegal(posX, posY, value) {

    var possible = true
    var bad_square = []

    // Check this number is not already in a row
    var firstX = posY * items.columns;
    var lastX = firstX + items.columns-1;

    var clickedCase = posX + posY * items.columns;

    print("pos x:" + posX + ", posY:" + posY)

    print("First x:" + firstX + ", to lastX:" + lastX + ", we are:" + clickedCase)
    for (var x = firstX ; x <= lastX ; ++ x) {
        if (x == clickedCase)
            continue

        var rowValue = items.sudokuModel.get(x)

        if(value == rowValue.textValue) {
            items.sudokuModel.get(x).mState = "error";
            print("Impossible on x because: " + x)
            possible = false
        }
    }

    var firstY = posX;
    var lastY = items.sudokuModel.count - items.columns + firstY;

    print("First y:" + firstY + ", to last y:" + lastY + ", we are:" + clickedCase)

    // Check this number is not already in a column
    for (var y = firstY ; y <= lastY ; y += items.columns) {

        if (y == clickedCase)
            continue

        var colValue = items.sudokuModel.get(y)

        if(value == colValue.textValue) {
            items.sudokuModel.get(y).mState = "error";
            print("Impossible on y because: " + y)
            possible = false
        }
    }
    // TODO Check this number is in a region
    // Region is the modulo place to set region if defined
    //  region = None
    //  if(self.sudo_region.has_key(self.sudo_size)):
    //    region=self.sudo_region[self.sudo_size]

    //  if(region):
    //    # First, find the top-left square of the region
    //    top_left=[self.cursqre[0]/region*region, self.cursqre[1]/region*region]
    //    for x in range(0,region):
    //      for y in range(0,region):
    //        # Do not check the current square
    //        if (top_left[0] + x == self.cursqre[0] and
    //        top_left[1] + y == self.cursqre[1]):
    //          continue

         //        item = self.sudo_number[top_left[0] + x][top_left[1] + y]
    //        othernumber = item.get_property('text').decode('UTF-8')

    //        if(number == othernumber):
    //          bad_square.append(self.sudo_square[top_left[0] + x][top_left[1] + y])
    //          possible = False

    //  if not possible:
    //    self.set_on_error(bad_square)

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

function dataToImageSource(data) {
    var imageName = "";

    for(var i = 0 ; i < symbols.length ; ++ i) {
        if(symbols[i].text == data) {
            imageName = "qrc:/gcompris/src/activities/sudoku/resource/"+symbols[i].imgName+".png";
            break;
        }
    }

    return imageName;
}
