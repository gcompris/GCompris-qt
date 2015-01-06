/* GCompris - MagicHat.qml
 *
 * Copyright (C) 2014 <Thibaut ROMAIN>
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
import QtQuick 2.1
import QtGraphicalEffects 1.0
import "magic-hat.js" as Activity


Item {
    id: mainItem
    property bool isClickable: false
    property bool displayBounds: true
    property string wantedColor
    property bool selected: false
    property string disabledColor: "grey"
    property Item initialParent
    property Item theHat
    property Item newTarget
    property int barGroupIndex
    property int barIndex
    state: "Init"

    width: 34
    height: 34

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: isClickable
        onClicked: {
            mainItem.selected = !mainItem.selected
            Activity.verifyAnswer(barIndex, mainItem.selected)
        }
    }

    Rectangle {
            id: contour
            width: parent.width
            height: parent.height
            color: "black"
            opacity: displayBounds ? 1.0 : 0.0

            Rectangle {
                id: innerRect
                width: contour.width - 2
                height: contour.height - 2
                anchors.centerIn: contour
                color: mainItem.disabledColor
                opacity: displayBounds? 1.0 : 0.0
            }
    }

    Image {
        id: starImg
        source: Activity.url + "star-clear.svgz"
        width: innerRect.width - 4
        height: innerRect.height - 4
        anchors.centerIn: contour
        fillMode: Image.PreserveAspectFit
        opacity: 1

        ColorOverlay {
            anchors.fill: starImg
            source: starImg
            color: mainItem.selected ?
                       mainItem.wantedColor : mainItem.disabledColor
        }
    }

    states: [
        State {
            name: "Init"
            ParentChange {
                target: mainItem
                parent: mainItem.initialParent
                x: 0
                y: 0
                rotation: 0
            }
            PropertyChanges {
                target: mainItem
                opacity: mainItem.displayBounds ? 1 : 0
            }
        },
        State {
            name: "MoveUnderHat"
            ParentChange {
                target: mainItem
                parent: mainItem.theHat
                x: 0
                y: 0
                rotation: 180
            }
            PropertyChanges {
                target: mainItem
                opacity: 1
            }
        },
        State {
            name: "MoveToTarget"
            ParentChange {
                target: mainItem
                parent: mainItem.newTarget
                x: 0
                y: 0
                rotation: 0
            }
            PropertyChanges {
                target: mainItem
                opacity: 1
            }
        }
    ]

    Behavior on x {
        PropertyAnimation {
            easing.type: Easing.OutQuad
            duration:  1000
            onRunningChanged: {
                if(!running) {
                    if(mainItem.state == "MoveUnderHat")
                        Activity.animation1Finished(mainItem.barGroupIndex)
                    else if(mainItem.state == "MoveToTarget")
                        Activity.animation2Finished()
                }
            }
        }
    }
    Behavior on y {
        PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000}
    }

    Behavior on rotation {
        PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000}
    }
}
