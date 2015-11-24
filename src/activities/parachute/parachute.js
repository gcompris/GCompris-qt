/* GCompris - parachute.js
 *
 *   Copyright (C) 2015 Rajdeep Kaur <rajdeep1994@gmail.com>
 *
 *    Authors:
 *    Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *    Rajdeep kaur <rajdeep51994@gmail.com> (Qt Quick port)
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
.import GCompris 1.0 as GCompris 
.import "qrc:/gcompris/src/core/core.js" as Core


var currentLevel = 0
var numberOfLevel = 4
var items
var flagofpress = 0
var uppressed
var downpressed

function start(items_) {
    items = items_
    currentLevel = 0

    initLevel()
}

function stop() {
    items.animationheli.stop()
    items.animationcloud.stop()
    items.animationboat.stop()
    items.parachuteanimation.stop()
    items.parachute1Image.visible=false
    items.parachuteImage.visible=false
}

function initLevel() {
    items.bar.level = currentLevel + 1
    flagofpress = 0
    items.animationheli.restart()
    items.animationcloud.restart()
    items.animationboat.restart()
    items.parachuteanimationx.restart()
}

function processPressedKey(event) {
    switch(event.key) {
    case Qt.Key_Up : event.accepted = true;
        if(flagofpress === 0) {
            uppressed = true;
            items.parachuteanimation.stop()
            items.parachuteanimationup.restart()
            flagofpress = 1;
        }
        else {
            uppressed = true;
            items.parachuteanimationrelup.stop()
            items.parachuteanimationup.restart()
        }
        break;
    case Qt.Key_Down : event.accepted = true;
        if(flagofpress === 0) {
            downpressed = true;
            items.parachuteanimation.stop()
            items.parachuteanimationdown.restart()
            flagofpress = 1;
        }
        else {
            downpressed = true;
            items.parachuteanimationreldown.stop()
            items.parachuteanimationdown.restart()
        }

        break;
    }


}

function processReleasedKey(event) {
    switch(event.key) {
    case Qt.Key_Up : event.accepted = true;
        uppressed = false;
        items.parachuteanimationup.stop()
        items.parachuteanimationrelup.restart()

        break;
    case Qt.Key_Down : event.accepted = true;
        downpressed = false;
        items.parachuteanimationdown.stop()
        items.parachuteanimationreldown.restart()
        break;
    }

}

function parachuefun(){
    items.parachuteanimationx.stop()
    items.parachuteanimation.restart()
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    items.keyunable.visible=false
    items.parachuteImage.visible=false
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
