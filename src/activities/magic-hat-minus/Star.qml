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
    id: mainItem
    property bool isClickable: false
    property bool displayBounds: true
    property bool selected: false
    property string backgroundColor
    property Item initialParent
    property Item theHat
    property Item newTarget
    property int barGroupIndex
    property int barIndex
    property string wantedColor: "1"
    state: "Init"

    width: 34
    height: 34

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: isClickable
        hoverEnabled: true
        onClicked: {
            mainItem.selected = !mainItem.selected
            Activity.userClickedAStar(barIndex, mainItem.selected)
        }
    }

    Rectangle {
        id: contour
        anchors.fill: parent
        border.color: "black"
        border.width: mouseArea.containsMouse ? 2 : 1
        opacity: displayBounds ? 1.0 : 0.0
        color: mainItem.backgroundColor
    }

    Image {
        id: starImg
        source: mainItem.selected ? 
                    Activity.url + "star-" + wantedColor + ".svg" : Activity.url + "star-0.svg"
        sourceSize.width: contour.width - 4
        sourceSize.height: contour.height - 4
        anchors.centerIn: contour
        fillMode: Image.PreserveAspectFit
        opacity: 1
        visible: true
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
