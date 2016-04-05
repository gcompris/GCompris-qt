/* GCompris - LandSafe.qml
 *
 * Copyright (C) 2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Matilda Bernard <serah4291@gmail.com> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import Box2D 2.0
import QtQuick.Particles 2.0
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

    Keys.onPressed: Activity.processKeyPress(event)
    Keys.onReleased: Activity.processKeyRelease(event)

    onWidthChanged: if (inForeground)
                        Activity.initLevel();

    onHeightChanged: if (inForeground)
                         Activity.initLevel();

    pageComponent: Image {
        id: background

        source: Activity.baseUrl + "/background4.jpg";
        anchors.centerIn: parent
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias rocket: rocket
            property alias world: physicsWorld
            property alias landing: landing
            property alias ground: ground
            property alias stats: stats
            property alias intro: intro
            property alias ok: ok
            property var rocketCategory: Fixture.Category1
            property var groundCategory: Fixture.Category2
            property var landingCategory: Fixture.Category3
            property var borderCategory: Fixture.Category4
            property string mode: "rotate"  // "simple"
            property double lastVelocity: 0.0
            property double scale: background.height / 400
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        World {
            id: physicsWorld

            running: false;
            gravity: Qt.point(0, Activity.gravity)
            pixelsPerMeter: 0
            autoClearForces: false
            //timeStep: 1.0/60.0 // default: 60Hz

            onStepped: {
                if (Math.abs(rocket.body.linearVelocity.y) > 0.01)  // need to store velocity before it is aaaalmost 0 because of ground/landing contact
                    items.lastVelocity = stats.velocity.y;
                stats.velocity = rocket.body.linearVelocity;

                if (rocket.body.linearVelocity.y > Activity.maxLandingVelocity)
                    landing.source = Activity.baseUrl + "/landing_red.png";
                else
                    landing.source = Activity.baseUrl + "/landing_green.png";

                stats.height = Math.max(0, Math.round(Activity.getRealHeight()));

                // update fuel:
                var dt = timeStep;
                var dFuel = -(dt * (items.rocket.accel + items.rocket.leftAccel
                                    + items.rocket.rightAccel));
                Activity.currentFuel = Math.max(0, Activity.currentFuel + dFuel);
                stats.fuel = Math.round(Activity.currentFuel / Activity.maxFuel * 100);
                if (Activity.currentFuel === 0)
                    // fuel consumed:
                    items.rocket.accel = items.rocket.leftAccel = items.rocket.rightAccel = 0;

//                console.log("VVV changed: " + items.lastVelocity + " --> " + stats.velocity.y + " / " + rocket.body.linearVelocity.y);
            }

        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            onClicked: debugDraw.visible = !debugDraw.visible;
            enabled: Activity.debugDraw
        }

        // bounding fixtures
        Item {
            id: leftBorder
            width: 1
            height: parent.height
            anchors.left: parent.left
            anchors.top: parent.top

            readonly property string collisionName: "leftBorder"

            Body {
                id: leftBody

                target: leftBorder
                bodyType: Body.Static
                sleepingAllowed: false
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: leftFixture
                    categories: items.borderCategory
                    collidesWith: items.rocketCategory
                    density: 1
                    friction: 0
                    restitution: 0
                    width: leftBorder.width
                    height: leftBorder.height
                }
            }
        }

        Item {
            id: rightBorder
            width: 1
            height: parent.height
            anchors.right: parent.right
            anchors.rightMargin: 1
            anchors.top: parent.top

            readonly property string collisionName: "rightBorder"

            Body {
                id: rightBody

                target: rightBorder
                bodyType: Body.Static
                sleepingAllowed: false
                fixedRotation: true
                linearDamping: 0

                fixtures: Box {
                    id: rightFixture
                    categories: items.borderCategory
                    collidesWith: items.rocketCategory
                    density: 1
                    friction: 0
                    restitution: 0
                    width: rightBorder.width
                    height: rightBorder.height
                }
            }
        }

        GCText {
            id: stats
            z: 0
            property var velocity: rocket.body.linearVelocity
            property double fuel: 100.0
            property double heigth: Activity.startingHeightReal

            anchors.left: background.left
            anchors.leftMargin: 20
            anchors.top: background.top
            anchors.topMargin: 20
            width: 100
            height: 100
            color: "gray"

            fontSize: tinySize
            text: qsTr("Planet: ") + Activity.levels[Activity.currentLevel].planet + "<br/>" +
                  qsTr("Velocity: ") + Math.round(velocity.y * 10) / 10 + "<br/>" +
                  qsTr("Fuel: ") + fuel  + "<br/>" +
                  qsTr("Altitude: ") + height + "<br/>" +
                  qsTr("Gravity: ") + Math.round(Activity.gravity * 100)/100
        }

        Item {
            id: rocket
            property double accel: 0.0
            property double leftAccel: 0.0
            property double rightAccel: 0.0
            property alias body: rocketBody
            property alias leftEngine: leftEngine
            property alias rightEngine: rightEngine
            property alias explosion: explosion
            //property float rotate

            rotation: 0
            width: items.scale * 28// * ApplicationInfo.ratio
            height: width / 232 * 385
            x: 300
            y: 50
            z: 3

            Component.onCompleted: rocket.body.applyForceToCenter(Qt.point(0, 5));

            onAccelChanged: applyForces();
            onLeftAccelChanged: applyForces();
            onRightAccelChanged: applyForces();
            onRotationChanged: if (accel > 0)       // should only happen in
                                   applyForces();   // "rotation" mode

            // map acceleration to box2d forces applying appropriate factors:
            function applyForces()
            {
                var totForce = (accel / 0.5 * 5)
                var xForce;
                var yForce;

                if (items.mode === "simple") {
                    yForce = -totForce;
                    xForce = (leftAccel-rightAccel)
                             * 10 /* base of 10 m/s^2 */
                             * 5  /* factor to make movement smooth */;
                } else { // "rotation"
                    yForce = -(totForce * Math.cos(Activity.degToRad(items.rocket.rotation)));
                    xForce = (totForce * Math.sin(Activity.degToRad(items.rocket.rotation)));
                }
                var yFForce = yForce * items.rocket.body.getMass();
                var xFForce = xForce * items.rocket.body.getMass();
                var force = Qt.point(xFForce, yFForce);
//                console.log("applying force " + force + " - " + " - mass=" + items.rocket.body.getMass() + " v=" + items.rocket.body.linearVelocity + " totForce=" + totForce + " - rotation=" + items.rocket.rotation + " - xForce=" + xForce + " xFForce=" + xFForce + " mass=" + items.rocket.body.getMass());

                physicsWorld.clearForces();
                items.rocket.body.applyForceToCenter(force);
            }

            Image {
                id: rocketImage

                width: parent.width
                height: parent.height
                sourceSize.width: 1024
                source: Activity.baseUrl + "/rocket.svg";
                anchors.centerIn: parent
                anchors.fill: parent
            }

            Image {
                id: explosion

//                width: parent.height
//                height: width/785*621
                width: height/621 * 785
                height: 2*parent.height
                sourceSize.width: 1024
                source: Activity.baseUrl + "/explosion.svg";
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                scale: 0

                function show() {
                    visible = true;
                    scale = 1;
                }
                function hide() {
                    visible = false;
                    scale = 0;
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InExpo
                    }
                }
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
                    collidesWith: items.groundCategory | items.landingCategory | items.borderCategory
                    density: 1
                    friction: 0
                    restitution: 0
                    width: rocket.width
                    height: rocket.height
                    rotation: rocketBody.rotation

                    onBeginContact: {
                        //console.log("XXX beginning contact with " + other.getBody().target.collisionName + " abs v=" + Math.abs(items.lastVelocity) + + " maxV=" + Activity.maxLandingVelocity);
                        if (other.getBody().target === leftBorder ||
                                other.getBody().target === rightBorder)
                            ; //nothing to do
                        else if (other.getBody().target === landing &&
                                 Math.abs(items.lastVelocity) <= Activity.maxLandingVelocity &&
                                (items.mode === "simple" || rocket.rotation === 0))
                            Activity.finishLevel(true);
                        else // ground
                            Activity.finishLevel(false); // crash
                    }
//                    onEndContact: console.log("XXX ending contact with " + other.getBody().target.collisionName);
                }
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

                    emitRate: rocket.leftAccel > 0 ? 50 * items.scale / 1.9 : 0  // 50
                    lifeSpan: rocket.leftAccel > 0 ? 600 * items.scale / 1.9 : 0 // 600
                    size: rocket.leftAccel > 0 ? leftEngine.height : 0
                    endSize: 5
                    sizeVariation: 5
                    acceleration: PointDirection { x: -40 }
                    velocity: PointDirection { x: -40 }
                }
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

                    emitRate: rocket.rightAccel > 0 ? 50 * items.scale / 1.9 : 0  // 50
                    lifeSpan: rocket.rightAccel > 0 ? 600 * items.scale / 1.9 : 0 // 600
                    size: rocket.rightAccel > 0 ? rightEngine.height : 0
                    endSize: 5
                    sizeVariation: 5
                    acceleration: PointDirection { x: 40 }
                    velocity: PointDirection { x: 40 }
                }
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

                    emitRate: rocket.accel > 0 ? (80 + 60 * rocket.accel) : 0 // 75-150
                    lifeSpan: (700 + 450 * rocket.accel) * items.scale / 2.5 // 500 - 1000
                    size: rocket.width/1.8 + rocket.width/2*rocket.accel // width*-0.5 - width
                    endSize: size/1.85
                    sizeVariation: 10
                    acceleration: PointDirection { y: 80 }
                    velocity: PointDirection { y: 80 }
                }
            }

        }

        Image {
            id: ground

            z: 1
            width: parent.width
//            height: parent.height
            source: Activity.baseUrl + "/land4.png";
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
            property int surfaceOffset: landing.height - 1

            z: 2
            source: Activity.baseUrl + "/landing_green.png";
            anchors.left: ground.left
            anchors.leftMargin: 270
            anchors.top: ground.top
            anchors.topMargin: ground.surfaceOffset - height
            sourceSize.width: 1024
            width: 66 * items.scale
            height: width / 116 * 34

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

        Column {
            id: updownControl
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: bar.top
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            width: upButton.width + 20 * ApplicationInfo.ratio
            height: upButton.height + downButton.height + 20 * ApplicationInfo.ratio
            visible: items.world.running && ApplicationInfo.isMobile

            z: 19 // below intro, above the rest
            opacity: 0.4
            spacing: 10 * ApplicationInfo.ratio

            ControlButton {
                id: upButton
                source: Activity.baseUrl + "/arrow_up.svg"
                onPressed: Activity.processKeyPress({key: Qt.Key_Up});
            }

            ControlButton {
                id: downButton
                source: Activity.baseUrl + "/arrow_down.svg"
                onPressed: Activity.processKeyPress({key: Qt.Key_Down});
            }
        }

        Row {
            id: leftrightControl
            anchors.left: parent.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: bar.top
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            width: leftButton.width + rightButton.width + 20 * ApplicationInfo.ratio
            height: leftButton.height + 10 * ApplicationInfo.ratio
            visible: items.world.running && ApplicationInfo.isMobile

            z: 19 // below intro, above the rest
            opacity: 0.4
            spacing: 10 * ApplicationInfo.ratio

            ControlButton {
                id: leftButton
                source: Activity.baseUrl + "/arrow_left.svg"
                onPressed: Activity.processKeyPress({key: Qt.Key_Left});
                onReleased: Activity.processKeyRelease({key: Qt.Key_Left});
            }

            ControlButton {
                id: rightButton
                source: Activity.baseUrl + "/arrow_right.svg"
                onPressed: Activity.processKeyPress({key: Qt.Key_Right});
                onReleased: Activity.processKeyRelease({key: Qt.Key_Right});
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
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                Activity.initLevel();
                displayDialog(dialogHelp);
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                loose.connect(Activity.initLevel);
                win.connect(Activity.nextLevel)
            }
        }

        IntroMessage {
            id: intro
            onIntroDone: {
                items.world.running = true;
            }
            intro: [
                Activity.introText1
            ]
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
