/* GCompris - LandSafe.qml
 *
 * SPDX-FileCopyrightText: 2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Matilda Bernard <serah4291@gmail.com> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import Box2D 2.0
import QtQuick.Particles 2.12
import GCompris 1.0

import "../../core"
import "land_safe.js" as Activity

ActivityBase {
    id: activity

    property bool inForeground: false   // to avoid unneeded reconfigurations

    onStart: {
        inForeground = true;
        focus = true;
    }
    onStop: inForeground = false;

    Keys.onPressed: Activity.processKeyPress(event);
    Keys.onReleased: Activity.processKeyRelease(event);

    onWidthChanged: if (inForeground)
                        Activity.initLevel();

    onHeightChanged: if (inForeground)
                         Activity.initLevel();

    pageComponent: Image {
        id: background

        source: Activity.baseUrl + "/background.svg";
        anchors.centerIn: parent
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.height: height

        signal start
        signal stop

        function changeZoom(newZoom)
        {
            var dZoom = newZoom / items.zoom;
            var curAltReal = Activity.getAltitudeReal();
            items.world.pixelsPerMeter *= dZoom;
            var altPx = curAltReal * items.world.pixelsPerMeter;
            var rdy;
            var rdx;
            var ldx;
            if (dZoom < 1) {
                rdy = items.rocket.height*dZoom;
                rdx = items.rocket.width*dZoom/2;
                ldx = items.landing.width*dZoom/2;
            } else {
                rdy = -items.rocket.height/dZoom*2;
                rdx = -items.rocket.width/dZoom;
                ldx = -items.landing.width/dZoom;
            }
            items.rocket.y = Activity.pxAltitudeToY(altPx) + rdy;
            items.rocket.x += rdx;
            items.landing.anchors.leftMargin += ldx;
            items.zoom = newZoom;
            if (dZoom < 1)
                Activity.zoomStack.unshift(curAltReal);
            else
                Activity.zoomStack.shift();
        }

        Component.onCompleted: {
            dialogActivityConfig.initialize();
            activity.start.connect(start);
            activity.stop.connect(stop);
        }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: intro

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias rocket: rocket
            property alias leftEngine: leftEngine
            property alias rightEngine: rightEngine
            property alias bottomEngine: bottomEngine
            property alias explosion: explosion
            property alias world: physicsWorld
            property alias landing: landing
            property alias ground: ground
            property alias intro: intro
            property alias ok: ok
            property alias leftRightControl: leftRightControl
            property alias upDownControl: upDownControl
            property alias accelerometer: accelerometer
            property string accelerometerText: "<font color=\"#00FFFFFF\">-0</font>0.00"
            property var rocketCategory: Fixture.Category1
            property var groundCategory: Fixture.Category2
            property var landingCategory: Fixture.Category3
            readonly property var levels: activity.datasetLoader.data
            property string mode: "rotate"  // "simple"
            property double velocity: 0.0
            property string velocityText: "<font color=\"#00FFFFFF\">-0</font>0.0"
            property double altitude: 0.0
            property string altitudeText: "<font color=\"#00FFFFFF\">00</font>0"
            property double fuel: 100
            property string fuelText: "100"
            property double lastVelocity: 0.0
            property double gravity: 0.0
            property double scale: background.height / 400
            property double zoom: 1.0
            property bool onScreenControls: /* items.world.running && */ ApplicationInfo.isMobile
        }

        onStart: { Activity.start(items) }
        onStop: {
            timer0.stop()
            Activity.stop()
        }
        onVisibleChanged: visible ? physicsWorld.running = true : physicsWorld.running = false

        World {
            id: physicsWorld

            running: false;
            gravity: Qt.point(0, items.gravity)
            autoClearForces: false
            //timeStep: 1.0/60.0 // default: 60Hz

            onStepped: {
                if(intro.visible) return;
                if (Math.abs(rocket.body.linearVelocity.y) > 0.01)  // need to store velocity before it is aaaalmost 0 because of ground/landing contact
                    items.lastVelocity = items.velocity;
                items.velocity = rocket.body.linearVelocity.y;
                items.velocityText = Activity.fixedSizeString(items.velocity, 10, 5, ".0");

                if (rocket.body.linearVelocity.y > Activity.maxLandingVelocity)
                    landing.overlayColor = "-r";  // redish
                else if (explosion.visible == true)
                    landing.overlayColor = "-r";
                else if (rocket.body.linearVelocity.y > Activity.maxLandingVelocity - 2)
                    landing.overlayColor = "-y";  // yellowish
                else
                    landing.overlayColor = "-g";  // greenish
                items.altitude = Math.max(0, Math.round(Activity.getAltitudeReal()));
                items.altitudeText = Activity.minimum3Chars(items.altitude);

                if (Activity.maxFuel != -1) {
                    // update fuel:
                    var dt = timeStep;
                    var dFuel = -(dt * (items.rocket.accel + items.rocket.leftAccel
                                        + items.rocket.rightAccel));
                    Activity.currentFuel = Math.max(0, Activity.currentFuel + dFuel);
                    items.fuel = Math.round(Activity.currentFuel / Activity.maxFuel * 100);
                    if (Activity.currentFuel === 0) // fuel consumed
                        items.rocket.accel = items.rocket.leftAccel = items.rocket.rightAccel = 0;
                } else
                    items.fuel = 100;
                items.fuelText = Activity.minimum3Chars(items.fuel);
                if (items.rocket.x > background.width)
                    items.rocket.x = -items.rocket.width;
                if (items.rocket.x < -items.rocket.width)
                    items.rocket.x = background.width;

                if (items.rocket.y < 0)
                    background.changeZoom(items.zoom / 2);
                else if (Activity.zoomStack.length > 0 && items.altitude < Activity.zoomStack[0]-1)
                    background.changeZoom(items.zoom * 2);
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            onClicked: debugDraw.visible = !debugDraw.visible;
            enabled: Activity.debugDraw
        }

        Item {
            id: rocket
            property double accel: 0.0
            property double leftAccel: 0.0
            property double rightAccel: 0.0
            property alias body: rocketBody

            function show() {
                opacity = 100;
            }
            function hide() {
                opacity = 0;
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutExpo
                }
            }

            //property float rotate

            rotation: 0
            width: items.scale * 28 * items.zoom// * ApplicationInfo.ratio
            height: width / 232 * 385
            x: 300
            y: 50
            z: 4

//            Component.onCompleted: rocket.body.applyForceToCenter(Qt.point(0, 5));

            onAccelChanged: applyForces();
            onLeftAccelChanged: applyForces();
            onRightAccelChanged: applyForces();
            onRotationChanged: if (accel > 0)       // should only happen in
                                   applyForces();   // "rotation" mode

            // decompose a force/acceleration vector v using angle into x/y components
            function decomposeVector(v, angle) {
                return Qt.point(v * Math.sin(Activity.degToRad(angle)), // x-component
                                v * Math.cos(Activity.degToRad(items.rocket.rotation)));  // y-component
            }

            // map acceleration to box2d forces applying appropriate factors:
            function applyForces()
            {
                var totForce = (accel / 0.5 * 5);
                var v;

                if (items.mode === "simple")
                    v = Qt.point((leftAccel-rightAccel)
                                 * 10 /* base of 10 m/s^2 */
                                 * 5,  /* factor to make movement smooth */
                                 -totForce
                                 );
                else { // "rotation"
                    v = decomposeVector(totForce, rotation);
                    v.y = -v.y;
                }
                v.x *= items.rocket.body.getMass();
                v.y *= items.rocket.body.getMass();

                physicsWorld.clearForces();
                items.rocket.body.applyForceToCenter(v);
//                console.log("XXX rocket.acc=" + rocket.accel + " acc.current=" + items.accelerometer.current + " bottomMargin=" + items.accelerometer.currentRect.bottomMargin);
            }

            Image {
                id: rocketImage

                sourceSize.width: 1024
                source: Activity.baseUrl + "/rocket.svg"
                anchors.centerIn: parent
                anchors.fill: parent
                z: 4
                mipmap: true
            }

            Body {
                id: rocketBody

                target: rocket
                bodyType: Body.Dynamic
                sleepingAllowed: false
                fixedRotation: true
                linearDamping: 0
                property double rotation: Activity.degToRad(rocket.rotation % 360)

                fixtures: Box {
                    id: rocketFixture
                    categories: items.rocketCategory
                    collidesWith: items.groundCategory | items.landingCategory
                    density: 1
                    friction: 0
                    restitution: 0
                    width: rocket.width
                    height: rocket.height
                    rotation: rocketBody.rotation

                    onBeginContact: {
                        //console.log("XXX beginning contact with " + other.getBody().target.collisionName + " abs v=" + Math.abs(items.lastVelocity) + + " maxV=" + Activity.maxLandingVelocity);
                        if (other.getBody().target === landing &&
                                Math.abs(items.lastVelocity) <= Activity.maxLandingVelocity &&
                                (items.mode === "simple" || rocket.rotation%360 === 0))
                            Activity.finishLevel(true);
                        else // ground
                            Activity.finishLevel(false); // crash
                    }
//                    onEndContact: console.log("XXX ending contact with " + other.getBody().target.collisionName);
                }
            }

            Image {
                id: softLeftEngine
                source: Activity.baseUrl + "/engine.svg"
                rotation: 90
                anchors.right: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width:  rocket.leftAccel > 0 ?
                            rocket.width * 0.2 + rocket.width * rocket.leftAccel : 0
                height:  width * 2 + width * rocket.leftAccel
                sourceSize.width: width
                sourceSize.height: height
                visible: ApplicationInfo.useOpenGL ? false : true
            }

            ParticleSystem {
                id: leftEngine

                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                height: 30

                ImageParticle {
                    groups: ["flameLeft"]
                    source: "qrc:///particleresources/glowdot.png"
                    color: "#11ff400f"
                    colorVariation: 0.1
                }
                Emitter {
                    anchors.centerIn: parent
                    group: "flameLeft"

                    emitRate: (rocket.leftAccel > 0 ? 50 * items.scale / 1.9 : 0) * items.zoom // 50
                    lifeSpan: (rocket.leftAccel > 0 ? 600 * items.scale / 1.9 : 0) * items.zoom // 600
                    size: rocket.leftAccel > 0 ? leftEngine.height : 0
                    endSize: 5
                    sizeVariation: 3
                    acceleration: PointDirection { x: -40 }
                    velocity: PointDirection { x: -40 }
                }
            }

            Image {
                id: softRightEngine
                source: Activity.baseUrl + "/engine.svg"
                rotation: -90
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width:  rocket.rightAccel > 0 ?
                            rocket.width * 0.2 + rocket.width * rocket.rightAccel : 0
                height:  width * 2 + width * rocket.rightAccel
                sourceSize.width: width
                sourceSize.height: height
                visible: ApplicationInfo.useOpenGL ? false : true
            }

            ParticleSystem {
                id: rightEngine

                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                height: 30

                ImageParticle {
                    groups: ["flameRight"]
                    source: "qrc:///particleresources/glowdot.png"
                    color: "#11ff400f"
                    colorVariation: 0.1
                }
                Emitter {
                    anchors.centerIn: parent
                    group: "flameRight"

                    emitRate: (rocket.rightAccel > 0 ? 50 * items.scale / 1.9 : 0) * items.zoom  // 50
                    lifeSpan: (rocket.rightAccel > 0 ? 600 * items.scale / 1.9 : 0) * items.zoom // 600
                    size: rocket.rightAccel > 0 ? rightEngine.height : 0
                    endSize: 5
                    sizeVariation: 3
                    acceleration: PointDirection { x: 40 }
                    velocity: PointDirection { x: 40 }
                }
            }

            Image {
                id: softBottomEngine
                source: Activity.baseUrl + "/engine.svg"
                anchors.top: parent.bottom
                anchors.topMargin: -5 * ApplicationInfo.ratio
                anchors.horizontalCenter: parent.horizontalCenter
                width:  rocket.width * 0.5 + rocket.width * rocket.accel
                height: rocket.accel > 0 ? width * 2 : 0
                sourceSize.width: width
                sourceSize.height: height
                visible: ApplicationInfo.useOpenGL ? false : true
            }

            ParticleSystem {
                id: bottomEngine
                anchors.top: parent.bottom
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                width: rocket.width

                ImageParticle {
                    groups: ["flame"]
                    source: "qrc:///particleresources/glowdot.png"
                    color: "#11ff400f"
                    colorVariation: 0.1
                }
                Emitter {
                    anchors.centerIn: parent
                    group: "flame"

                    emitRate: (rocket.accel > 0 ? (80 + 60 * rocket.accel) : 0) * items.zoom // 75-150
                    lifeSpan: ((700 + 450 * rocket.accel) * items.scale / 2.5) * items.zoom // 500 - 1000
                    size: rocket.width/1.8 + rocket.width/2*rocket.accel // width*-0.5 - width
                    endSize: size/1.85
                    sizeVariation: 5
                    acceleration: PointDirection { y: 80 }
                    velocity: PointDirection { y: 80 }
                }
            }

         }

        ParticleSystem {
            id: explosion
            anchors.centerIn: rocket
            width: rocket.width
            z: 5

            ImageParticle {
                groups: ["flame"]
                source: "qrc:///particleresources/glowdot.png"
                color: "#11ff400f"
                colorVariation: 0.1
            }
            Emitter {
                anchors.centerIn: parent
                group: "flame"
                emitRate: 75 // 75-150
                lifeSpan: 300 // 500 - 1000
                size: rocket.width * 3 // width*-0.5 - width
                endSize: 0
                sizeVariation: 5
                acceleration: PointDirection { x: 0 }
                velocity: PointDirection { x: 0 }
            }

            Timer {
                id: timer0
                interval: 600; running: false; repeat: false
                onTriggered: explosion.opacity = 0
            }

            function show() {
                visible = true;
                opacity = 100
                scale = 1;
                timer0.running = true
            }
            function hide() {
                visible = false;
                scale = 0;
                timer0.running = false
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InExpo
                }
            }

        }

        Image {
            id: ground

            z: 1
            width: parent.width
            height: parent.height/7
            sourceSize.width: width
            sourceSize.height: height
            source: Activity.baseUrl + "/ground.svg"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            readonly property string collisionName: "ground"
            property int surfaceOffset: height/2

            Body {
                id: groundBody

                target: ground
                bodyType: Body.Static
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: groundFixture

                    categories: items.groundCategory
                    collidesWith: items.rocketCategory
                    density: 1
                    friction: 0
                    restitution: 0
                    width: ground.width
                    height: ground.height - ground.surfaceOffset
                    x: 0
                    y: ground.surfaceOffset
                }
            }
        }


        Image {
            id: landing

            readonly property string collisionName: "landing"
            property int surfaceOffset: landing.height * 0.8
            property string overlayColor: "-g"

            z: 2
            source: Activity.baseUrl + "/landing" + overlayColor + ".svg";
            anchors.left: ground.left
            anchors.leftMargin: 270
            anchors.top: ground.top
            anchors.topMargin: ground.surfaceOffset - height
            width: 66 * items.scale * items.zoom
            height: width / 7 * 2

            Body {
                id: landingBody

                target: landing
                bodyType: Body.Static
                sleepingAllowed: true
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: landingFixture

                    categories: items.landingCategory
                    collidesWith: items.rocketCategory
                    density: 1
                    friction: 0
                    restitution: 0
                    width: landing.width
                    height: landing.height - landing.surfaceOffset
                    y: landing.surfaceOffset
                }
            }
        }

        Item {
            id: osdWrapper

            anchors.right: background.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: bar.top
            anchors.bottomMargin: 20 * ApplicationInfo.ratio
            anchors.top: background.top
            width: 200
            height: background.height
            z: 2
            property int itemsMargin: 6 * ApplicationInfo.ratio

            GCText {
                id: fuelText
                anchors.right: parent.right
                anchors.bottom: altitudeText.top
                anchors.bottomMargin: osdWrapper.itemsMargin
                color: "white"
                fontSize: tinySize
                horizontalAlignment: Text.AlignRight
                text: qsTr("Fuel: %1").arg(items.fuelText)
            }
            GCText {
                id: altitudeText
                anchors.right: parent.right
                anchors.bottom: velocityText.top
                anchors.bottomMargin: osdWrapper.itemsMargin
                color: "white"
                fontSize: tinySize
                horizontalAlignment: Text.AlignRight
                text: qsTr("Altitude: %1").arg(items.altitudeText)
            }
            GCText {
                id: velocityText
                anchors.right: parent.right
                anchors.bottom: accelText.top
                anchors.bottomMargin: osdWrapper.itemsMargin
                color: "white"
                fontSize: tinySize
                horizontalAlignment: Text.AlignRight
                text: qsTr("Velocity: %1").arg(items.velocityText)
            }

            GCText {
                id: accelText
                anchors.bottom: accelerometer.top
                anchors.bottomMargin: osdWrapper.itemsMargin
                anchors.right: parent.right
                fontSize: tinySize
                color: "white"
                horizontalAlignment: Text.AlignRight
                text: qsTr("Acceleration: %1").arg(items.accelerometerText)
            }

            Accelerometer {
                id: accelerometer
                current: rocket.decomposeVector(rocket.accel, rocket.rotation).y * 10 - items.gravity
                anchors.right: parent.right
                anchors.bottom: planetText.top
                anchors.bottomMargin: osdWrapper.itemsMargin
                width: 15 + 3 * items.scale * ApplicationInfo.ratio
                height: upDownControl.height
                z: 2 // on top of rocket and ground
                opacity: 1
                onCurrentChanged: {
                    items.accelerometerText = Activity.fixedSizeString(accelerometer.current, 100, 6, ".00");
                }
            }
            GCText {
                id: planetText
                anchors.right: parent.right
                anchors.bottom: gravityText.top
                anchors.bottomMargin: osdWrapper.itemsMargin
                color: "white"
                fontSize: tinySize
                horizontalAlignment: Text.AlignRight
                text: (items.levels && items.levels[bar.level-1]) ? items.levels[bar.level-1].planet : ""
            }
            GCText {
                id: gravityText
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                horizontalAlignment: Text.AlignRight
                fontSize: tinySize
                color: "white"
                text: qsTr("Gravity: %1").arg(Math.round(items.gravity * 100) / 100);
            }
        }

        Column {
            id: upDownControl
            anchors.right: background.right
            anchors.rightMargin: accelerometer.width
            anchors.bottom: bar.top
            anchors.bottomMargin: 32 * ApplicationInfo.ratio + gravityText.height + planetText.height
            width: upButton.width + 20 * ApplicationInfo.ratio
            height: upButton.height + downButton.height + 20 * ApplicationInfo.ratio
            visible: items.onScreenControls

            z: 19 // below intro, above the rest
            opacity: 0.4
            spacing: 20 * ApplicationInfo.ratio

            ControlButton {
                id: upButton
                source: "qrc:/gcompris/src/core/resource/arrow_up.svg"
                onPressed: Activity.processKeyPress({key: Qt.Key_Up});
                exceed: upDownControl.spacing / 2
            }

            ControlButton {
                id: downButton
                source: "qrc:/gcompris/src/core/resource/arrow_down.svg"
                onPressed: Activity.processKeyPress({key: Qt.Key_Down});
                exceed: upDownControl.spacing / 2
            }
        }

        Row {
            id: leftRightControl
            anchors.left: parent.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: upDownControl.bottom
            width: leftButton.width + rightButton.width + 20 * ApplicationInfo.ratio
            height: leftButton.height + 10 * ApplicationInfo.ratio
            visible: items.onScreenControls

            z: 19 // below intro, on top of the rest
            opacity: 0.4
            spacing: 20 * ApplicationInfo.ratio

            ControlButton {
                id: leftButton
                source: "qrc:/gcompris/src/core/resource/arrow_left.svg"
                onPressed: Activity.processKeyPress({key: Qt.Key_Left});
                onReleased: Activity.processKeyRelease({key: Qt.Key_Left});
                exceed: leftRightControl.spacing / 2
            }

            ControlButton {
                id: rightButton
                source: "qrc:/gcompris/src/core/resource/arrow_right.svg"
                onPressed: Activity.processKeyPress({key: Qt.Key_Right});
                onReleased: Activity.processKeyRelease({key: Qt.Key_Right});
                exceed: leftRightControl.spacing / 2
            }
        }

        DebugDraw {
            id: debugDraw
            world: physicsWorld
            visible: false
            z: 1
        }

        DialogHelp {
            id: dialogHelp
            onClose: home();
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels;
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels;
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels);
            }
            onClose: {
                home();
            }
            onStartActivity: {
                background.stop();
                background.start();
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            z: 21
            content: BarEnumContent { value: help | home | level | reload | activityConfig }
            onHelpClicked: displayDialog(dialogHelp);
            onPreviousLevelClicked: Activity.previousLevel();
            onNextLevelClicked: Activity.nextLevel();
            onHomeClicked: home();
            onReloadClicked: Activity.initLevel();
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig);
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                loose.connect(Activity.initLevel);
                win.connect(Activity.nextLevel);
            }
        }

        IntroMessage {
            id: intro
            onIntroDone: {
                items.world.running = true;
            }
            z: 20
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
        }

        BarButton {
            id: ok
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
            sourceSize.width: 75 * ApplicationInfo.ratio
            visible: false
            anchors.centerIn: background
            onClicked: {
                visible = false;
                items.world.running = true;
            }
        }
    }

}
