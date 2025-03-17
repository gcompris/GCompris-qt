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
import "../../core"

Item {
    id: starsBar
    property int barGroupIndex
    property int barIndex
    property int nbStarsOn: 0
    property bool authorizeClick: false
    property int coefficient: 1
    property string backgroundColor
    property string starsColor: "1"
    property real starSize
    property Item theHat
    property alias repeaterStars: repeaterStars
    height: starSize

    Row {
        id: rowlayout
        height: parent.height
        spacing: GCStyle.halfMargins
        GCText {
            id: text
            visible: items.coefficientVisible
            //: text displaying coefficient with which the set of stars is to be multiplied along with multiplication symbol.
            text: qsTr("%1x").arg(starsBar.coefficient)
            fontSize: regularSize
            minimumPointSize: 6
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: starsBar.starSize * 2
            height: starsBar.starSize
            color: GCStyle.whiteText
        }
        Repeater {
            id: repeaterStars
            model: starsBar.opacity == 1 ? 10 : 0
            Item {
                id: star
                width: starsBar.starSize
                height: starsBar.starSize
                property alias starFixed: starFixed
                property alias starToMove: starToMove
                Star {
                    id: starFixed
                    starSize: starsBar.starSize
                    barGroupIndex: starsBar.barGroupIndex
                    barIndex: starsBar.barIndex
                    backgroundColor: starsBar.backgroundColor
                    wantedColor: items.coefficientVisible ? "1" : starsColor
                    selected: index < nbStarsOn ? true : false
                    displayBounds: true
                    isClickable: starsBar.authorizeClick
                }
                Star {
                    id: starToMove
                    starSize: starsBar.starSize
                    barGroupIndex: starsBar.barGroupIndex
                    backgroundColor: starsBar.backgroundColor
                    wantedColor: items.coefficientVisible ? "1" : starsColor
                    selected: index < nbStarsOn ? true : false
                    displayBounds: false
                    isClickable: false
                    enabled: selected ? true : false
                    initialParent: star
                    theHat: starsBar.theHat.target
                }
            }
        }
    }

    function moveStars() {
        items.smudgeSound.play()
        for(var i=0; i<nbStarsOn; i++) {
            repeaterStars.itemAt(i).starToMove.state = "MoveUnderHat"
        }
    }

    function moveBackMinusStars(newRootItem, nbStars: int) {
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
