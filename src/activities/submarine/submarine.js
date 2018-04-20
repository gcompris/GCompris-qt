/* GCompris - submarine.js
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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
.pragma library
.import GCompris 1.0 as GCompris
.import QtQuick 2.6 as Quick

var currentLevel = 0
var numberOfLevel = 10
var items

var tutorials = [
            [
                qsTr("Move the submarine to the other side of the screen."),
                qsTr("The leftmost item in the control panel is the engine of the submarine, indicating the current speed of the submarine."),
                qsTr("Increase or decrease the velocity of the submarine using the engine."),
                qsTr("Press the + button to increase the velocity, or the - button to decrease the velocity."),
            ],
            [
                qsTr("The item next to the engine is the Ballast tanks."),
                qsTr("The Ballast tanks are used to float or dive under water."),
                qsTr("If the ballast tanks are empty, the submarine will float. If the ballast tanks are full of water, the submarine will dive underwater."),
                qsTr("Turning the upper valve on or off will alternatively allow or stop water from filling in the Ballast tanks, thus allowing it to dive underwater."),
                qsTr("Turning the lower valve on or off will alternatively allow or stop water from flushing out the Ballast tanks, thus allowing it to float on the surface of the water."),
            ],
            [
                qsTr("The rightmost item in the control panel controls the diving planes of the submarine"),
                qsTr("The Diving Planes in a submarine is used to control the depth of the submarine accurately once it is underwater."),
                qsTr("Once the submarine is moving underwater, increasing or decreasing the angle of the planes will increase and decrease the depth of the submarine."),
                qsTr("The + button will increase the depth of the submarine, while the - button will decrease the depth of the submarine."),
                qsTr("Grab the crown to open the gate."),
                qsTr("Check out the help menu for the keyboard controls."),
            ]
]

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1

    /* Tutorial Levels, display tutorials */
    if (currentLevel < tutorials.length) {
        items.tutorial.visible = true
        items.tutorial.index = 0
        items.tutorial.intro = tutorials[currentLevel]
    } else {
        items.tutorial.visible = false
    }

    setUpLevelElements()
}

function setUpLevelElements() {
    /* Set up initial position and state of the submarine */
    items.submarine.resetSubmarine()

    if(items.ship.visible) {
        items.ship.reset()
    }

    items.crown.reset()
    items.whale.reset()
    items.controls.resetVannes()

    items.processingAnswer = false

    resetUpperGate()
}

function resetUpperGate() {
    if (items && items.crown && !items.crown.visible && items.upperGate && items.upperGate.visible) {
        items.upperGate.isGateOpen = true
    }
}

function closeGate() {
    if (items.upperGate.visible) {
        items.upperGate.isGateOpen = false
    }
}

function finishLevel(win) {
    if (items.processingAnswer)
        return
    items.processingAnswer = true
    if (win) {
        items.bonus.good("flower")
    } else {
        items.submarine.destroySubmarine()
        items.bonus.bad("flower")
    }
}

function nextLevel() {
    items.processingAnswer = true
    closeGate()

    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    items.processingAnswer = true
    closeGate()

    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
