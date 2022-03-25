/* GCompris - Hat.qml
 *
 * SPDX-FileCopyrightText: 2014 Thibaut ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   Thibaut ROMAIN <thibrom@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "magic-hat.js" as Activity

Item {
    id: hatItem
    property alias state: hatImg.state
    property alias target: offStar
    property int starsSize
    property GCSfx audioEffects

    function getTarget() {
        return offStar
    }

    Image {
        id: hatImg
        z: 100
        source: Activity.url + "hat.svg"
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        state: "NormalPosition"

        transform: Rotation {
            id: rotate
            origin.x: 0
            origin.y: hatImg.height
            axis.x: 0
            axis.y: 0
            axis.z: 1
            Behavior on angle {
                animation: rotAnim
            }
        }

        states: [
            State {
                name: "NormalPosition"
                PropertyChanges {
                    target: rotate
                    angle: 0
                }
                PropertyChanges {
                    target: baseRotAnim
                    running: true
                }
            },
            State {
                name: "Rotated"
                PropertyChanges {
                    target: baseRotAnim
                    running: false
                }
                PropertyChanges {
                    target: rotate
                    angle: -45
                }
            },
            State {
                name: "GuessNumber"
                PropertyChanges {
                    target: baseRotAnim
                    running: false
                }
                PropertyChanges{
                    target: hatImg
                    source: Activity.url + "hat-point.svg"
                }
                PropertyChanges {
                    target: rotate
                    angle: 0
                }
            }
        ]

     }

    RotationAnimation {
                id: rotAnim
                direction: hatImg.state == "Rotated" ?
                               RotationAnimation.Counterclockwise :
                               RotationAnimation.Clockwise
                duration: 500
                onRunningChanged: if(!rotAnim.running && hatImg.state == "Rotated") {
                        Activity.moveStarsUnderHat()
                    }
    }

    SequentialAnimation {
          id: baseRotAnim
          running: true
          loops: Animation.Infinite
          NumberAnimation {
              target: hatImg
              property: "rotation"
              from: 0; to: 25
              duration: 500
          }
          NumberAnimation {
              target: hatImg
              property: "rotation"
              from: 25; to: 0
              duration: 500
          }
          NumberAnimation {
              target: hatImg
              property: "rotation"
              from: 0; to: 0
              duration: 2000
          }
          NumberAnimation {
              target: hatImg
              property: "rotation"
              from: 0; to: -25
              duration: 500
          }
          NumberAnimation {
              target: hatImg
              property: "rotation"
              from: -25; to: 0
              duration: 500
          }
          NumberAnimation {
              target: hatImg
              property: "rotation"
              from: 0; to: 0
              duration: 2000
          }
    }

    MouseArea {
        id: hatMouseArea
        anchors.fill:hatImg
        onClicked: {
            if(hatImg.state == "NormalPosition") {
                baseRotAnim.running = false;
                hatImg.rotation = 0;
                hatImg.state = "Rotated";
            }
        }
    }

    // The target for the moving stars
    Item {
        id: offStar
        height: hatItem.starsSize
        width: hatItem.starsSize
        y: hatImg.y + hatImg.paintedHeight - height
        anchors {
            horizontalCenter: parent.horizontalCenter
        }

        z: hatImg.z - 1
    }
}
