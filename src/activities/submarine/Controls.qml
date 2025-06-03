/* GCompris - Controls.qml
 *
 * SPDX-FileCopyrightText: 2017 RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../../core"

Item {
    id: controls
    /* Engine Controller Properties */
    property alias submarineHorizontalSpeed : engineValues.text

    /* Ballast tanks Controller Properties */
    property alias leftTankVisible : leftBallastTankController.visible
    property alias rotateLeftFill: rotateLeftFill
    property alias rotateLeftFlush: rotateLeftFlush

    property alias centralTankVisible : centralBallastTankController.visible
    property alias rotateCentralFill: rotateCentralFill
    property alias rotateCentralFlush: rotateCentralFlush

    property alias rightTankVisible : rightBallastTankController.visible
    property alias rotateRightFill: rotateRightFill
    property alias rotateRightFlush: rotateRightFlush

    /* Diving Plane Controller properties */
    property bool divingPlaneVisible

    readonly property int buttonSize: Math.min(height / 2.5,
                                        (width - 3 * GCStyle.baseMargins) / 16)
    readonly property color fillColor : "#0DA5CB"

    Item {
        id: engineArea
        anchors.left: parent.left
        anchors.right: ballastArea.left
        anchors.rightMargin: GCStyle.baseMargins
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
    Item {
        id: engineGroup
        width: buttonSize * 4
        height: buttonSize * 2.5
        anchors.horizontalCenter: engineArea.horizontalCenter
        anchors.top: parent.top
        Image {
            id: incSpeed
            source: url + "up.svg"
            width: controls.buttonSize
            height: controls.buttonSize
            sourceSize.width: controls.buttonSize
            sourceSize.height: controls.buttonSize
            anchors {
                left: parent.left
                top: parent.top
            }

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible
                onClicked: submarine.increaseHorizontalVelocity(1)
            }
        }

        Image {
            id: downSpeed
            source: url + "down.svg"
            width: controls.buttonSize
            height: controls.buttonSize
            sourceSize.width: controls.buttonSize
            sourceSize.height: controls.buttonSize
            anchors {
                left: parent.left
                bottom: parent.bottom
            }

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: submarine.decreaseHorizontalVelocity(1)
            }
        }
        Rectangle {
            id: engine
            anchors.left: incSpeed.right
            width: controls.buttonSize * 3
            height: parent.height
            radius: GCStyle.tinyMargins
            color: GCStyle.darkBg
            border.width: GCStyle.thinBorder
            border.color: "#AEC6DD"
            GCText {
                id: engineValues
                anchors.fill: parent
                anchors.margins: GCStyle.halfMargins
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                color: GCStyle.lightText
            }
        }
    }

    Item {
        id: ballastArea
        width: controls.buttonSize * 8 + GCStyle.baseMargins
        height: controls.buttonSize * 2.5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }

    // 3 Ballast Tanks

    Item {
        id: leftBallastTankController
        width: engineGroup.width
        height: engineGroup.height
        anchors.left: ballastArea.left
        anchors.top: ballastArea.top
        Rectangle {
            id: leftBallastTankDisplay
            anchors.right: parent.right
            anchors.top: parent.top
            width: engine.width
            height: engine.height
            radius: GCStyle.tinyMargins
            color: GCStyle.darkBg
            border.width: GCStyle.thinBorder
            border.color: "#AEC6DD"

            Rectangle {
                width: parent.width - GCStyle.halfMargins
                height: (leftBallastTank.waterLevel / leftBallastTank.maxWaterLevel) *
                    (parent.height - GCStyle.thinBorder * 2)
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: GCStyle.tinyMargins
                }
                color: fillColor

                Behavior on height {
                    NumberAnimation {
                        duration: 1000
                    }
                }
            }

            GCText {
                id: leftBallastTankLabel
                text: qsTr("Left Ballast Tank")
                wrapMode: Text.WordWrap
                anchors.fill: parent
                anchors.margins: GCStyle.halfMargins
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                color: GCStyle.lightText
            }
        }

        Image {
            id: leftBallastFill
            source: url + "vanne.svg"
            anchors.left: parent.left
            anchors.top: parent.top
            width: controls.buttonSize
            height: controls.buttonSize
            sourceSize.width: controls.buttonSize
            sourceSize.height: controls.buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateLeftFill;
                origin.x: leftBallastFill.width * 0.5
                origin.y: leftBallastFill.height * 0.5
                axis { x: 0; y: 0; z: 1 }
                angle: 0
            }

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: {
                    leftBallastTank.fillBallastTanks()
                    updateVannes(leftBallastTank.waterFilling, rotateLeftFill)
                }
            }
        }

        Image {
            id: leftBallastFlush
            source: url + "vanne.svg"
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: controls.buttonSize
            height: controls.buttonSize
            sourceSize.width: controls.buttonSize
            sourceSize.height: controls.buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateLeftFlush;
                origin.x: leftBallastFill.width * 0.5
                origin.y: leftBallastFill.height * 0.5
                axis { x: 0; y: 0; z: 1 }
                angle: 0
            }

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: {
                    leftBallastTank.flushBallastTanks()
                    updateVannes(leftBallastTank.waterFlushing, rotateLeftFlush)
                }
            }
        }
    }


    Item {
        id: centralBallastTankController
        width: engineGroup.width
        height: engineGroup.height
        anchors.top: parent.top
        anchors.horizontalCenter: ballastArea.horizontalCenter
        Rectangle {
            id: centralBallastTankDisplay
            width: engine.width
            height: engine.height
            anchors.right: parent.right
            anchors.top: parent.top
            radius: GCStyle.tinyMargins
            color: GCStyle.darkBg
            border.width: GCStyle.thinBorder
            border.color: "#AEC6DD"

            Rectangle {
                width: parent.width - GCStyle.halfMargins
                height: (centralBallastTank.waterLevel / centralBallastTank.maxWaterLevel) *
                    (parent.height - GCStyle.thinBorder * 2)
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: GCStyle.thinBorder
                }
                color: fillColor

                Behavior on height {
                    NumberAnimation {
                        duration: 1000
                    }
                }
            }

            GCText {
                id: centralBallastTankLabel
                text: qsTr("Central Ballast Tank")
                wrapMode: Text.WordWrap
                anchors.fill: centralBallastTankDisplay
                anchors.margins: GCStyle.halfMargins
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                color: GCStyle.lightText
            }
        }

        Image {
            id: centralBallastFill
            source: url + "vanne.svg"
            anchors.left: parent.left
            anchors.top: parent.top
            width: controls.buttonSize
            height: controls.buttonSize
            sourceSize.width: controls.buttonSize
            sourceSize.height: controls.buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateCentralFill;
                origin.x: centralBallastFill.width * 0.5
                origin.y: centralBallastFill.height * 0.5
                axis { x: 0; y: 0; z: 1 }
                angle: 0
            }

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: {
                    centralBallastTank.fillBallastTanks()
                    updateVannes(centralBallastTank.waterFilling, rotateCentralFill)
                }
            }
        }

        Image {
            id: centralBallastFlush
            source: url + "vanne.svg"
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: controls.buttonSize
            height: controls.buttonSize
            sourceSize.width: controls.buttonSize
            sourceSize.height: controls.buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateCentralFlush;
                origin.x: centralBallastFill.width * 0.5
                origin.y: centralBallastFill.height * 0.5
                axis { x: 0; y: 0; z: 1 }
                angle: 0
            }

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: {
                    centralBallastTank.flushBallastTanks()
                    updateVannes(centralBallastTank.waterFlushing, rotateCentralFlush)
                }
            }
        }
    }

    Item {
        id: rightBallastTankController
        width: engineGroup.width
        height: engineGroup.height
        anchors.right: ballastArea.right
        anchors.top: parent.top

        Rectangle {
            id: rightBallastTankDisplay
            anchors.right: parent.right
            anchors.top: parent.top
            width: engine.width
            height: engine.height
            radius: GCStyle.tinyMargins
            color: GCStyle.darkBg
            border.width: GCStyle.thinBorder
            border.color: "#AEC6DD"

            Rectangle {
                width: parent.width - GCStyle.halfMargins
                height: (rightBallastTank.waterLevel / rightBallastTank.maxWaterLevel) * (parent.height - GCStyle.thinBorder * 2)
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: GCStyle.thinBorder
                }
                color: fillColor

                Behavior on height {
                    NumberAnimation {
                        duration: 1000
                    }
                }
            }

            GCText {
                id: rightBallastTankLabel
                text: qsTr("Right Ballast Tank")
                wrapMode: Text.WordWrap
                anchors.fill: rightBallastTankDisplay
                anchors.margins: GCStyle.halfMargins
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                color: GCStyle.lightText
            }
        }

        Image {
            id: rightBallastFill
            source: url + "vanne.svg"
            anchors.left: parent.left
            anchors.top: parent.top
            width: controls.buttonSize
            height: controls.buttonSize
            sourceSize.width: controls.buttonSize
            sourceSize.height: controls.buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateRightFill;
                origin.x: rightBallastFill.width * 0.5
                origin.y: rightBallastFill.height * 0.5
                axis { x: 0; y: 0; z: 1 }
                angle: 0
            }

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: {
                    rightBallastTank.fillBallastTanks()
                    updateVannes(rightBallastTank.waterFilling, rotateRightFill)
                }
            }
        }

        Image {
            id: rightBallastFlush
            source: url + "vanne.svg"
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: controls.buttonSize
            height: controls.buttonSize
            sourceSize.width: controls.buttonSize
            sourceSize.height: controls.buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateRightFlush;
                origin.x: rightBallastFill.width * 0.5
                origin.y: rightBallastFill.height * 0.5
                axis { x: 0; y: 0; z: 1 }
                angle: 0
            }

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: {
                    rightBallastTank.flushBallastTanks()
                    updateVannes(rightBallastTank.waterFlushing, rotateRightFlush)
                }
            }
        }
    }

    PropertyAnimation {
        id: ballastTankOnAnim
        properties: "angle"
        from: 0
        to: 90
        duration: 200
    }

    PropertyAnimation {
        id: ballastTankOffAnim
        properties: "angle"
        from: 90
        to: 0
        duration: 200
    }

    function updateVannes(vanneOnCondition, animationTarget) {
        if (vanneOnCondition) {
            ballastTankOnAnim.target = animationTarget
            ballastTankOnAnim.start()
        } else {
            ballastTankOffAnim.target = animationTarget
            ballastTankOffAnim.start()
        }
    }

    function resetVannes() {
        if (leftTankVisible) {
            rotateLeftFill.angle = 0
            rotateLeftFlush.angle = 0
        }
        if (centralTankVisible) {
            rotateCentralFill.angle = 0
            rotateCentralFlush.angle = 0
        }
        if (rightTankVisible) {
            rotateRightFill.angle = 0
            rotateRightFlush.angle = 0
        }
    }

    Item {
        id: divingPlaneArea
        anchors.left: ballastArea.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: GCStyle.baseMargins
    }

    Item {
        id: divingPlaneController
        width: engineGroup.width
        height: engineGroup.height
        anchors.horizontalCenter: divingPlaneArea.horizontalCenter
        anchors.top: parent.top
        visible: divingPlaneVisible

        property int maxRotationAngle: 30

        Image {
            id: divingPlanesImage
            source: url + "rudder.svg"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: engine.width
            height: controls.buttonSize
            sourceSize.width: width
            sourceSize.height: height

            transform: Rotation {
                id: rotateDivingPlanes;
                origin.x: divingPlanesImage.width
                origin.y: divingPlanesImage.height * 0.5
                axis { x: 0; y: 0; z: 1 }
                angle: (submarine.wingsAngle / submarine.maxWingsAngle) *
                    divingPlaneController.maxRotationAngle
            }
        }

        Image {
            id: divingPlanesRotateUp
            source: url + "up.svg"
            width: controls.buttonSize
            height: controls.buttonSize
            sourceSize.width: controls.buttonSize
            sourceSize.height: controls.buttonSize
            anchors {
                right: parent.right
                top: parent.top
            }

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: submarine.increaseWingsAngle(1)
            }
        }

        Image {
            id: divingPlanesRotateDown
            source: url + "down.svg"
            width: controls.buttonSize
            height: controls.buttonSize
            sourceSize.width: controls.buttonSize
            sourceSize.height: controls.buttonSize
            anchors {
                right: parent.right
                bottom: parent.bottom
            }

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: submarine.decreaseWingsAngle(1)
            }
        }
    }
}
