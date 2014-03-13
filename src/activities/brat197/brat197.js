/* GCompris - brat197.js
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

var currentLevel = 0
var numberOfLevel = 4
var main
var bar
var items
var bonus
var height
var width
var text
var img1
var img2
var background
var rectangle
var button
var buttonText
var buttonText1
var button1
var rectangle1
function start(main_, background_, bar_, bonus_, rectangle_, img1_, img2_, text_, button_, button1_, rectangle1_, buttonText_, buttonText1_) {
    console.log("brat197 activity: start")
    main = main_
    background = background_
    text = text_
    bar = bar_
    bonus = bonus_
    img1 = img1_
    img2 = img2_
    rectangle = rectangle_
    currentLevel = 0
    button = button_
    button1 = button1_
    rectangle1 = rectangle1_
    buttonText = buttonText_
    buttonText1 = buttonText1_
    initLevel()
}


function stop() {
    console.log("brat197 activity: stop")
}
var click = 0
var click1 = 0
function handleclick(){
        click++;
        if(rectangle.opacity < 1){
            rectangle.opacity += 0.1
            buttonText.text = 'Keep Clicking!'
        }else{
            buttonText.text = "Stop it is pointless!"
        }

    }

function handleclick1(){
        click1++;
        if(click1<12){
            rectangle1.opacity = 1
            buttonText1.text = "Click to make it bigger!"
            rectangle1.height += 10
            rectangle1.width += 10
        }else{
            buttonText1.text = "Stop! That's as big as it gets!"
        }
}


function initLevel() {

    bar.level = currentLevel + 1


}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
