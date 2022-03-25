/* GCompris - MagicHat.qml
 *
 * SPDX-FileCopyrightText: 2014 Thibaut ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   <Bruno Coudoin> (GTK+ version)
 *   Thibaut ROMAIN <thibrom@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "magic-hat.js" as Activity
import "../../core"

Item {
    id: item
    height: starsSize
    property int barGroupIndex
    property int barIndex
    property int nbStarsOn: 0
    property bool authorizeClick: false
    property int coefficient: 1
    property bool coefficientVisible: false
    property int starsSize
    property string backgroundColor
    property string starsColor: "1"
    property Item theHat
    property alias repeaterStars: repeaterStars

    Row {
        id: rowlayout
        height: item.height
        spacing: 5
        GCText {
            id: text
            visible: item.coefficientVisible
            //: text displaying coefficient with which the set of stars is to be multiplied along with multiplication symbol.
            text: qsTr("%1x").arg(item.coefficient)
            fontSizeMode: Text.HorizontalFit
            width: rowlayout.width / 10
            color: "white"
            anchors.rightMargin: 20
            fontSize: tinySize
        }
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
                    wantedColor: coefficientVisible ? "1" : starsColor
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
                    wantedColor: coefficientVisible ? "1" : starsColor
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
