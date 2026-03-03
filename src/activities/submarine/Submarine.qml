/* GCompris - submarine.qml
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
import QtQuick.Particles
import Box2D 2.0
import core 1.0

import "../../core"
import "submarine.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/submarine/resource/"

     onActivityNextLevel: {
         Activity.nextLevel()
    }

    pageComponent: Image {
        id: activityBackground
        source: url + "background.svg"
        anchors.fill: parent
        sourceSize.height: parent.height
        sourceSize.width: parent.width

        onWidthChanged: updateOnWidthReset.start()
        onHeightChanged: Activity.resetUpperGate()
        onVisibleChanged: visible ? physicalWorld.running = true :
                                    physicalWorld.running = false

        property bool hori: activityBackground.width >= activityBackground.height
        readonly property int waterLevel: activityBackground.height / 15

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: [tutorial]
        
        /* Testing purposes, A / Left Key => Reduces velocity, D / Right Key => Increases velocity */
        Keys.onPressed: (event) => {
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            onCurrentLevelChanged: activity.currentLevel = currentLevel
            property int numberOfLevel: 10
            onNumberOfLevelChanged: activity.numberOfLevel = numberOfLevel
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

        Item {
            id: introArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: GCStyle.baseMargins + parent.height * 0.4 // height of controlBackground in controls
        }

        ListModel {
            id: tutoSubmarine
            ListElement {
                text: qsTr("Move the submarine to the other side of the screen.")
            }
            ListElement {
                text: qsTr("The leftmost item in the control panel is the engine of the submarine, indicating the current speed of the submarine.")
            }
            ListElement {
                text: qsTr("Increase or decrease the velocity of the submarine using the engine.")
            }
            ListElement {
                text: qsTr("Press the + button to increase the velocity, or the - button to decrease the velocity.")
            }
        }

        ListModel {
            id: tutoBallast
            ListElement {
                text: qsTr("The item next to the engine is the ballast tank.")
            }
            ListElement {
                text: qsTr("The ballast tanks are used to float or dive under water.")
            }
            ListElement {
                text: qsTr("If the ballast tanks are empty, the submarine will float. If the ballast tanks are full of water, the submarine will dive underwater.")
            }
            ListElement {
                text: qsTr("Turning the upper valve on or off will alternatively allow or stop the water from filling in the ballast tank, thus allowing it to dive underwater.")
            }
            ListElement {
                text: qsTr("Turning the lower valve on or off will alternatively allow or stop the water from flushing out the ballast tank, thus allowing it to float on the surface of the water.")
            }
        }

        ListModel {
            id: tutoDivingPlanes
            ListElement {
                text: qsTr("The rightmost item in the control panel controls the diving planes of the submarine.")
            }
            ListElement {
                text: qsTr("The diving planes in a submarine are used to control the depth of the submarine accurately once it is underwater.")
            }
            ListElement {
                text: qsTr("Once the submarine is moving underwater, increasing or decreasing the angle of the planes will increase and decrease the depth of the submarine.")
            }
            ListElement {
                text: qsTr("The + button will increase the depth of the submarine, while the - button will decrease the depth of the submarine.")
            }
            ListElement {
                text: qsTr("Grab the crown to open the gate.")
            }
            ListElement {
                text: qsTr("Check out the help menu for the keyboard controls.")
            }
        }

        IntroMessage {
            id: tutorial
            customIntroArea: introArea
            z: 100
            intro: items.currentLevel == 0 ? tutoSubmarine : items.currentLevel == 1 ? tutoBallast : tutoDivingPlanes
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
            id: maximumWaterDepth
            width: activityBackground.width
            height: 10

            y: activityBackground.height * 0.65

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
            property point initialPosition: Qt.point(0,activityBackground.waterLevel - submarineImage.height * 0.5)
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
                submarine.velocity.y = ballastTankDiveSpeed * (depthToMove / activityBackground.width)
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

                width: activityBackground.width / 9
                sourceSize.width: submarineImage.width
                fillMode: Image.PreserveAspectFit

                function reset() {
                    x = submarine.initialPosition.x
                    y = submarine.initialPosition.y
                }

                onXChanged: {
                    if (submarineImage.x >= activityBackground.width) {
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
                        onBeginContact: (other) => {
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
                        onBeginContact: (other) => {
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
            sourceSize.width: width
            sourceSize.height: height
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
            width: activityBackground.width / 18
            height: isGateOpen ? activityBackground.height * (5 / 36) : activityBackground.height * (5 / 12) + GCStyle.thinnestBorder * 2
            y: -GCStyle.thinnestBorder
            z: 2
            color: "#9E948A"
            border.color: "#766C62"
            border.width: GCStyle.thinnestBorder
            anchors.right: activityBackground.right
            anchors.rightMargin: -GCStyle.thinnestBorder

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
            visible: upperGate.visible
            width: activityBackground.width / 18
            height: activityBackground.height - y
            y: activityBackground.height * (5 / 12)
            color: "#9E948A"
            border.color: "#766C62"
            border.width: GCStyle.thinnestBorder
            anchors.right:activityBackground.right
            anchors.rightMargin: -GCStyle.thinnestBorder

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

        Image {
            id: crown
            width: submarineImage.width * 0.85
            height: crown.width * 0.5
            sourceSize.width: width
            sourceSize.height: height
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

            x: activityBackground.width * 0.5
            y: activityBackground.height * 0.5
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
            rightLimit: activityBackground.width - whale.width - (upperGate.visible ? upperGate.width : 0)
        }

        Image {
            id: ship
            width: activityBackground.width / 9
            sourceSize.width: ship.width
            fillMode: Image.PreserveAspectFit

            visible: (bar.level > 3) ? true : false
            source: collided ? url + "boat-hit.svg" : url + "boat.svg"
            x: initialXPosition
            y: activityBackground.waterLevel - height
            z: 1

            property bool movingLeft: true
            property bool collided: false
            property real initialXPosition: activityBackground.width - ship.width - (upperGate.visible ? upperGate.width : 0)
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
                origin.x: ship.width * 0.5
                origin.y: 0
                axis { x: 0; y: 1; z: 0 }
                angle: 0
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
                } else if (x >= activityBackground.width - ship.width - (upperGate.visible ? upperGate.width : 0)) {
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
            width: activityBackground.width / 6
            height: rock2.width * 0.48
            sourceSize.width: width
            sourceSize.height: height
            z: 5

            visible: (bar.level > 4) ? true : false
            anchors.bottom: crown.bottom
            anchors.left: crown.right
            source: "qrc:/gcompris/src/activities/mining/resource/stone2.svg"

            transform: Rotation {
                origin.x: rock2.width * 0.5
                origin.y: rock2.height * 0.5
                axis { x: 0; y: 0; z: 1 }
                angle: 180
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
            sourceSize.width: width
            sourceSize.height: height
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
            width: activityBackground.width 
            height: activityBackground.height * 0.25
            sourceSize.width: width
            sourceSize.height: height

            visible: (bar.level > 2) ? true : false
            anchors.top: crown.top
            anchors.horizontalCenter: crown.left
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

        Image {
            id: controlBackground
            z: 10
            source: url + "board.svg"
            width: activityBackground.width
            height: activityBackground.height * 0.40
            sourceSize.width: controlBackground.width
            sourceSize.height: controlBackground.height
            y: activityBackground.height - controlBackground.height
        }

        Controls {
            id: controls
            z: 10
            width: activityBackground.width - 2 * GCStyle.baseMargins
            height: activityBackground.height - bar.height * 1.3 - y
            x: GCStyle.baseMargins
            y: activityBackground.height * 0.62

            submarineHorizontalSpeed: submarine.currentFinalVelocity * 1000
            leftTankVisible: bar.level >= 7 ? true : false
            centralTankVisible:  bar.level < 7 ? true : false
            rightTankVisible:  bar.level >= 7 ? true : false
            divingPlaneVisible: true
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
            Component.onCompleted: win.connect(activity.nextLevel)
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
