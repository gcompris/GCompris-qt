/* GCompris - maze.js
*
* SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Bastiaan Verhoef <b.f.verhoef@student.utwente.nl> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/maze/resource/"
var numberOfLevel = 25
var items
var relativeMode
var invisibleMode

var NORTH = 1
var WEST = 2
var SOUTH = 4
var EAST = 8
var SET = 16

var mazeColumns = 0
var mazeRows = 0
var maze = 0

var win = false

function start(items_, relativeMode_, invisibleMode_) {
    items = items_
    relativeMode = relativeMode_
    invisibleMode = invisibleMode_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {}

function initLevel() {
    items.wallVisible = !invisibleMode

    win = false

    /* Set main variables */
    if (items.currentLevel + 1 == 1) {
        mazeColumns = 4
        mazeRows = 4
    } else if (items.currentLevel + 1 == 2) {
        mazeColumns = 5
        mazeRows = 4
    } else if (items.currentLevel + 1 == 3) {
        mazeColumns = 5
        mazeRows = 5
    } else if (items.currentLevel + 1 == 4) {
        mazeColumns = 6
        mazeRows = 5
    } else if (items.currentLevel + 1 == 5) {
        mazeColumns = 6
        mazeRows = 6
    } else if (items.currentLevel + 1 == 6) {
        mazeColumns = 6
        mazeRows = 7
    } else if (items.currentLevel + 1 == 7) {
        mazeColumns = 7
        mazeRows = 7
    } else if (items.currentLevel + 1 == 8) {
        mazeColumns = 8
        mazeRows = 7
    } else if (items.currentLevel + 1 == 9) {
        mazeColumns = 8
        mazeRows = 8
    } else if (items.currentLevel + 1 == 10) {
        mazeColumns = 9
        mazeRows = 8
    } else if (items.currentLevel + 1 == 11) {
        mazeColumns = 9
        mazeRows = 9
    } else if (items.currentLevel + 1 == 12) {
        mazeColumns = 10
        mazeRows = 9
    } else if (items.currentLevel + 1 == 13) {
        mazeColumns = 10
        mazeRows = 10
    } else if (items.currentLevel + 1 == 14) {
        mazeColumns = 8
        mazeRows = 16
    } else if (items.currentLevel + 1 == 15) {
        mazeColumns = 14
        mazeRows = 14
    } else if (items.currentLevel + 1 == 16) {
        mazeColumns = 16
        mazeRows = 15
    } else if (items.currentLevel + 1 == 17) {
        mazeColumns = 17
        mazeRows = 16
    } else if (items.currentLevel + 1 == 18) {
        mazeColumns = 18
    } else if (items.currentLevel + 1 == 19) {
        mazeColumns = 19
        mazeRows = 18
    } else if (items.currentLevel + 1 == 20) {
        mazeColumns = 19
        mazeRows = 19
    } else if (items.currentLevel + 1 == 21) {
        mazeColumns = 20
        mazeRows = 19
    } else if (items.currentLevel + 1 == 22) {
        mazeColumns = 20
        mazeRows = 20
    } else if (items.currentLevel + 1 == 23) {
        mazeColumns = 19
        mazeRows = 21
    } else if (items.currentLevel + 1 == 24) {
        mazeColumns = 23
        mazeRows = 21
    } else if (items.currentLevel + 1 == 25) {
        mazeColumns = 23
        mazeRows = 23
    }

    items.mazeRows = mazeRows
    items.mazeColumns = mazeColumns

    /* Build maze */
    maze = []
    for (var id = 0; id < mazeColumns * mazeRows; ++id) {
        maze[id] = 15
    }

    /* Generate maze */
    generateMaze(Math.floor(Math.random() * mazeColumns),
                 Math.floor(Math.random() * mazeRows))

    /* Remove set */
    for (id = 0; id < mazeColumns * mazeRows; ++id) {
        maze[id] = maze[id] ^ SET
    }

    /* Set maze */
    items.mazeRepeater = maze

    /* Set initial position of player */
    items.playerx = 0
    items.playery = Math.floor(Math.random() * mazeRows)

    /* Set position of door */
    items.doory = Math.floor(Math.random() * mazeRows)

    items.fastMode = (items.currentLevel + 1 >= 14)
}

function getId(x, y) {
    return x + y * mazeColumns
}

function check(x, y) {
    if (maze[getId(x, y)] & SET)
        return 1
    return 0
}

function isPossible(x, y) {
    var wall = maze[getId(x, y)]
    var pos = []
    wall = wall ^ SET
    pos[0] = 0
    if (x === 0) {
        wall = wall ^ WEST
    }
    if (y === 0) {
        wall = wall ^ NORTH
    }
    if (x === mazeColumns - 1) {
        wall = wall ^ EAST
    }
    if (y === mazeRows - 1) {
        wall = wall ^ SOUTH
    }
    if (wall & EAST) {
        if (check(x + 1, y) === 0) {
            pos[0] = pos[0] + 1
            pos[pos[0]] = EAST
        }
    }
    if (wall & SOUTH) {
        if (check(x, y + 1) === 0) {
            pos[0] = pos[0] + 1
            pos[pos[0]] = SOUTH
        }
    }
    if (wall & WEST) {
        if (check(x - 1, y) === 0) {
            pos[0] = pos[0] + 1
            pos[pos[0]] = WEST
        }
    }
    if (wall & NORTH) {
        if (check(x, y - 1) === 0) {
            pos[0] = pos[0] + 1
            pos[pos[0]] = NORTH
        }
    }
    return pos
}

function generateMaze(x, y) {
    maze[getId(x, y)] = maze[getId(x, y)] + SET
    var po = isPossible(x, y)
    while (po[0] > 0) {
        var ran = po[Math.floor(Math.random() * po[0]) + 1]
        switch (ran) {
        case EAST:
            maze[getId(x, y)] = maze[getId(x, y)] ^ EAST
            maze[getId(x + 1, y)] = maze[getId(x + 1, y)] ^ WEST
            generateMaze(x + 1, y)
            break
        case SOUTH:
            maze[getId(x, y)] = maze[getId(x, y)] ^ SOUTH
            maze[getId(x, y + 1)] = maze[getId(x, y + 1)] ^ NORTH
            generateMaze(x, y + 1)
            break
        case WEST:
            maze[getId(x, y)] = maze[getId(x, y)] ^ WEST
            maze[getId(x - 1, y)] = maze[getId(x - 1, y)] ^ EAST
            generateMaze(x - 1, y)
            break
        case NORTH:
            maze[getId(x, y)] = maze[getId(x, y)] ^ NORTH
            maze[getId(x, y - 1)] = maze[getId(x, y - 1)] ^ SOUTH
            generateMaze(x, y - 1)
            break
        }
        po = isPossible(x, y)
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function getMaze() {
    return maze
}

function autoMove() {
    if (items && items.fastMode) {
        var number = 0
        var result = 0
        if (getPlayerRotation() !== 90 && !(maze[getId(
                                                     items.playerx,
                                                     items.playery)] & EAST)) {
            number++
            result |= EAST
        }
        if (getPlayerRotation() !== 270 && !(maze[getId(
                                                      items.playerx,
                                                      items.playery)] & WEST)) {
            number++
            result |= WEST
        }
        if (getPlayerRotation() !== 180
                && !(maze[getId(items.playerx, items.playery)] & SOUTH)) {
            number++
            result |= SOUTH
        }
        if (getPlayerRotation() !== 0 && !(maze[getId(
                                                    items.playerx,
                                                    items.playery)] & NORTH)) {
            number++
            result |= NORTH
        }
        if (number == 1) {
            if (items.playery !== items.doory
                    || items.playerx !== mazeColumns - 1) {
                switch (result) {
                case EAST:
                    items.playerr = 270
                    ++items.playerx
                    break
                case WEST:
                    items.playerr = 90
                    --items.playerx
                    break
                case NORTH:
                    items.playerr = 180
                    --items.playery
                    break
                case SOUTH:
                    items.playerr = 0
                    ++items.playery
                    break
                }

                /* Check if success */
                checkSuccess()
            }
        }
    }
}

/* 0= SOUTH
* 90= WEST
* 180 = NORTH
* 270 =EST
*/
function getPlayerRotation() {
    return ((items.playerr % 360) + 360) % 360
}

function checkSuccess() {
    if (items.playery === items.doory && items.playerx === mazeColumns - 1) {
        win = true
        items.bonus.good("lion")
    }
}

function processPressedKey(event) {
    /* Mode invisible */
    if (invisibleMode && event.key === Qt.Key_Space) {
        items.wallVisible = !items.wallVisible
        items.message.visible = items.wallVisible
    }

    if ( !win ) {
        /* Move the player */
        switch (event.key) {
        case Qt.Key_Right:
            clickRight()
            event.accepted = true
            break
        case Qt.Key_Left:
            clickLeft()
            event.accepted = true
            break
        case Qt.Key_Up:
            clickUp()
            event.accepted = true
            break
        case Qt.Key_Down:
            clickDown()
            event.accepted = true
            break
        }
    }
}

function clickRight() {
    /* Move the player */
    if ((!invisibleMode || !items.wallVisible)
            && (items.playery !== items.doory
                || items.playerx !== mazeColumns - 1)) {
        if (relativeMode) {
            /* Relative mode */
            if (items.playerr % 90 === 0)
                items.playerr += 90
        } else {
            /* Absolute mode */
            var curpos = getPlayerRotation()
            items.playerr = items.playerr - (curpos === 0 ? 90 : curpos - 270)
            if (!(maze[getId(items.playerx, items.playery)] & EAST)) {
                ++items.playerx
            } else {
                items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
            }
        }
    }

    /* Check if success */
    checkSuccess()
}

function clickLeft() {
    /* Move the player */
    if ((!invisibleMode || !items.wallVisible)
            && (items.playery !== items.doory
                || items.playerx !== mazeColumns - 1)) {
        if (relativeMode) {
            /* Relative mode */
            if (items.playerr % 90 === 0)
                items.playerr -= 90
        } else {
            /* Absolute mode */
            var curpos = getPlayerRotation()
            items.playerr = items.playerr - curpos + 90
            if (!(maze[getId(items.playerx, items.playery)] & WEST)) {
                --items.playerx
            } else {
                items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
            }
        }
    }

    /* Check if success */
    checkSuccess()
}

function clickDown() {
    /* Move the player */
    if ((!invisibleMode || !items.wallVisible)
            && (items.playery !== items.doory
                || items.playerx !== mazeColumns - 1)) {
        if (relativeMode) {
            /* Relative mode */
            if (items.playerr % 90 === 0) {
                if (items.playerr >= 180)
                    items.playerr -= 180
                else
                    items.playerr += 180
            }
        } else {
            /* Absolute mode */
            var curpos = getPlayerRotation()
            items.playerr = items.playerr - (curpos === 270 ? -90 : curpos)
            if (!(maze[getId(items.playerx, items.playery)] & SOUTH)) {
                ++items.playery
            } else {
                items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
            }
        }
    }

    /* Check if success */
    checkSuccess()
}

function clickUp() {
    /* Move the player */
    if ((!invisibleMode || !items.wallVisible)
            && (items.playery !== items.doory
                || items.playerx !== mazeColumns - 1)) {
        if (relativeMode) {
            /* Relative mode */
            if (getPlayerRotation() === 270) {
                if (!(maze[getId(items.playerx, items.playery)] & EAST)) {
                    ++items.playerx
                } else {
                    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
                }
            } else if (getPlayerRotation() === 180) {
                if (!(maze[getId(items.playerx, items.playery)] & NORTH)) {
                    --items.playery
                } else {
                    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
                }
            } else if (getPlayerRotation() === 90) {
                if (!(maze[getId(items.playerx, items.playery)] & WEST)) {
                    --items.playerx
                } else {
                    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
                }
            } else {
                if (!(maze[getId(items.playerx, items.playery)] & SOUTH)) {
                    ++items.playery
                } else {
                    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
                }
            }
        } else {
            /* Absolute mode */
            var curpos = getPlayerRotation()
            items.playerr = items.playerr - curpos + 180
            if (!(maze[getId(items.playerx, items.playery)] & NORTH)) {
                --items.playery
            } else {
                items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
            }
        }
    }

    /* Check if success */
    checkSuccess()
}
