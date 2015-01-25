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

function repositionDiscs(index)
{
    var position;
    var newX;
    var newY;

     if( checkDiscInTower(index+1, tower1) ){

         newX = items.tower1Image.x
         newY = items.tower1Image.y
         position = getDiscPositionInTower( index+1, tower1 )
     }
     else if( checkDiscInTower(index+1, tower2) ){

         newX = items.tower2Image.x
         newY = items.tower2Image.y
         position = getDiscPositionInTower( index+1, tower2 )
     }
     else if( checkDiscInTower(index+1, tower3) ){

         newX = items.tower3Image.x
         newY = items.tower3Image.y
         position = getDiscPositionInTower( index+1, tower3 )
     }

     items.discRepeater.itemAt(index).x =
             newX - items.discRepeater.itemAt(0).discWidth * (.20 - index * .05 )
     items.discRepeater.itemAt(index).y =
             newY + items.tower1Image.height * .73 - ((position-1) *  items.discRepeater.itemAt(index).height)
     disableNonDraggablediscs()
}

function placeDisc(tower, towerImage, index)
{
    items.discRepeater.itemAt(index).x =
            towerImage.x + towerImage.width / 2 -
            items.discRepeater.itemAt(index).discWidth / 2
    items.discRepeater.itemAt(index).discY =
            towerImage.y + towerImage.height -
            (tower.length + 2) * items.discRepeater.itemAt(0).discHeight
}

function discReleased(index)
{
    if( checkIfDiscOnTowerImage(index+1, 1) &&
            !(0 != tower1.length &&
              index+1 <= tower1[tower1.length-1]) ) {
        placeDisc(tower1, items.tower1Image, index)
        popDisc(index+1)

        tower1.push(index+1)
        discs[index+1] = 1
    } else if( checkIfDiscOnTowerImage(index+1, 2) &&
              !( 0 != tower2.length && index+1 <= tower2[tower2.length-1] ) ) {
        placeDisc(tower2, items.tower2Image, index)
        popDisc(index+1)

        tower2.push(index+1)
        discs[index+1] = 2
    } else if( checkIfDiscOnTowerImage(index+1, 3) &&
              !( 0 != tower3.length && index+1 <= tower3[tower3.length-1] ) ) {
        placeDisc(tower3, items.tower3Image, index)
        popDisc(index+1)

        tower3.push(index+1)
        discs[index+1] = 3
    } else {
        // Cancel the drop
        items.discRepeater.itemAt(index).x = items.hanoiStage.currentX
        items.discRepeater.itemAt(index).y = items.hanoiStage.currentY
    }

    disableNonDraggablediscs()
    checkSolved()
    deHighlightTowers()
}

function performTowersHighlight(index)
{
    if( items && items.discRepeater.itemAt(index).discMouseArea.pressed ) {

        deHighlightTowers()

        var currentTower = 1

        if( getDiscPositionInTower(index+1, tower2) == tower2.length ) {
            currentTower = 2
        }

        else if( getDiscPositionInTower(index+1, tower3) == tower3.length ) {
            currentTower = 3
        }

        if( checkIfDiscOnTowerImage(index+1, 1) && 1 != currentTower ) {
            highlightTower(1)
        }
        else if( checkIfDiscOnTowerImage(index+1, 2) && 2 != currentTower ) {
            highlightTower(2)
        }
        else if( checkIfDiscOnTowerImage(index+1, 3) && 3 != currentTower ) {
            highlightTower(3)
        }
        else {
            highlightTower(currentTower)
        }
    }
}

function popDisc(disc) {
    if( 1 == discs[disc] )
        tower1.pop()
    else if( 2 == discs[disc] )
        tower2.pop()
    else if( 3 == discs[disc] )
        tower3.pop()
}

function sceneSizeChanged()
{
    if( items ) {
        for( var i = 0 ; i < numberOfLevel + 2 ; ++i )
            items.discRepeater.itemAt(i).reposition()

        deHighlightTowers()
    }
}

function placeDiscsAtOrigine() {
    for( var i = 0 ; i < numberOfLevel + 2 ; ++i ){
        items.discRepeater.itemAt(i).discX =
                items.tower1Image.x + items.tower1Image.width / 2 -
                items.discRepeater.itemAt(i).discWidth / 2

        items.discRepeater.itemAt(i).discY =
                items.tower1Image.y + items.tower1Image.height -
                (i + 2) * items.discRepeater.itemAt(0).discHeight
    }
}

function disableNonDraggablediscs() {
    if( items ) {
        for( var i = 1 ; i <= numberOfLevel + 2 ; ++ i ){
            if( (i === tower1[tower1.length-1]) ||
                (i === tower2[tower2.length-1]) ||
                (i === tower3[tower3.length-1]) )
                items.discRepeater.itemAt(i-1).mouseEnabled = true
            else
                items.discRepeater.itemAt(i-1).mouseEnabled = false
        }
    }
}

function getDiscPositionInTower(disc, tower) {
    for( var i = 0 ; i < tower.length ; ++i ){
        if( tower[i] == disc )
            return i+1;
    }

    return -1;
}

function checkDiscInTower(disc, tower) {
    for( var i = 0 ; i < tower.length ; ++i ){
        if( tower[i] == disc )
            return true;
    }

    return false;
}

function highlightTower(tower) {
    if( 1 == tower )
        items.tower1ImageHighlight.opacity = .75
    if( 2 == tower )
        items.tower2ImageHighlight.opacity = .75
    if( 3 == tower )
        items.tower3ImageHighlight.opacity = .75
}

function deHighlightTowers() {
        if( items ) {
            items.tower1ImageHighlight.opacity = 0
            items.tower2ImageHighlight.opacity = 0
            items.tower3ImageHighlight.opacity = 0
        }
}

function checkIfDiscOnTowerImage(disc, tower) {

    if( items ) {

        for( var i = 1 ; i <= numberOfLevel + 2 ; ++ i )
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
}

function resetToGetLevel(level){

    placeDiscsAtOrigine()

    for( var i = 0 ; i < level+1 ; ++i )
        items.discRepeater.itemAt(i).opacity = 1    

    for( i = level+1 ; i < numberOfLevel + 2 ; ++i )
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
        }
    }

    else if ( 1 == currentLevel ) {

        if( 4 == tower3.length && tower3[0] == 1 && tower3[1] == 2 && tower3[2] == 3 && tower3[3] == 4 ) {
            items.bonus.good("flower")
        }
    }
}
