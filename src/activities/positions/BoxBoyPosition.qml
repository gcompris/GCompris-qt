/* GCompris - BoxBoyPosition.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0
import "positions.js" as Activity

Item {
    id: backgroundPosition
    property int checkState
    readonly property real boxSize: width * 0.4
    height: width

    Image {
        id: boy
        z: 0
        source: "qrc:/gcompris/src/activities/positions/resource/boy.svg"
        height: backgroundPosition.boxSize * 0.75
        width: height
        sourceSize.height: height
        sourceSize.width: height
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: backSide.verticalCenter
        anchors.horizontalCenter: backSide.horizontalCenter
        anchors.horizontalCenterOffset: 0
        anchors.verticalCenterOffset: 0
    }

    Image {
        id: backSide
        z: 1
        source: "qrc:/gcompris/src/activities/positions/resource/back_side.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.width: backgroundPosition.boxSize
        sourceSize.height: backgroundPosition.boxSize
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: rightSide
        z: 1
        source: "qrc:/gcompris/src/activities/positions/resource/right_side.svg"
        anchors.centerIn: backSide
        sourceSize.width: backgroundPosition.boxSize
        sourceSize.height: backgroundPosition.boxSize
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: leftSide
        z: 10
        source: "qrc:/gcompris/src/activities/positions/resource/left_side.svg"
        anchors.centerIn: backSide
        sourceSize.width: backgroundPosition.boxSize
        sourceSize.height: backgroundPosition.boxSize
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: frontSide
        z: 10
        source: "qrc:/gcompris/src/activities/positions/resource/front_side.svg"
        anchors.centerIn: backSide
        sourceSize.width: backgroundPosition.boxSize
        sourceSize.height: backgroundPosition.boxSize
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: topSide
        z: 10
        source: "qrc:/gcompris/src/activities/positions/resource/top_side.svg"
        anchors.centerIn: backSide
        sourceSize.width: backgroundPosition.boxSize
        sourceSize.height: backgroundPosition.boxSize
        fillMode: Image.PreserveAspectFit
        visible: true
    }

    states: [
        State {
            name: "underPosition"
            when: checkState === Activity.underPosition
            PropertyChanges {
                boy {
                    z: 0
                    anchors.horizontalCenterOffset: 0
                    anchors.verticalCenterOffset: backgroundPosition.boxSize * 0.75
                }
            }
            PropertyChanges {
                topSide {
                    visible: true
                }
            }
        },
        State {
            name: "rightPosition"
            when: checkState === Activity.rightPosition
            PropertyChanges {
                boy {
                    z: 0
                    anchors.horizontalCenterOffset: backgroundPosition.boxSize * 0.75
                    anchors.verticalCenterOffset: backgroundPosition.boxSize * 0.05
                }
            }
            PropertyChanges {
                topSide {
                    visible: true
                }
            }
        },
        State {
            name: "leftPosition"
            when: checkState === Activity.leftPosition
            PropertyChanges {
                boy {
                    z: 15
                    anchors.horizontalCenterOffset: backgroundPosition.boxSize * -0.7
                    anchors.verticalCenterOffset: backgroundPosition.boxSize * 0.05
                }
            }
            PropertyChanges {
                topSide {
                    visible: true
                }
            }
        },
        State {
            name: "abovePosition"
            when: checkState === Activity.abovePosition
            PropertyChanges {
                boy {
                    z: 15
                    anchors.horizontalCenterOffset: backgroundPosition.boxSize * -0.05
                    anchors.verticalCenterOffset: backgroundPosition.boxSize * -0.7
                }
            }
            PropertyChanges {
                topSide {
                    visible: true
                }
            }
        },
        State {
            name: "insidePosition"
            when: checkState === Activity.insidePosition
            PropertyChanges {
                boy {
                    z: 5
                    anchors.horizontalCenterOffset: backgroundPosition.boxSize * -0.05
                    anchors.verticalCenterOffset: backgroundPosition.boxSize * -0.25
                }
            }
            PropertyChanges {
                topSide {
                    visible: false
                }
            }
        },
        State {
            name: "behindPosition"
            when: checkState === Activity.behindPosition
            PropertyChanges {
                boy {
                    z: 0
                    anchors.horizontalCenterOffset: backgroundPosition.boxSize * -0.15
                    anchors.verticalCenterOffset: backgroundPosition.boxSize * -0.5
                }
            }
            PropertyChanges {
                topSide {
                    visible: true
                }
            }
        },
        State {
            name: "inFrontOfPosition"
            when: checkState === Activity.inFrontOfPosition
            PropertyChanges {
                boy {
                    z: 15
                    anchors.horizontalCenterOffset: backgroundPosition.boxSize * 0.15
                    anchors.verticalCenterOffset: backgroundPosition.boxSize * 0.25
                }
            }
            PropertyChanges {
                topSide {
                    visible: true
                }
            }
        }
    ]
}
