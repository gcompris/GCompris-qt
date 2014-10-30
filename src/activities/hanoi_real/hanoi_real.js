/* GCompris - hanoi_real.js
 *
 * Copyright (C) 2014 <Amit Tomar>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "Amit Tomar" <a.tomar@outlook.com> (Qt Quick port)
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

function nextLevel(){

    if(numberOfLevel <= ++currentLevel ){
        currentLevel = 0
        resetToGetLevel(1)
    }

    else{
        resetToGetLevel(2)
    }

    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
        resetToGetLevel(2)
    }

    else{
        resetToGetLevel(1)
    }

    initLevel();
}

function popDisc(disc)
{
    if( 1 == discs[disc] )
        tower1.pop()
    else if( 2 == discs[disc] )
        tower2.pop()
    else if( 3 == discs[disc] )
        tower3.pop()
}

function placeDiscsAtOriginal()
{
    for( var i = 0 ; i < items.totalLevels + 2 ; ++i ){
        items.discRepeater.itemAt(i).discX = items.tower1Image.x - items.discRepeater.itemAt(0).discWidth * (.20 - i * .04 )
        items.discRepeater.itemAt(i).discY = items.tower1Image.y + items.tower1Image.height * .70 - ( i * items.discRepeater.itemAt(1).discHeight )
    }
}

function disableNonDraggablediscs()
{
    if( items ) {

        for( var i = 1 ; i <= items.totalLevels + 2 ; ++ i ){

            if( (i == tower1[tower1.length-1]) || (i == tower2[tower2.length-1]) || (i == tower3[tower3.length-1]) )
                items.discRepeater.itemAt(i-1).mouseEnabled = true

            else
                items.discRepeater.itemAt(i-1).mouseEnabled = false
        }
    }
}

function getDiscPositionInTower(disc, tower)
{
    for( var i = 0 ; i < tower.length ; ++i ){
        if( tower[i] == disc )
            return i+1;
    }

    return -1;
}

function checkDiscInTower(disc, tower)
{
    for( var i = 0 ; i < tower.length ; ++i ){
        if( tower[i] == disc )
            return true;
    }

    return false;
}

function getDiscOnTopOfTower(disc, tower)
{
    for( var i = 1 ; i <= items.totalLevels + 2 ; ++ i )
    {
        if( i === disc){
            if( 1 == tower )
                return !(( (items.discRepeater.itemAt(i-1).discX + items.discRepeater.itemAt(i-1).discWidth) < (items.tower1Image.x) ) || ( items.discRepeater.itemAt(i-1).discX > items.tower1Image.x + items.tower1Image.width ))

            else if( 2 == tower )
                return !(( (items.discRepeater.itemAt(i-1).discX + items.discRepeater.itemAt(i-1).discWidth) < (items.tower2Image.x) ) || ( items.discRepeater.itemAt(i-1).discX > items.tower2Image.x + items.tower2Image.width ))

            else if( 3 == tower )
                return !(( (items.discRepeater.itemAt(i-1).discX + items.discRepeater.itemAt(i-1).discWidth) < (items.tower3Image.x) ) || ( items.discRepeater.itemAt(i-1).discX > items.tower3Image.x + items.tower3Image.width ))
        }
    }
}

function resetToGetLevel(level){

    placeDiscsAtOriginal()

    for( var i = 0 ; i < level+1 ; ++i )
        items.discRepeater.itemAt(i).opacity = 1    

    for( i = level+1 ; i < items.totalLevels + 2 ; ++i )
        items.discRepeater.itemAt(i).opacity = 0

    items.discRepeater.itemAt(1+level).opacity = 1
    items.discRepeater.itemAt(1+level).opacity = 1

    tower1 = []
    tower2 = []
    tower3 = []
    discs  = []

    for( i = 1 ; i <= 2+level; ++ i ) {
        tower1.push(i)
        discs.push(1)
    }

    discs.push(1)
    disableNonDraggablediscs()
}

function checkSolved() {

    if ( 0 == currentLevel ) {

        if( 3 == tower3.length && tower3[0] == 1 && tower3[1] == 2 && tower3[2] == 3 ) {
            items.bonus.good("flower")
            resetToGetLevel(2)
        }
    }

    else if ( 1 == currentLevel ) {

        if( 4 == tower3.length && tower3[0] == 1 && tower3[1] == 2 && tower3[2] == 3 && tower3[3] == 4 ) {
            items.bonus.good("flower")
            resetToGetLevel(1)
        }
    }
}
