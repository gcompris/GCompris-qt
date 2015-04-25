/* GCompris - hanoi_real.js
 *
 * Copyright (C) 2014 <Amit Tomar>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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

var currentLevel  = 0
var numberOfLevel = 3
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
    items.numberOfDisc = currentLevel + 3
    items.discRepeater.model = items.numberOfDisc

    placeDiscsAtOrigin()
    disableNonDraggablediscs()
}

function nextLevel()
{
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel()
{
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function placeDisc(disc, towerImage)
{
    disc.towerImage = towerImage
    disc.position = getNumberOfDiscOnTower(towerImage)
    disc.x = towerImage.x + towerImage.width / 2 - disc.width / 2
    disc.y = towerImage.y + towerImage.height - (disc.position + 1) * disc.height
}

function placeDiscsAtOrigin() {
    // Reset the model to get the initial animation
    if(items.discRepeater.model === items.numberOfDisc)
        items.discRepeater.model = 0
    items.discRepeater.model = items.numberOfDisc

    for( var i = 0 ; i < items.numberOfDisc ; ++i ) {
        placeDisc(items.discRepeater.itemAt(i), items.tower1Image)
    }
}

function discReleased(index)
{
    var disc = items.discRepeater.itemAt(index)
    if( checkIfDiscOnTowerImage(disc, items.tower1Image) &&
            getNumberOfDiscOnTower(items.tower1Image) < items.numberOfDisc &&
            getHigherfDiscOnTower(items.tower1Image) <= index) {
        placeDisc(disc, items.tower1Image)
    } else if(checkIfDiscOnTowerImage(disc, items.tower2Image) &&
            getNumberOfDiscOnTower(items.tower2Image) < items.numberOfDisc &&
            getHigherfDiscOnTower(items.tower2Image) <= index) {
        placeDisc(disc, items.tower2Image)
    } else if(checkIfDiscOnTowerImage(disc, items.tower3Image) &&
            getNumberOfDiscOnTower(items.tower3Image) < items.numberOfDisc &&
            getHigherfDiscOnTower(items.tower3Image) <= index) {
        placeDisc(disc, items.tower3Image)
    } else {
        // Cancel the drop
        disc.x = items.background.currentX
        disc.y = items.background.currentY
    }

    disableNonDraggablediscs()
    deHighlightTowers()
    checkSolved()
}

function performTowersHighlight(disc, x)
{
    deHighlightTowers()

    if( checkIfDiscOnTowerImage(disc, items.tower1Image) ) {
        items.tower1Image.highlight = true
    } else if( checkIfDiscOnTowerImage(disc, items.tower2Image) ) {
        items.tower2Image.highlight = true
    } else if( checkIfDiscOnTowerImage(disc, items.tower3Image) ) {
        items.tower3Image.highlight = true
    } else {
        disc.towerImage.highlight = true
    }
}

function sceneSizeChanged()
{
    if(!items)
        return

    for( var i = 0 ; i < items.numberOfDisc ; ++i ) {
        var disc = items.discRepeater.itemAt(i)
        var towerImage = items.discRepeater.itemAt(i).towerImage
        disc.x = towerImage.x + towerImage.width / 2 - disc.width / 2
        disc.y = towerImage.y + towerImage.height - (disc.position + 1) * disc.height
    }

    disableNonDraggablediscs()
    deHighlightTowers()
}

function disableNonDraggablediscs()
 {
    for( var i = 0 ; i < items.numberOfDisc ; ++i ) {
        if(getHigherfDiscOnTower(items.discRepeater.itemAt(i).towerImage) > i)
            items.discRepeater.itemAt(i).mouseEnabled = false
        else
            items.discRepeater.itemAt(i).mouseEnabled = true
    }
}

function deHighlightTowers()
 {
    if(items.tower1Image)
        items.tower1Image.highlight = false
    if(items.tower2Image)
        items.tower2Image.highlight = false
    if(items.tower3Image)
        items.tower3Image.highlight = false
}

function checkIfDiscOnTowerImage(disc, towerImage)
{
    return ((disc.x + disc.width / 2) > towerImage.x &&
            (disc.x + disc.width / 2) < towerImage.x + towerImage.width)
}

function getHigherfDiscOnTower(towerImage) {
    var higher = 0
    for( var i = 0 ; i < items.numberOfDisc ; ++i )
    {
        if(items.discRepeater.itemAt(i).towerImage === towerImage)
            higher = i
    }
    return higher
}

function getNumberOfDiscOnTower(towerImage) {
    var count = 0
    for( var i = 0 ; i < items.numberOfDisc ; ++i )
    {
        if(items.discRepeater.itemAt(i).towerImage === towerImage)
            count++
    }
    return count
}

function checkSolved() {
    if(getNumberOfDiscOnTower(items.tower3Image) === items.numberOfDisc)
        items.bonus.good("flower")
}

function getDiscWidth(index)
{
    if( 0 === index ) return items.tower1Image.width * 1.6
    else if ( 1 === index ) return items.tower1Image.width * 1.3
    else if ( 2 === index ) return items.tower1Image.width * 1
    else if ( 3 === index ) return items.tower1Image.width * 0.7
    else return items.tower1Image.width * 0.5
}
