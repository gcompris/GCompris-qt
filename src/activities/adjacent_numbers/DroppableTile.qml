/* GCompris - DroppableTile.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import core 1.0
import "../../core"

Rectangle {
    signal tileChanged(string newValue)

    id: orderingElement
    width: 1
    height: width
    color: value === '?' ? "#80FFFFFF" : "#FFFFFF"
    radius: GCStyle.baseMargins
    state: tileState

    GCText {
        id: valueText
        text: value
        anchors.centerIn: parent
        height: parent.height * 0.6
        width: parent.width * 0.6
        fontSizeMode: Text.Fit
        fontSize: largeSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        anchors.fill: parent
        enabled: items.buttonsEnabled
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
            PropertyChanges { orderingElement { border.color: canDrop ? GCStyle.whiteBorder : orderingElement.color; border.width: GCStyle.thinnestBorder } }
        },
        State {
            name: "ANSWERED"
            PropertyChanges { orderingElement { border.color: GCStyle.answerBorder; border.width: GCStyle.midBorder } }
        },
        State {
            name: "RIGHT"
            PropertyChanges { orderingElement { border.color: GCStyle.goodAnswerBorder; border.width: GCStyle.midBorder } }
        },
        State {
            name: "WRONG"
            PropertyChanges { orderingElement { border.color: GCStyle.badAnswerBorder; border.width: GCStyle.fatBorder } }
        }
    ]

    transitions: [
        Transition {
            to: "RIGHT"
            SequentialAnimation {
                ScriptAction { script: z = 100;}
                PropertyAnimation { target: orderingElement; property: "scale"; to: 1.2; duration: 300; easing.type: Easing.InOutQuad }
                PropertyAnimation { target: orderingElement; property: "scale"; to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
                ScriptAction { script: z = 0;}
            }
        },
        Transition {
            to: "WRONG"
            SequentialAnimation {
                ScriptAction { script: items.questionTilesModel.set(index, { "tileEdited": false, });}
                ScriptAction { script: z = 100;}
                PropertyAnimation { target: orderingElement; property: "border.width"; to: 8 * ApplicationInfo.ratio; duration: 0 }
                RotationAnimation { target: orderingElement; from: 0; to: 25; duration: 100; direction: RotationAnimation.Clockwise }
                RotationAnimation { target: orderingElement; from: 25; to: -25; duration: 100; direction: RotationAnimation.Counterclockwise }
                RotationAnimation { target: orderingElement; from: -25; to: 15; duration: 100; direction: RotationAnimation.Clockwise }
                RotationAnimation { target: orderingElement; from: 15; to: -15; duration: 100; direction: RotationAnimation.Counterclockwise }
                RotationAnimation { target: orderingElement; from: -15; to: 10; duration: 40; direction: RotationAnimation.Clockwise }
                RotationAnimation { target: orderingElement; from: 10; to: 0; duration: 40; direction: RotationAnimation.Counterclockwise }
                ScriptAction { script: z = 0;}
                ScriptAction { script: items.buttonsEnabled = true; }
            }
        },
        Transition {
            to: "NONE"
            SequentialAnimation {
                PropertyAnimation { target: orderingElement; property: "scale"; to: 1; duration: 0 }
                PropertyAnimation { target: orderingElement; property: "rotation"; to: 0; duration: 0 }
            }
        }
    ]
}
