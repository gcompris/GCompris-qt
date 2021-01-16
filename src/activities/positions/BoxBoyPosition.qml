/* GCompris - BoxBoyPosition.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.6
import GCompris 1.0
import "positions.js" as Activity

Image {
    id: backgroundScreen
    property int checkState

    Image {
        id: boy
        source: "qrc:/gcompris/src/activities/positions/resource/boy.svg"
        anchors.margins: 5 * ApplicationInfo.ratio
        sourceSize.width: backgroundScreen.width * 0.2
        sourceSize.height: backgroundScreen.height * 0.5
        fillMode: Image.PreserveAspectCrop
    }

    Image {
        id: backSide
        source: "qrc:/gcompris/src/activities/positions/resource/back_side.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.width: backgroundScreen.width * 0.1
        sourceSize.height: backgroundScreen.height * 0.4
        fillMode: Image.PreserveAspectCrop
    }

    Image {
        id: frontSide
        source: "qrc:/gcompris/src/activities/positions/resource/front_side.svg"
        anchors.centerIn: backSide
        sourceSize.width: backgroundScreen.width * 0.1
        sourceSize.height: backgroundScreen.height * 0.4
        fillMode: Image.PreserveAspectCrop
    }

    Image {
        id: leftSide
        source: "qrc:/gcompris/src/activities/positions/resource/left_side.svg"
        anchors.centerIn: frontSide
        sourceSize.width: backgroundScreen.width * 0.09
        sourceSize.height: backgroundScreen.height * 0.4
        fillMode: Image.PreserveAspectCrop
    }

    Image {
        id: rightSide
        source: "qrc:/gcompris/src/activities/positions/resource/right_side.svg"
        anchors.centerIn: backSide
        sourceSize.width: backgroundScreen.width * 0.09
        sourceSize.height: backgroundScreen.height * 0.4
        fillMode: Image.PreserveAspectCrop
    }

    Image {
        id: topSide
        source: "qrc:/gcompris/src/activities/positions/resource/top_side.svg"
        anchors.centerIn: backSide
        sourceSize.width: backgroundScreen.width * 0.3
        sourceSize.height: backgroundScreen.height * 0.4
        fillMode: Image.PreserveAspectCrop
    }

    states: [
        State {
            name: "underPosition"
            when: checkState === Activity.underPosition
            AnchorChanges {
                target: boy
                anchors.horizontalCenter: frontSide.horizontalCenter
                anchors.top: topSide.verticalCenter
                anchors.bottom: undefined
                anchors.left: undefined
                anchors.right: undefined
            }
            PropertyChanges {
                target: boy
                z: 1
                y: 0.01 * ApplicationInfo.ratio
            }
            PropertyChanges {
                target: frontSide
                z: 2
            }
            PropertyChanges {
                target: leftSide
                z: 2
            }
        },
        State {
            name: "rightPosition"
            when: checkState === Activity.rightPosition
            AnchorChanges {
                target: boy
                anchors.verticalCenter: frontSide.verticalCenter
                anchors.left: frontSide.right
                anchors.bottom: undefined
                anchors.top: undefined
                anchors.right: undefined
            }
        },
        State {
            name: "leftPosition"
            when: checkState === Activity.leftPosition
            AnchorChanges {
                target: boy
                anchors.verticalCenter: frontSide.verticalCenter
                anchors.right: frontSide.left
                anchors.left: undefined
                anchors.top: undefined
                anchors.bottom: undefined
            }
        },
        State {
            name: "abovePosition"
            when: checkState === Activity.abovePosition
            AnchorChanges {
                target: boy
                anchors.bottom: topSide.verticalCenter
                anchors.horizontalCenter: frontSide.horizontalCenter
                anchors.top: undefined
                anchors.left: undefined
                anchors.right: undefined
            }
            PropertyChanges {
                target: boy
                z: 1
            }
            PropertyChanges {
                target: frontSide
                z: 2
            }
            PropertyChanges {
                target: leftSide
                z: 2
            }
        },
        State {
            name: "insidePosition"
            when: checkState === Activity.insidePosition
            AnchorChanges {
                target: boy
                anchors.horizontalCenter: backgroundScreen.horizontalCenter
                anchors.bottom: backSide.bottom
                anchors.top: undefined
                anchors.left: undefined
                anchors.right: undefined
            }
            PropertyChanges {
                target: boy
                z: 1
            }
            PropertyChanges {
                target: frontSide
                z: 2
            }
            PropertyChanges {
                target: leftSide
                z: 2
            }
        },
        State {
            name: "behindPosition"
            when: checkState === Activity.behindPosition
            AnchorChanges {
                target: boy
                anchors.horizontalCenter: backgroundScreen.horizontalCenter
                anchors.bottom: backSide.verticalCenter
                anchors.top: undefined
                anchors.left: undefined
                anchors.right: undefined
            }
            PropertyChanges {
                target: boy
                z: 0
            }
            PropertyChanges {
                target: backSide
                z: 1
            }
            PropertyChanges {
                target: rightSide
                z: 1
            }
            PropertyChanges {
                target: leftSide
                z: 1
            }
            PropertyChanges {
                target: frontSide
                z: 1
            }
        },
        State {
            name: "inFrontOfPosition"
            when: checkState === Activity.inFrontOfPosition
            AnchorChanges {
                target: boy
                anchors.horizontalCenter: backgroundScreen.horizontalCenter
                anchors.top: frontSide.verticalCenter
                anchors.bottom: undefined
                anchors.left: undefined
                anchors.right: undefined
            }
            PropertyChanges {
                target: boy
                z: 1
            }
            PropertyChanges {
                target: frontSide
                z: 0
            }
            PropertyChanges {
                target: leftSide
                z: 0
            }
            PropertyChanges {
                target: backSide
                z: 0
            }
            PropertyChanges {
                target: rightSide
                z: 0
            }
        }
    ]
}
