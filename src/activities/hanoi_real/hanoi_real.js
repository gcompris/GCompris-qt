/* GCompris - hanoi_real.js
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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
.import QtQuick 2.0 as Quick

var url = "qrc:/gcompris/src/activities/hanoi_real/resource/"

var tower1 = [1,2,3]
var tower2 = []
var tower3 = []

var discs = [1,1,1,1]

var currentLevel  = 0
var numberOfLevel = 2
var items

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
}

function nextLevel()
{
    if(numberOfLevel <= ++currentLevel )
    {
        currentLevel = 0
        resetForLevelTwo()
    }

    else
    {
        resetForLevelOne()
    }

    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
        resetForLevelOne()
    }

    else
    {
        resetForLevelTwo()
    }

    initLevel();
}

function popdisc(disc)
{
    if( 1 == discs[disc] )
        tower1.pop()
    else if( 2 == discs[disc] )
        tower2.pop()
    else if( 3 == discs[disc] )
        tower3.pop()
}

function placediscsAtOriginal()
{
    items.disc1.x = items.tower1Image.x - items.disc1.width * .20
    items.disc1.y = items.tower1Image.y + items.tower1Image.height * .70

    items.disc2.x = items.tower1Image.x - items.disc2.width * .18
    items.disc2.y = items.tower1Image.y + items.tower1Image.height * .70 - items.disc1.height

    items.disc3.x = items.tower1Image.x - items.disc3.width * .15
    items.disc3.y = items.tower1Image.y + items.tower1Image.height * .70 - items.disc1.height - items.disc2.height

    items.disc4.x = items.tower1Image.x - items.disc4.width * .15
    items.disc4.y = items.tower1Image.y + items.tower1Image.height * .70 - items.disc1.height - items.disc2.height - items.disc3.height
}

/*
    Disables the mouse drags for discs which are not on top of towers
*/
function disableNonDraggablediscs()
{
    if( (1 == tower1[tower1.length-1]) || (1 == tower2[tower2.length-1]) || (1 == tower3[tower3.length-1]) )
        items.discOneMouse.enabled = true
    else
        items.discOneMouse.enabled = false

    if( (2 == tower1[tower1.length-1]) || (2 == tower2[tower2.length-1]) || (2 == tower3[tower3.length-1]) )
        items.discTwoMouse.enabled = true
    else
        items.discTwoMouse.enabled = false

    if( (3 == tower1[tower1.length-1]) || (3 == tower2[tower2.length-1]) || (3 == tower3[tower3.length-1]) )
        items.discThreeMouse.enabled = true
    else
        items.discThreeMouse.enabled = false

    if( (4 == tower1[tower1.length-1]) || (4 == tower2[tower2.length-1]) || (4 == tower3[tower3.length-1]) )
        items.discFourMouse.enabled = true
    else
        items.discFourMouse.enabled = false
}

/*
    Calculates if disc is present on the top of given tower
*/
function checkdiscOverTower(disc, tower)
{
    if( 1 === disc)
    {
        if( 1 == tower )
        return !(( (items.disc1.x + items.disc1.width) < (items.tower1Image.x) ) || ( items.disc1.x > items.tower1Image.x + items.tower1Image.width ))

        else if( 2 == tower )
            return !(( (items.disc1.x + items.disc1.width) < (items.tower2Image.x) ) || ( items.disc1.x > items.tower2Image.x + items.tower2Image.width ))

        else if( 3 == tower )
            return !(( (items.disc1.x + items.disc1.width) < (items.tower3Image.x) ) || ( items.disc1.x > items.tower3Image.x + items.tower3Image.width ))
    }

    else if( 2 === disc)
    {
        if( 1 == tower )
        return !(( (items.disc2.x + items.disc2.width) < (items.tower1Image.x) ) || ( items.disc2.x > items.tower1Image.x + items.tower1Image.width ))

        else if( 2 == tower )
            return !(( (items.disc2.x + items.disc2.width) < (items.tower2Image.x) ) || ( items.disc2.x > items.tower2Image.x + items.tower2Image.width ))

        else if( 3 == tower )
            return !(( (items.disc2.x + items.disc2.width) < (items.tower3Image.x) ) || ( items.disc2.x > items.tower3Image.x + items.tower3Image.width ))
    }

    else if( 3 === disc)
    {
        if( 1 == tower )
        return !(( (items.disc3.x + items.disc3.width) < (items.tower1Image.x) ) || ( items.disc3.x > items.tower1Image.x + items.tower1Image.width ))

        else if( 2 == tower )
            return !(( (items.disc3.x + items.disc3.width) < (items.tower2Image.x) ) || ( items.disc3.x > items.tower2Image.x + items.tower2Image.width ))

        else if( 3 == tower )
            return !(( (items.disc3.x + items.disc3.width) < (items.tower3Image.x) ) || ( items.disc3.x > items.tower3Image.x + items.tower3Image.width ))
    }

    else if( 4 === disc && items.disc4.height != 0)
    {
        if( 1 == tower )
        return !(( (items.disc4.x + items.disc4.width) < (items.tower1Image.x) ) || ( items.disc4.x > items.tower1Image.x + items.tower1Image.width ))

        else if( 2 == tower )
            return !(( (items.disc4.x + items.disc4.width) < (items.tower2Image.x) ) || ( items.disc4.x > items.tower2Image.x + items.tower2Image.width ))

        else if( 3 == tower )
            return !(( (items.disc4.x + items.disc4.width) < (items.tower3Image.x) ) || ( items.disc4.x > items.tower3Image.x + items.tower3Image.width ))
    }
}

function resetForLevelOne()
{
    placediscsAtOriginal()

    items.disc4.height = items.disc3.height

    tower1 = []
    tower2 = []
    tower3 = []

    tower1.push(1)
    tower1.push(2)
    tower1.push(3)
    tower1.push(4)
    disableNonDraggablediscs()

    discs.push(1)
    discs[0] = discs[1] = discs[2] = discs[3] = discs[4] = 1
}

function resetForLevelTwo()
{
    placediscsAtOriginal()

    items.disc4.height = 0

    tower1 = []
    tower2 = []
    tower3 = []

    tower1.push(1)
    tower1.push(2)
    tower1.push(3)

    disableNonDraggablediscs()

    discs = []
    discs.push(1)
    discs.push(1)
    discs.push(1)
    discs.push(1)
}

function checkSolved()
{
    if ( 0 == currentLevel )
    {
        if( 3 == tower3.length && tower3[0] == 1 && tower3[1] == 2 && tower3[2] == 3 )
        {
            items.bonus.good("flower")
            resetForLevelOne()
        }
    }

    else if ( 1 == currentLevel )
    {
        if( 4 == tower3.length && tower3[0] == 1 && tower3[1] == 2 && tower3[2] == 3 && tower3[3] == 4 )
        {
            items.bonus.good("flower")
            resetForLevelTwo()
        }
    }

    else
    {
        console.log("Invalid level request")
    }
}
