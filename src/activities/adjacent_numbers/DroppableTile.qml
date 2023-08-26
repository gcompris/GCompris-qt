/* GCompris - DroppableTile.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12

import GCompris 1.0
import "../../core"
import "adjacent_numbers.js" as Activity

Rectangle {
    signal tileChanged(string newValue)

    id: orderingElement
    width: 80 * ApplicationInfo.ratio
    height: width
    color: "white"
    opacity: value === '?' ? 0.7 : 1
    border.width: width / 20
    radius: 10
    state: tileState

    GCText {
        id: valueText
        text: value

        anchors {
            top: parent.top
            left: parent.left
            leftMargin: (parent.width - width) / 2
        }
        padding: 5 * ApplicationInfo.ratio
        height: parent.height

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (canDrop && value !== '?') {
                tileChanged('?')
            }
        }
    }

    DropArea {
        id: valueDropArea

        anchors.fill: parent

        // Drop enabled only for
        enabled: canDrop
        keys: ""

        onDropped: {
            tileState = "NONE" // Force reset of the transition animation
            tileChanged(drag.source.valueText) // Will put the appropriate state back
        }
    }

    states: [
        State {
            name: "NONE"
            PropertyChanges { target: orderingElement; border.color: canDrop ? "white" : "black"}
        },
        State {
            name: "ANSWERED"
            PropertyChanges { target: orderingElement; border.color: "blue"}
        },
        State {
            name: "RIGHT"
            PropertyChanges { target: orderingElement; border.color: "green"}
        },
        State {
            name: "WRONG"
            PropertyChanges { target: orderingElement; border.color: "red"}
        }
    ]

    transitions: [
        Transition {
            to: "RIGHT"
            SequentialAnimation {
                PropertyAnimation { target: orderingElement; property: "scale"; to: 1.2; duration: 300; easing.type: Easing.InOutQuad }
                PropertyAnimation { target: orderingElement; property: "scale"; to: 1.0; duration: 150; easing.type: Easing.InOutQuad }
            }
        },
        Transition {
            to: "WRONG"
            SequentialAnimation {
                RotationAnimation { target: orderingElement; from: 0; to: 25; duration: 50; direction: RotationAnimation.Clockwise }
                RotationAnimation { target: orderingElement; from: 25; to: -25; duration: 50; direction: RotationAnimation.Counterclockwise }
                RotationAnimation { target: orderingElement; from: -25; to: 15; duration: 50; direction: RotationAnimation.Clockwise }
                RotationAnimation { target: orderingElement; from: 15; to: -15; duration: 50; direction: RotationAnimation.Counterclockwise }
                RotationAnimation { target: orderingElement; from: -15; to: 10; duration: 20; direction: RotationAnimation.Clockwise }
                RotationAnimation { target: orderingElement; from: 10; to: 0; duration: 20; direction: RotationAnimation.Counterclockwise }
            }
        }
    ]
}
