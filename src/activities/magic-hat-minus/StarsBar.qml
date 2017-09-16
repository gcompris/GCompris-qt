/* GCompris - MagicHat.qml
 *
 * Copyright (C) 2014 Thibaut ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   <Bruno Coudoin> (GTK+ version)
 *   Thibaut ROMAIN <thibrom@gmail.com> (Qt Quick port)
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
import QtQuick 2.6
import "magic-hat.js" as Activity

Item {
    id: item
    height: starsSize
    property int barGroupIndex
    property int barIndex
    property int nbStarsOn: 0
    property bool authorizeClick: false
    property int starsSize
    property string backgroundColor
    property string starsColor: "1"
    property Item theHat
    property alias repeaterStars: repeaterStars

    Row {
        id: rowlayout
        height: item.height
        spacing: 5
        Repeater {
            id: repeaterStars
            model: item.opacity == 1 ? 10 : 0
            Item {
                id: star
                width: item.starsSize
                height: item.starsSize
                property alias starFixed: starFixed
                property alias starToMove: starToMove
                Star {
                    id: starFixed
                    barGroupIndex: item.barGroupIndex
                    barIndex: item.barIndex
                    backgroundColor: item.backgroundColor
                    wantedColor: starsColor
                    selected: index < nbStarsOn ? true : false
                    width: item.starsSize
                    height: item.starsSize
                    displayBounds: true
                    isClickable: item.authorizeClick
                }
                Star {
                    id: starToMove
                    barGroupIndex: item.barGroupIndex
                    backgroundColor: item.backgroundColor
                    wantedColor: starsColor
                    selected: index < nbStarsOn ? true : false
                    width: item.starsSize
                    height: item.starsSize
                    displayBounds: false
                    isClickable: false
                    enabled: selected ? true : false
                    initialParent: star
                    theHat: item.theHat.target
                }
            }
        }
    }

    function moveStars() {
        activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/smudge.wav")
        for(var i=0; i<nbStarsOn; i++) {
            repeaterStars.itemAt(i).starToMove.state = "MoveUnderHat"
        }
    }

    function moveBackMinusStars(newRootItem, nbStars) {
        for(var i=0; i<nbStars; i++) {
            repeaterStars.itemAt(i).starToMove.newTarget =
                    newRootItem.repeaterStars.itemAt(i)
            repeaterStars.itemAt(i).starToMove.state = "MoveToTarget"
        }
    }

    function initStars() {
        for(var i=0; i<repeaterStars.count; i++) {
            repeaterStars.itemAt(i).starToMove.state = "Init"
        }
    }

    function resetStars() {
        for(var i=0; i<repeaterStars.count; i++) {
            repeaterStars.itemAt(i).starFixed.selected = i < nbStarsOn ? true : false
        }
    }
}
