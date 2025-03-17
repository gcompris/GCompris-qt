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
import core 1.0

import "../../core"
import "magic-hat.js" as Activity


Item {
    id: mainItem
    property bool isClickable: false
    property bool displayBounds: true
    property bool selected: false
    property string backgroundColor
    property real starSize
    property Item initialParent
    property Item theHat
    property Item newTarget
    property int barGroupIndex
    property int barIndex
    property string wantedColor: "1"
    state: "Init"

    width: mainItem.starSize
    height: mainItem.starSize

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: isClickable && !items.inputBlocked
        hoverEnabled: true
        onClicked: {
            mainItem.selected = !mainItem.selected
            Activity.userClickedAStar(barIndex, mainItem.selected)
        }
    }

    Rectangle {
        id: contour
        anchors.fill: parent
        border.color: GCStyle.darkBorder
        border.width: mouseArea.containsMouse ? GCStyle.thinBorder : GCStyle.thinnestBorder
        opacity: displayBounds ? 1.0 : 0.0
        color: mainItem.backgroundColor
    }

    Image {
        id: starImg
        source: mainItem.selected ?
                    Activity.url + "star-" + wantedColor + ".svg" : Activity.url + "star-0.svg"
        width: parent.width - GCStyle.halfMargins
        height: width
        sourceSize.width: width
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        opacity: mainItem.selected ? 1 : 0.1
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
                mainItem {
                    opacity: mainItem.displayBounds ? 1 : 0
                }
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
                mainItem {
                    opacity: 1
                }
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
                mainItem {
                    opacity: 1
                }
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
