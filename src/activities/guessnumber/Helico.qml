/* GCompris - guessnumber.qml
 *
 * SPDX-FileCopyrightText: 2014 Thib ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import "../../core"

Image {
    id: helico
    source: "qrc:/gcompris/src/activities/planegame/resource/tuxhelico.svg"
    fillMode: Image.PreserveAspectFit
    width: height * 1.7
    sourceSize.height: height
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: (parent.width - width) * (1 - diffX) + exitOffset
    anchors.verticalCenterOffset: (parent.height - height) * 0.5 * diffY

    property int exitOffset: 0
    property double diffX: 1
    property double diffY: 0

    GCSoundEffect {
        id: helicopterSound
        source: "qrc:/gcompris/src/activities/guessnumber/resource/helicopter.wav"
    }

    function init() {
        exitOffset = 0
        diffX = 1;
        diffY = 0;
    }

    function correctAnswerMove() {
        helicopterSound.play()
        exitOffset = width + numpad.columnWidth;
        diffX = 0;
        diffY = 0;
    }

    Behavior on anchors.leftMargin {
        PropertyAnimation { easing.type: Easing.OutQuad; duration: 1000 }
    }
    Behavior on anchors.verticalCenterOffset {
        PropertyAnimation { easing.type: Easing.OutQuad; duration: 1000 }
    }

    transform: Rotation {
            id: helicoRotation;
            origin.x: helico.width * 0.5;
            origin.y: helico.height * 0.5;
            axis { x: 0; y: 0; z: 1 }
            Behavior on angle {
                animation: rotAnim
            }
    }

    states: [
        State {
            name: "horizontal"
            PropertyChanges {
                helicoRotation {
                    angle: 0
                }
            }
        },
        State {
            name: "advancing"
            PropertyChanges {
                helicoRotation {
                    angle: 25
                }
            }
        }
    ]

    RotationAnimation {
                id: rotAnim
                direction: helico.state == "horizontal" ?
                               RotationAnimation.Counterclockwise :
                               RotationAnimation.Clockwise
                duration: 500
                onRunningChanged: if(!rotAnim.running && helico.state == "advancing")
                                      helico.state = "horizontal"
    }
}


