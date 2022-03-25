/* GCompris - Controls.qml
 *
 * SPDX-FileCopyrightText: 2017 RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"

Item {
    id: controls

    /* Engine Controller Properties */
    property point enginePosition
    property alias engineWidth : engine.width
    property alias engineHeight : engine.height
    property alias submarineHorizontalSpeed : engineValues.text

    /* Ballast tanks Controller Properties */
    property alias leftTankVisible : leftBallastTankController.visible
    property point leftBallastTankPosition
    property alias leftBallastTankWidth : leftBallastTankDisplay.width
    property alias leftBallastTankHeight : leftBallastTankDisplay.height
    property alias rotateLeftFill: rotateLeftFill
    property alias rotateLeftFlush: rotateLeftFlush

    property alias centralTankVisible : centralBallastTankController.visible
    property point centralBallastTankPosition
    property alias centralBallastTankWidth : centralBallastTankDisplay.width
    property alias centralBallastTankHeight : centralBallastTankDisplay.height
    property alias rotateCentralFill: rotateCentralFill
    property alias rotateCentralFlush: rotateCentralFlush

    property alias rightTankVisible : rightBallastTankController.visible
    property point rightBallastTankPosition
    property alias rightBallastTankWidth : rightBallastTankDisplay.width
    property alias rightBallastTankHeight : rightBallastTankDisplay.height
    property alias rotateRightFill: rotateRightFill
    property alias rotateRightFlush: rotateRightFlush

    /* Diving Plane Controller properties */
    property bool divingPlaneVisible
    property point divingPlanePosition
    property int divingPlaneWidth
    property int divingPlaneHeight

    property int buttonSize
    property int buttonPlusY
    property int buttonMinusY

    property string fillColor : "#0DA5CB"

    Image {
        id: controlBackground
        source: url + "board.svg"
        width: background.width
        height: background.height * 0.40
        sourceSize.width: controlBackground.width
        sourceSize.height: controlBackground.height
        y: background.height - controlBackground.height
    }

    Item {
        Rectangle {
            id: engine
            x: enginePosition.x
            y: enginePosition.y
            radius: 10
            color: "#323232"
            border.width: 4
            border.color: "#AEC6DD"
            GCText {
                id: engineValues
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                color: "#D3E1EB"
            }
        }
        Image {
            id: incSpeed
            source: url + "up.svg"
            width: buttonSize
            height: buttonSize
            sourceSize.width: incSpeed.width
            sourceSize.height: incSpeed.height

            anchors {
                right: engine.left
                leftMargin: incSpeed.width / 2
            }
            y: buttonPlusY

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: submarine.increaseHorizontalVelocity(1)
            }
        }

        Image {
            id: downSpeed
            source: url + "down.svg"
            width: buttonSize
            height: buttonSize
            sourceSize.width: downSpeed.width
            sourceSize.height: downSpeed.height

            anchors {
                right: engine.left
                leftMargin: downSpeed.width / 2
            }
            y: buttonMinusY

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: submarine.decreaseHorizontalVelocity(1)
            }
        }
    }

    // 3 Ballast Tanks

    Item {
        id: leftBallastTankController
        Rectangle {
            id: leftBallastTankDisplay
            x: leftBallastTankPosition.x
            y: leftBallastTankPosition.y

            radius: 2

            color: "#323232"
            border.width: 4
            border.color: "#AEC6DD"

            Rectangle {
                width: leftBallastTankWidth * 0.85
                height: (leftBallastTank.waterLevel / leftBallastTank.maxWaterLevel) * (leftBallastTankHeight - 8)
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: 4
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
                anchors.fill: leftBallastTankDisplay
                anchors.margins: 4
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.Fit
                minimumPixelSize: 8
                font.pixelSize: 70
                color: "#B8D3E1EB"
            }
        }

        Image {
            id: leftBallastFill
            source: url + "vanne.svg"

            x: leftBallastTankDisplay.x - buttonSize * 1.1
            y: buttonPlusY
            width: buttonSize
            height: buttonSize
            sourceSize.width: buttonSize
            sourceSize.height: buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateLeftFill;
                origin.x: leftBallastFill.width / 2;
                origin.y: leftBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
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

            x: leftBallastTankDisplay.x - buttonSize * 1.1
            y: buttonMinusY
            width: buttonSize
            height: buttonSize
            sourceSize.width: buttonSize
            sourceSize.height: buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateLeftFlush;
                origin.x: leftBallastFill.width / 2;
                origin.y: leftBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
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

        Rectangle {
            id: centralBallastTankDisplay
            x: centralBallastTankPosition.x
            y: centralBallastTankPosition.y

            radius: 2

            color: "#323232"
            border.width: 4
            border.color: "#AEC6DD"

            Rectangle {
                width: centralBallastTankWidth * 0.85
                height: (centralBallastTank.waterLevel / centralBallastTank.maxWaterLevel) * (centralBallastTankHeight - 8)
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: 4
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
                anchors.margins: 4
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.Fit
                minimumPixelSize: 8
                font.pixelSize: 70
                color: "#B8D3E1EB"
            }
        }

        Image {
            id: centralBallastFill
            source: url + "vanne.svg"

            x: centralBallastTankDisplay.x - buttonSize * 1.1
            y: buttonPlusY
            width: buttonSize
            height: buttonSize
            sourceSize.width: buttonSize
            sourceSize.height: buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateCentralFill;
                origin.x: centralBallastFill.width / 2;
                origin.y: centralBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
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

            x: centralBallastTankDisplay.x - buttonSize * 1.1
            y: buttonMinusY
            width: buttonSize
            height: buttonSize
            sourceSize.width: buttonSize
            sourceSize.height: buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateCentralFlush;
                origin.x: centralBallastFill.width / 2;
                origin.y: centralBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
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

        Rectangle {
            id: rightBallastTankDisplay
            x: rightBallastTankPosition.x
            y: rightBallastTankPosition.y

            radius: 2

            color: "#323232"
            border.width: 4
            border.color: "#AEC6DD"

            Rectangle {
                width: rightBallastTankWidth * 0.85
                height: (rightBallastTank.waterLevel / rightBallastTank.maxWaterLevel) * (rightBallastTankHeight - 8)
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: 4
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
                anchors.margins: 4
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.Fit
                minimumPixelSize: 8
                font.pixelSize: 70
                color: "#B8D3E1EB"
            }
        }

        Image {
            id: rightBallastFill
            source: url + "vanne.svg"

            x: rightBallastTankDisplay.x - buttonSize * 1.1
            y: buttonPlusY
            width: buttonSize
            height: buttonSize
            sourceSize.width: buttonSize
            sourceSize.height: buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateRightFill;
                origin.x: rightBallastFill.width / 2;
                origin.y: rightBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
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

            x: rightBallastTankDisplay.x - buttonSize * 1.1
            y: buttonMinusY
            width: buttonSize
            height: buttonSize
            sourceSize.width: buttonSize
            sourceSize.height: buttonSize
            rotation: 0

            transform: Rotation {
                id: rotateRightFlush;
                origin.x: rightBallastFill.width / 2;
                origin.y: rightBallastFill.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 0
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
        id: divingPlaneController
        visible: divingPlaneVisible

        property int maxRotationAngle: 30

        Image {
            id: divingPlanesImage
            source: url + "rudder.svg"
            width: divingPlaneWidth
            height: divingPlaneHeight
            sourceSize.width: divingPlaneWidth
            sourceSize.height: divingPlaneHeight
            x: divingPlanePosition.x
            y: divingPlanePosition.y

            transform: Rotation {
                id: rotateDivingPlanes;
                origin.x: divingPlanesImage.width;
                origin.y: divingPlanesImage.height / 2
                axis { x: 0; y: 0; z: 1 } angle: (submarine.wingsAngle / submarine.maxWingsAngle) * divingPlaneController.maxRotationAngle
            }
        }

        Image {
            id: divingPlanesRotateUp
            source: url + "up.svg"
            width: buttonSize
            height: buttonSize
            sourceSize.width: buttonSize
            sourceSize.height: buttonSize

            anchors {
                left: divingPlanesImage.right
            }
            y: buttonPlusY

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: submarine.increaseWingsAngle(1)
            }
        }

        Image {
            id: divingPlanesRotateDown
            source: url + "down.svg"
            width: buttonSize
            height: buttonSize
            sourceSize.width: buttonSize
            sourceSize.height: buttonSize

            anchors {
                left: divingPlanesImage.right
            }
            y: buttonMinusY

            MouseArea {
                anchors.fill: parent
                enabled: !tutorial.visible

                onClicked: submarine.decreaseWingsAngle(1)
            }
        }
    }
}
