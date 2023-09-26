/* GCompris - submarine.qml
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
import QtQuick.Particles 2.12
import Box2D 2.0
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"
import "submarine.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/submarine/resource/"

    pageComponent: Image {
        id: background
        source: url + "background.svg"
        anchors.fill: parent
        sourceSize.height: parent.height
        sourceSize.width: parent.width

        onWidthChanged: updateOnWidthReset.start()
        onHeightChanged: Activity.resetUpperGate()
        onVisibleChanged: visible ? physicalWorld.running = true :
                                    physicalWorld.running = false

        property bool hori: background.width >= background.height

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: tutorial
        
        /* Testing purposes, A / Left Key => Reduces velocity, D / Right Key => Increases velocity */
        Keys.onPressed: {
            if (event.key === Qt.Key_D || event.key === Qt.Key_Right) {
                submarine.increaseHorizontalVelocity(1)
            }
            if (event.key === Qt.Key_A || event.key === Qt.Key_Left) {
                submarine.decreaseHorizontalVelocity(1)
            }
            if (event.key === Qt.Key_W || event.key === Qt.Key_Up) {
                centralBallastTank.fillBallastTanks()
                controls.updateVannes(centralBallastTank.waterFilling, controls.rotateCentralFill)
            }
            if (event.key === Qt.Key_S || event.key === Qt.Key_Down){
                centralBallastTank.flushBallastTanks()
                controls.updateVannes(centralBallastTank.waterFlushing, controls.rotateCentralFlush)
            }
            if (event.key === Qt.Key_Plus) {
                submarine.increaseWingsAngle(1)
            }
            if (event.key === Qt.Key_Minus) {
                submarine.decreaseWingsAngle(1)
            }

            if (event.key === Qt.Key_R) {
                leftBallastTank.fillBallastTanks()
                controls.updateVannes(leftBallastTank.waterFilling, controls.rotateLeftFill)
            }
            if (event.key === Qt.Key_F) {
                leftBallastTank.flushBallastTanks()
                controls.updateVannes(leftBallastTank.waterFlushing, controls.rotateLeftFlush)
            }

            if (event.key === Qt.Key_T) {
                rightBallastTank.fillBallastTanks()
                controls.updateVannes(rightBallastTank.waterFilling, controls.rotateRightFill)
            }
            if (event.key === Qt.Key_G) {
                rightBallastTank.flushBallastTanks()
                controls.updateVannes(rightBallastTank.waterFlushing, controls.rotateRightFlush)
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias crown: crown
            property alias whale: whale
            property var submarineCategory: Fixture.Category1
            property var crownCategory: Fixture.Category2
            property var whaleCategory: Fixture.Category3
            property var upperGatefixerCategory: Fixture.Category4
            property var lowerGatefixerCategory: Fixture.Category5
            property var shipCategory: Fixture.Category6
            property var rockCategory: Fixture.Category7
            property var maxDepthCategory: Fixture.Category8
            property alias submarine: submarine
            property alias tutorial: tutorial
            property alias upperGate: upperGate
            property alias ship: ship
            property alias controls: controls
            property alias physicalWorld: physicalWorld
            property bool processingAnswer: false
        }

        IntroMessage {
            id: tutorial
            textContainerHeight: 0.5 * parent.height
            z: 100
            onIntroDone: {
                tutorial.visible = false
            }
        }

        onStart: { Activity.start(items) }
        onStop: {
            smoothHorizontalVelocity.stop()
            updateVerticalVelocity.stop()
            removeSparkleTimer.stop()
            updateOnWidthReset.stop()
            Activity.stop()
        }

        World {
            id: physicalWorld
            running: !tutorial.visible && !items.processingAnswer
            gravity: Qt.point(0,0)
            autoClearForces: false
        }

        Item {
            id: waterLevel
            x: 0
            y: background.height / 15
        }

        Rectangle {
            id: maximumWaterDepth

            width: background.width
            height: 10
            color: "transparent"

            y: background.height * 0.65

            Body {
                id: maxDepthBody
                target: maximumWaterDepth
                bodyType: Body.Static
                sleepingAllowed: true
                linearDamping: 0

                fixtures: Box {
                    categories: items.maxDepthCategory
                    collidesWith: items.submarineCategory
                    width: maximumWaterDepth.width
                    height: maximumWaterDepth.height
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Item {
            id: submarine

            z: 1

            property point initialPosition: Qt.point(0,waterLevel.y - submarineImage.height/2)
            property bool isHit: false
            property int terminalVelocityIndex: 75
            property int maxAbsoluteRotationAngle: 15

            /* Maximum depth the submarine can dive when ballast tank is full */
            property real maximumDepthOnFullTanks: maximumWaterDepth.y * 0.45
            property real ballastTankDiveSpeed: 10

            /* Engine properties */
            property point velocity
            property int maximumXVelocity: 5
            property int currentFinalVelocity: 0

            /* Wings property */
            property int wingsAngle
            property int initialWingsAngle: 0
            property int maxWingsAngle: 2
            property int minWingsAngle: -2

            function destroySubmarine() {
                isHit = true
            }

            function resetSubmarine() {
                isHit = false
                submarineImage.reset()

                leftBallastTank.resetBallastTanks()
                rightBallastTank.resetBallastTanks()
                centralBallastTank.resetBallastTanks()

                currentFinalVelocity = 0
                velocity = Qt.point(0,0)
                smoothHorizontalVelocity.stop()
                wingsAngle = initialWingsAngle
            }

            /* While increasing or decreasing, we can't use submarine.velocity.x since it is interpolating */
            function increaseHorizontalVelocity(amount) {
                if (submarine.currentFinalVelocity + amount <= submarine.maximumXVelocity) {
                    submarine.currentFinalVelocity += amount
                    smoothHorizontalVelocity.stop()
                    smoothHorizontalVelocity.setFinalVelocity(submarine.currentFinalVelocity)
                    smoothHorizontalVelocity.setIncreaseVelocity(true)
                    smoothHorizontalVelocity.start()
                }
            }

            function decreaseHorizontalVelocity(amount) {
                if (submarine.currentFinalVelocity - amount >= 0) {
                    submarine.currentFinalVelocity -= amount
                    smoothHorizontalVelocity.stop()
                    smoothHorizontalVelocity.setFinalVelocity(submarine.currentFinalVelocity)
                    smoothHorizontalVelocity.setIncreaseVelocity(false)
                    smoothHorizontalVelocity.start()
                }
            }

            function increaseWingsAngle(amount) {
                if (wingsAngle + amount <= maxWingsAngle) {
                    wingsAngle += amount
                } else {
                    wingsAngle = maxWingsAngle
                }
            }

            function decreaseWingsAngle(amount) {
                if (wingsAngle - amount >= minWingsAngle) {
                    wingsAngle -= amount
                } else {
                    wingsAngle = minWingsAngle
                }
            }

            function changeVerticalVelocity() {
                /* Check if we are currently using diving planes or ballast tanks */
                var isDivingPlanesActive
                if (submarineImage.y > 0 && submarine.velocity.x > 0 && wingsAngle != 0) {
                    /*
                     * Movement due to planes
                     * Movement is affected only when the submarine is moving forward
                     * When the submarine is on the surface, the planes cannot be used
                     */
                    isDivingPlanesActive = true
                } else {
                    isDivingPlanesActive = false
                }

                var yPosition
                if (isDivingPlanesActive) {
                    /* Currently using diving planes */
                    var multiplier
                    if (wingsAngle == 1) {
                        multiplier = 0.6
                    } else if (wingsAngle == 2) {
                        multiplier = 0.8
                    } else if (wingsAngle == -1) {
                        multiplier = 0.2
                    } else if (wingsAngle == -2) {
                        multiplier = 0.1
                    }
                    yPosition = multiplier * maximumWaterDepth.y
                } else {
                    /* Currently under the influence of Ballast Tanks */
                    yPosition = submarineImage.currentWaterLevel / submarineImage.totalWaterLevel * submarine.maximumDepthOnFullTanks

                    if (bar.level >= 7) {
                        var finalAngle = ((rightBallastTank.waterLevel - leftBallastTank.waterLevel) / leftBallastTank.maxWaterLevel) * submarine.maxAbsoluteRotationAngle
                        submarineRotation.angle = finalAngle
                    }
                }
                var depthToMove
                if (submarineImage.y <= submarine.initialPosition.y && yPosition == 0){
                    depthToMove = 0
                }else {
                    depthToMove = yPosition - submarineImage.y
                }
                submarine.velocity.y = ballastTankDiveSpeed * (depthToMove / background.width)
            }

            Timer {
                id: smoothHorizontalVelocity
                running: false
                repeat: true
                interval: 100

                property real finalVelocity
                property real smoothRate: 0.1
                property bool increaseVelocity

                function increaseVelocitySmoothly() {
                    if (submarine.velocity.x + smoothRate > finalVelocity) {
                        submarine.velocity.x = finalVelocity
                        smoothHorizontalVelocity.stop()
                    } else {
                        submarine.velocity.x += smoothRate
                    }
                }

                function decreaseVelocitySmoothly() {
                    if (submarine.velocity.x - smoothRate <= finalVelocity) {
                        submarine.velocity.x = finalVelocity
                        smoothHorizontalVelocity.stop()
                    } else {
                        submarine.velocity.x -= smoothRate
                    }
                }

                function setFinalVelocity(_finalVelocity) {
                    finalVelocity = _finalVelocity
                }

                function setIncreaseVelocity(value) {
                    increaseVelocity = value
                }

                onTriggered: {
                    if (increaseVelocity) {
                        increaseVelocitySmoothly()
                    } else {
                        decreaseVelocitySmoothly()
                    }
                }
            }

            BallastTank {
                id: leftBallastTank
            }

            BallastTank {
                id: rightBallastTank
            }

            BallastTank {
                id: centralBallastTank
            }

            Image {
                id: submarineImage
                source: submarine.isHit ? url + "submarine-broken.svg" : url + "submarine.svg"

                property int currentWaterLevel: bar.level < 7 ? centralBallastTank.waterLevel : leftBallastTank.waterLevel + rightBallastTank.waterLevel
                property int totalWaterLevel: bar.level < 7 ? centralBallastTank.maxWaterLevel : leftBallastTank.maxWaterLevel + rightBallastTank.maxWaterLevel

                width: background.width / 9
                sourceSize.width: submarineImage.width
                fillMode: Image.PreserveAspectFit

                function reset() {
                    x = submarine.initialPosition.x
                    y = submarine.initialPosition.y
                }

                onXChanged: {
                    if (submarineImage.x >= background.width) {
                        Activity.finishLevel(true)
                    }
                }

                transform: Rotation {
                    id: submarineRotation
                    origin.x: submarineImage.width / 2;
                    origin.y: 0;
                    angle: 0;
                    Behavior on angle {
                        NumberAnimation {
                            duration: 1000
                        }
                    }
                }

                Loader {
                    anchors.fill: parent
                    active: ApplicationInfo.hasShader && submarine.velocity.x > 0 && submarineImage.y > 0 && !submarine.isHit
                    sourceComponent: ParticleSystem {
                        anchors.fill: parent
                        Emitter {
                            x: parent.x
                            y: parent.y + parent.height / 1.75
                            width: 1
                            height: 1
                            emitRate: 0.8
                            lifeSpan: 800
                            lifeSpanVariation: 2500
                            acceleration: PointDirection {
                                x: -20
                                xVariation: 5
                                y: 0
                                yVariation: 0
                            }
                            velocity: PointDirection {
                                x: -20
                                xVariation: 10
                                y: 0
                                yVariation: 0
                            }
                            size: 12
                            sizeVariation: 8
                        }

                        ImageParticle {
                            source: "qrc:/gcompris/src/activities/clickgame/resource/bubble.svg"
                        }
                    }
                }
            }

            Body {
                id: submarineBody
                target: submarineImage
                bodyType: Body.Dynamic
                fixedRotation: true
                linearDamping: 0
                linearVelocity: submarine.isHit ? Qt.point(0,0) : submarine.velocity

                fixtures: [
                    Box {
                        id: submarineFixer
                        y: submarineImage.height * 0.50
                        width: submarineImage.width
                        height: submarineImage.height * 0.50
                        categories: items.submarineCategory
                        collidesWith: Fixture.All
                        density: 1
                        friction: 0
                        restitution: 0
                        onBeginContact: {
                            var collidedObject = other.getBody().target

                            if (collidedObject == whale) {
                                whale.hit()
                            }
                            if (collidedObject == crown) {
                                crown.captureCrown()
                            } else {
                                Activity.finishLevel(false)
                            }
                        }
                    },
                    Box {
                        id: submarinePeriscopeFixer
                        x: submarineImage.width * 0.5
                        width: submarineImage.width * 0.25
                        height: submarineImage.height
                        categories: items.submarineCategory
                        collidesWith: Fixture.All
                        density: 1
                        friction: 0
                        restitution: 0
                        onBeginContact: {
                            var collidedObject = other.getBody().target

                            if (collidedObject === whale) {
                                whale.hit()
                            }
                            if (collidedObject === crown) {
                                crown.captureCrown()
                            } else {
                                Activity.finishLevel(false)
                            }
                        }
                    }
                ]
            }

            Timer {
                id: updateVerticalVelocity
                interval: 50
                running: true
                repeat: true

                onTriggered: submarine.changeVerticalVelocity()
            }
        }

        Image {
            id: sparkle
            source: "qrc:/gcompris/src/activities/mining/resource/sparkle.svg"

            x: crown.x
            y: crown.y
            z: 1

            width: crown.width
            height: width * 0.7

            property bool isCaptured: false

            scale: isCaptured ? 1 : 0

            function createSparkle() {
                isCaptured = true

                removeSparkleTimer.start()
            }

            function removeSparkle() {
                isCaptured = false
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                }
            }

            Timer {
                id: removeSparkleTimer
                interval: 3000
                repeat: false
                running: false

                onTriggered: sparkle.removeSparkle()
            }
        }

        Rectangle {
            id: upperGate
            visible: (bar.level > 1) ? true : false
            width: background.width / 18
            height: isGateOpen ? background.height * (5 / 36) : background.height * (5 / 12) + 4
            y: -2
            z: 2
            color: "#9E948A"
            border.color: "#766C62"
            border.width: 2
            anchors.right: background.right
            anchors.rightMargin: -2

            property bool isGateOpen: false

            Body {
                id: upperGateBody
                target: upperGate
                bodyType: Body.Static
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: upperGatefixer
                    width: upperGate.width
                    height: upperGate.height
                    categories: items.upperGatefixerCategory
                    collidesWith: upperGate.visible ? items.submarineCategory : Fixture.None
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }

            Behavior on height {
                NumberAnimation {
                    duration: 1000
                }
            }
        }

        Rectangle {
            id: lowerGate
            z: 1
            visible: upperGate.visible
            width: background.width / 18
            height: background.height * (5 / 12) - subSchemaImage.height / 1.4
            y: background.height * (5 / 12)
            color: "#9E948A"
            border.color: "#766C62"
            border.width: 2
            anchors.right:background.right
            anchors.rightMargin: -2

            Body {
                id: lowerGateBody
                target: lowerGate
                bodyType: Body.Static
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: lowerGatefixer
                    width: lowerGate.width
                    height: lowerGate.height
                    categories: items.lowerGatefixerCategory
                    collidesWith: lowerGate.visible ? items.submarineCategory : Fixture.None
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Rectangle {
            id: subSchemaImage
            width: background.width/1.3
            height: background.height/4
            x: background.width/9
            y: background.height/1.5
            visible: false
        }

        Image {
            id: crown

            width: submarineImage.width * 0.85
            height: crown.width * 0.5
            sourceSize.width: crown.width
            sourceSize.height: crown.height
            visible: ((bar.level > 2) && !isCaptured) ? true : false
            source: url + "crown.svg"

            property bool isCaptured: false

            function captureCrown() {
                upperGate.isGateOpen = true
                isCaptured = true
                sparkle.createSparkle()
            }

            function reset() {
                isCaptured = false
                upperGate.isGateOpen = false
            }

            x: background.width / 2
            y: background.height - (subSchemaImage.height * 2)
            z: 1

            Body {
                id: crownbody
                target: crown
                bodyType: Body.Static
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: crownfixer
                    width: crown.width
                    height: crown.height
                    sensor: true
                    categories: items.crownCategory
                    collidesWith: crown.visible ? items.submarineCategory : Fixture.None
                    density: 0.1
                    friction: 0
                    restitution: 0
                }
            }
        }

        Whale {
            id: whale
            visible: (bar.level > 5) ? true : false

            y: rock2.y - (rock2.height * 1.15)
            z: 1

            leftLimit: 0
            rightLimit: background.width - whale.width - (upperGate.visible ? upperGate.width : 0)
        }

        Image {
            id: ship

            width: background.width / 9
            sourceSize.width: ship.width
            fillMode: Image.PreserveAspectFit

            visible: (bar.level > 3) ? true : false
            source: collided ? url + "boat-hit.svg" : url + "boat.svg"
            x: initialXPosition
            z: 1

            anchors.bottom: waterLevel.top

            property bool movingLeft: true
            property bool collided: false
            property real initialXPosition: background.width - ship.width - (upperGate.visible ? upperGate.width : 0)
            property real horizontalSpeed: 1

            function reset() {
                ship.collided = false
                ship.x = initialXPosition
            }

            function collide() {
                /* Add few visual effects */
                collided = true
            }

            transform: Rotation {
                id: rotateShip
                origin.x: ship.width / 2;
                origin.y: 0;
                axis { x: 0; y: 1; z: 0 } angle: 0
            }

            SequentialAnimation {
                id: rotateShipLeft
                loops: 1
                PropertyAnimation {
                    target: rotateShip
                    properties: "angle"
                    from: 0
                    to: 180
                    duration: 500
                }
            }

            SequentialAnimation {
                id: rotateShipRight
                loops: 1
                PropertyAnimation {
                    target: rotateShip
                    properties: "angle"
                    from: 180
                    to: 0
                    duration: 500
                }
            }

            onXChanged: {
                if (x <= 0) {
                    rotateShipLeft.start()
                    movingLeft = false
                } else if (x >= background.width - ship.width - (upperGate.visible ? upperGate.width : 0)) {
                    rotateShipRight.start()
                    movingLeft = true
                }
            }

            Body {
                id: shipbody
                target: ship
                bodyType: Body.Dynamic
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0
                linearVelocity: Qt.point( (ship.collided ? 0 : ((ship.movingLeft ? -1 : 1) * ship.horizontalSpeed)), 0)

                fixtures: Box {
                    id: shipfixer
                    width: ship.width
                    height: ship.height
                    categories: items.shipCategory
                    collidesWith: ship.visible ? items.submarineCategory : Fixture.None
                    density: 1
                    friction: 0
                    restitution: 0

                    onBeginContact: ship.collide()
                }
            }
        }

        Image {
            id: rock2
            width: background.width / 6
            height: rock2.width * 0.48
            z: 5

            visible: (bar.level > 4) ? true : false
            anchors.bottom: crown.bottom
            anchors.left: crown.right
            source: "qrc:/gcompris/src/activities/mining/resource/stone2.svg"

            transform: Rotation {
                origin.x: rock2.width / 2;
                origin.y: rock2.height / 2
                axis { x: 0; y: 0; z: 1 } angle: 180
            }

            Body {
                id: rock2Body
                target: rock2
                bodyType: Body.Static
                sleepingAllowed: true
                linearDamping: 0

                fixtures: Box {
                    id: rock2Fixer
                    categories: items.rockCategory
                    collidesWith: rock2.visible ? items.submarineCategory : Fixture.None
                    x: rock2.width / 8
                    y: rock2.height / 12
                    width: rock2.width / 1.2
                    height: rock2.height / 1.5
                    density: 1
                    friction: 0
                    restitution: 0
                }
            }
        }

        /* Just a space */
        Rectangle {
            id: space
            width: bar.level < 8 ? rock1.width : rock1.width * (1 - (Math.random() * 0.5))
            height: rock1.height

            color: "transparent"
            anchors {
                right: crown.left
                bottom: crown.bottom
            }
        }

        Image {
            id: rock1
            width: rock2.width
            height: rock2.width * 0.46
            z: 5
            visible: (bar.level > 6) ? true : false
            anchors.bottom: crown.bottom
            anchors.right: space.left
            source: "qrc:/gcompris/src/activities/mining/resource/stone1.svg"

            Body {
                id: rock1Body
                target: rock1
                bodyType: Body.Static
                sleepingAllowed: true
                linearDamping: 0

                fixtures: [
                    Circle {
                        id: rock1FixerLeft
                        categories: items.rockCategory
                        collidesWith: rock1.visible ? items.submarineCategory : Fixture.None
                        x: rock1.width / 10
                        radius: rock1.width / 4
                        density: 1
                        friction: 0
                        restitution: 0
                    },Circle {
                        id: rock1FixerRight
                        categories: items.rockCategory
                        collidesWith: rock1.visible ? items.submarineCategory : Fixture.None
                        x: rock1.width / 1.6
                        y: rock1.height / 4
                        radius: rock1.width / 6
                        density: 1
                        friction: 0
                        restitution: 0
                    }
                ]
            }
        }

        Image {
            id: rock3
            width: background.width 
            height: background.height * 0.25
            sourceSize.width: rock3.width
            sourceSize.height: rock3.height

            visible: (bar.level > 2) ? true : false
            anchors.top: crown.top
            anchors.horizontalCenter: crown.left
//             anchors.topMargin: height * 0.5
            source: url + "rocks.svg"
        }
        
        Timer {
            /*
             * A delay is used since on setting fullscreen on/off
             * first the onWidthChanged is executed, followed by
             * the width change
             */
            id: updateOnWidthReset
            repeat: false
            interval: 100
            running: false
            onTriggered: {
                whale.reset()
                ship.reset()
            }
        }

        Controls {
            id: controls
            z: 10
            enginePosition.x: background.width * 0.1
            enginePosition.y: buttonPlusY + buttonSize * 0.2
            engineWidth: background.width / 8
            engineHeight: hori ? buttonSize * 1.8 : buttonSize * 2.5
            submarineHorizontalSpeed: submarine.currentFinalVelocity * 1000

            leftTankVisible: bar.level >= 7 ? true : false
            leftBallastTankPosition.x: background.width * 0.35
            leftBallastTankPosition.y: enginePosition.y
            leftBallastTankWidth: background.width / 8
            leftBallastTankHeight: engineHeight

            centralTankVisible:  bar.level < 7 ? true : false
            centralBallastTankPosition.x: background.width * 0.45
            centralBallastTankPosition.y: enginePosition.y
            centralBallastTankWidth: background.width / 8
            centralBallastTankHeight: engineHeight

            rightTankVisible:  bar.level >= 7 ? true : false
            rightBallastTankPosition.x: background.width * 0.6
            rightBallastTankPosition.y: enginePosition.y
            rightBallastTankWidth: background.width / 8
            rightBallastTankHeight: engineHeight

            divingPlaneVisible: true
            divingPlanePosition.x: background.width * 0.8
            divingPlanePosition.y: enginePosition.y + (engineHeight * 0.5) - (divingPlaneHeight * 0.5)
            divingPlaneWidth: hori ? background.width * 0.08 : background.width * 0.12
            divingPlaneHeight: divingPlaneWidth * 0.33
            buttonSize: hori ? subSchemaImage.height * 0.3 : subSchemaImage.height * 0.2
            buttonPlusY: hori ? background.height * 0.61 : background.height * 0.63
            buttonMinusY: enginePosition.y + engineHeight - buttonSize * 0.8
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | reload | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onReloadClicked: Activity.initLevel()
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            onLoose: Activity.initLevel()
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
        /*
        DebugDraw {
            id: debugDraw
            world: physicalWorld
            anchors.fill: parent
            opacity: 0.75
            visible: false
        }

        MouseArea {
            id: debugMouseArea
            anchors.fill: parent
            onPressed: debugDraw.visible = !debugDraw.visible
        }
        */
    }

}
