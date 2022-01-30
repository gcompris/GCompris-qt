/* GCompris - watercycle.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>(GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Big refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0

import "../../core"
import "."

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/watercycle/resource/"

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/checkers/resource/background-wood.svg"
        sourceSize.width: width
        sourceSize.height: height

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart: {
            shower.hide();
            river.level = 0;
        }

        function initLevel() {
            if(message.visible)
                return;
            items.restarted = true;
            timer.stop();
            items.cycleDone = false;
            river.level = 0;
            sun_area.enabled = true;
            sun.isUp = false;
            sun.hasRun = false;
            vapor.animLoop = false;
            vapor.isUp = false;
            rainAnim.stop();
            rain.down();
            cloud.isUp = false;
            boatparked.opacity = 1;
            shower.stop();
            waterplant.running = false;
            sewageplant.running = false;
            tower.level = 0;
            info.visible = true;
            info.setKey('start');
            timer.restart();
            items.restarted = false;
        }

        QtObject {
            id: items
            property var dataset: {
                "none": "",
                "start": qsTr("The sun is the main component of the water cycle. Click on the sun to start the water cycle."),
                "sun": qsTr("As the sun rises, the water of the sea starts heating and evaporates."),
                "cloud": qsTr("Water vapor condenses to form cloud and when clouds become heavy, it rains. Click on the cloud."),
                "rain": qsTr("The rain causes rivers to swell up and this water is transported to us via motor pumps through water-towers." +
                             " Click on the motor pump to supply water to residents."),
                "tower": qsTr("See the tower filled with water. Activate the sewage treatment station by clicking on it."),
                "shower": qsTr("Great, click on the shower, as Tux arrives home."),
                "done":  qsTr("Fantastic, you have completed the water cycle. You can continue playing.")
            }

            property bool restarted: false
            property bool cycleDone: false
            property bool isVertical: background.width < background.height - bar.height * 1.2
            property GCSfx audioEffects: activity.audioEffects
        }

        IntroMessage {
            id: message
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: 100
            onIntroDone: {
                tuxboat.isStarted = true;
                sun.isUp = false;
                info.visible = true;
                sun_area.enabled = true;
            }
            intro: [
                qsTr("The water cycle (also known as the hydrologic cycle) is the journey water takes"
                     +" as it circulates from the land to the sky and back again."
                     +" The sun's heat provides energy to evaporate water from water bodies like oceans."),
                qsTr("Plants also lose water to the air through transpiration. The water vapor "
                     +"cools down forming tiny droplets in clouds. When the clouds meet cool air over the land, "
                     +"precipitation is triggered and fall down as rain.") ,
                qsTr("Some of the water is trapped between rock or clay layers, called groundwater. "
                     +"But most of the water flows as runoff, eventually returning to the seas via rivers."),
                qsTr("Your goal is to complete the water cycle before Tux reaches home. "
                     +"Click on the different components which make up the water cycle. "
                     +"First click on the sun, then on the cloud, the water pumping station near the river, "
                     +"the sewage treatment, and at last regulate the switch to provide water to Tux's shower.")
            ]
        }

        Item {
            id: layoutArea
            width: items.isVertical ? parent.width : parent.height - bar.height * 1.2
            height: width
            anchors.left: background.left
            anchors.leftMargin: items.isVertical ? 0 : 10 * ApplicationInfo.ratio
            anchors.verticalCenter: background.verticalCenter
            anchors.verticalCenterOffset: -bar.height * 0.6
        }

        Image {
            id: sky
            anchors.top: layoutArea.top
            anchors.left: layoutArea.left
            width: layoutArea.width
            height: layoutArea.height * 0.31
            sourceSize.width: width
            sourceSize.height: height
            source: activity.url + "sky.svg"
            z: 1
        }

        Image {
            id: sea
            anchors.left: layoutArea.left
            anchors.bottom: layoutArea.bottom
            width: layoutArea.width
            height: layoutArea.height * 0.7
            sourceSize.width: width
            sourceSize.height: height
            source: activity.url + "sea.svg"
            z:3
        }

        Image {
            id: landscape
            anchors.fill: layoutArea
            sourceSize.width: width
            sourceSize.height: height
            source: activity.url + "landscape.svg"
            z: 6
        }

        Image {
            id: tuxboat
            opacity: 1
            source: activity.url + "boat.svg"
            width: layoutArea.width * 0.15
            height: width
            sourceSize.width: width
            sourceSize.height: height
            property bool isStarted: false
            anchors{
                bottom: layoutArea.bottom
                bottomMargin: layoutArea.height * 0.02
                left: layoutArea.left
                leftMargin: 0
            }
            z:30

            states: [
                State {
                    name: "tuxboatLeft"
                    when: !tuxboat.isStarted
                    PropertyChanges {
                        target: tuxboat
                        anchors.leftMargin: 0
                        opacity: 1
                    }
                },
                State {
                    name: "tuxboatRight"
                    when: tuxboat.isStarted && !items.restarted
                    PropertyChanges {
                        target: tuxboat
                        anchors.leftMargin: layoutArea.width - tuxboat.width
                        opacity: 0
                    }
                },
                State {
                    name: "tuxboatRestarted"
                    when: tuxboat.isStarted && items.restarted
                    PropertyChanges {
                        target: tuxboat
                        anchors.leftMargin: layoutArea.width - tuxboat.width
                        opacity: 0
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "tuxboatLeft"; to: "tuxboatRight";
                    SequentialAnimation {
                        ScriptAction { script: items.audioEffects.play("qrc:/gcompris/src/activities/watercycle/resource/harbor1.wav") }
                        NumberAnimation { property: "anchors.leftMargin"; easing.type: Easing.InOutSine; duration: 15000 }
                        ScriptAction { script: items.audioEffects.play("qrc:/gcompris/src/activities/watercycle/resource/harbor2.wav") }
                        NumberAnimation { property: "opacity"; easing.type: Easing.InOutQuad; duration: 200 }
                        ScriptAction { script: {
                                boatparked.opacity = 1;
                                shower.stop();
                                if(!sun.hasRun && !items.restarted)
                                    info.setKey('start');
                            }
                        }
                    }
                },
                Transition {
                    from: "tuxboatRight"; to: "tuxboatLeft";
                    PropertyAction { properties: "anchors.leftMargin, opacity" }
                    ScriptAction { script: boatparked.opacity = 0 }
                },
                Transition {
                    from: "tuxboatRight, tuxboatLeft"; to: "tuxboatRestarted"
                    PropertyAction { properties: "anchors.leftMargin, opacity" }
                }
            ]
        }

        Image {
            id: boatparked
            source: activity.url + "boat_parked.svg"
            sourceSize.width: layoutArea.width * 0.15
            sourceSize.height: layoutArea.height * 0.15
            opacity: 0
            anchors {
                right: layoutArea.right
                bottom: layoutArea.bottom
                bottomMargin: tuxboat.anchors.bottomMargin
            }
            z: 29
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
        }

        Image {
            id: sun
            source: activity.url + "sun.svg"
            width: layoutArea.width * 0.05
            sourceSize.width: width
            anchors {
                left: layoutArea.left
                top: layoutArea.top
                leftMargin: width
                topMargin: layoutArea.height * 0.275
            }
            z: 2
            property bool hasRun: false
            property bool isUp: true
            MouseArea {
                id: sun_area
                anchors.fill: sun
                onClicked: {
                    if(cloud.opacity == 0)
                        sun.isUp = true;
                }
            }

            states: [
                State {
                    name: "sunDown"
                    when: !sun.isUp
                    PropertyChanges {
                        target: sun
                        anchors.topMargin: layoutArea.height * 0.275
                    }
                },
                State {
                    name: "sunUp"
                    when: sun.isUp
                    PropertyChanges {
                        target: sun
                        anchors.topMargin: layoutArea.height * 0.05
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "sunUp"; to: "sunDown";
                    NumberAnimation { property: "anchors.topMargin"; easing.type: Easing.InOutQuad; duration: 5000 }
                },
                Transition {
                    from: "sunDown"; to: "sunUp";
                    ScriptAction { script: {
                            items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/bleep.wav');
                            info.setKey('sun');
                            sun.hasRun = true;
                            vapor.animLoop = true;
                            vapor.isUp = true;
                            cloud.isUp = true;
                        }
                    }
                    NumberAnimation { property: "anchors.topMargin"; easing.type: Easing.InOutQuad; duration: 5000 }
                }
            ]
        }

        Image {
            id: vapor
            opacity: 0
            state: "vapor"
            source: activity.url + "vapor.svg"
            sourceSize.width: parent.width*0.05
            property bool isUp: false
            property bool animLoop: true
            anchors {
                left: sun.left
                top: layoutArea.top
                topMargin: layoutArea.height * 0.28
            }
            z: 10

            states: [
                State {
                    name: "vaporDown"
                    when: !vapor.isUp && !items.restarted
                    PropertyChanges {
                        target: vapor
                        opacity: 0
                        anchors.topMargin: layoutArea.height * 0.28
                    }
                },
                State {
                    name: "vaporUp"
                    when: vapor.isUp
                    PropertyChanges {
                        target: vapor
                        opacity: 1
                        anchors.topMargin: layoutArea.height * 0.1
                    }
                },
                State {
                    name: "vaporDownRestarted"
                    when: !vapor.isUp && items.restarted
                    PropertyChanges {
                        target: vapor
                        opacity: 0
                        anchors.topMargin: layoutArea.height * 0.28
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "vaporDown, vaporDownRestarted"; to: "vaporUp";
                    SequentialAnimation {
                        NumberAnimation { property: "opacity"; duration: 200 }
                        NumberAnimation { property: "anchors.topMargin"; duration: 5000 }
                        ScriptAction { script: vapor.isUp = false }
                    }
                },
                Transition {
                    from: "vaporUp"; to: "vaporDown";
                    SequentialAnimation {
                        NumberAnimation { property: "opacity"; duration: 200 }
                        PropertyAction { property: "anchors.topMargin" }
                        ScriptAction { script: {
                                if(vapor.animLoop === true) {
                                    vapor.animLoop = false;
                                    vapor.isUp = true;
                                } else {
                                    info.setKey("cloud");
                                }
                            }
                        }
                    }
                },
                Transition {
                    from: "vaporUp, vaporDown"; to: "vaporDownRestarted";
                    ScriptAction { script: vapor.animLoop = false }
                    PropertyAction { properties: "anchors.topMargin, opacity" }
                }
            ]
        }

        Image {
            id: cloud
            opacity: 0
            source: activity.url + "cloud.svg"
            sourceSize.width: layoutArea.width * 0.20
            fillMode: Image.PreserveAspectFit
            width: 0
            property bool isUp: false
            property double originMargin: layoutArea.width * 0.05
            property double upMargin: layoutArea.width * 0.4
            anchors {
                top: layoutArea.top
                topMargin: originMargin
                left: layoutArea.left
                leftMargin: originMargin
            }
            z: 11

            states: [
                State {
                    name: "cloudIsDown"
                    when: !cloud.isUp
                    PropertyChanges {
                        target: cloud
                        opacity: 0
                        width: 0
                        anchors.leftMargin: cloud.originMargin
                    }
                },
                State {
                    name: "cloudIsUp"
                    when: cloud.isUp
                    PropertyChanges {
                        target: cloud
                        opacity: 1
                        width: cloud.sourceSize.width
                        anchors.leftMargin: cloud.upMargin
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "cloudIsDown"; to: "cloudIsUp";
                    NumberAnimation { property: "opacity"; easing.type: Easing.InOutQuad; duration: 5000 }
                    NumberAnimation { properties: "width, anchors.leftMargin"; easing.type: Easing.InOutQuad; duration: 15000 }
                },
                Transition {
                    from: "cloudIsUp"; to: "cloudIsDown";
                    PropertyAction { properties: "opacity, width, anchors.leftMargin" }
                }
            ]

            MouseArea {
                id: cloud_area
                anchors.fill: cloud
                enabled: info.newKey === 'cloud'
                onClicked: {
                    sun.isUp = false;
                    rain.up();
                }
            }
        }

        Image {
            id: rain
            source: activity.url + "rain.svg"
            sourceSize.height: cloud.height * 2
            opacity: 0
            anchors {
                top: cloud.bottom
                left: cloud.left
            }
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 300 } }
            SequentialAnimation{
                id: rainAnim
                running: false
                loops: 10
                NumberAnimation {
                    target: rain
                    property: "scale"
                    duration: 500
                    to: 0.95
                }
                NumberAnimation {
                    target: rain
                    property: "scale"
                    duration: 500
                    to: 1
                }
                onRunningChanged: {
                    if(!running) {
                        rain.down();
                        cloud.isUp = false;
                    }
                }
            }
            function up() {
                items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/water.wav');
                info.setKey('rain');
                opacity = 1;
                rainAnim.start();
            }
            function down() {
                scale = 0;
                opacity = 0;
            }
        }

        Image {
            id: river
            source: activity.url + "river.svg"
            width: layoutArea.width * 0.415
            height: layoutArea.height * 0.74
            sourceSize.width: width
            sourceSize.height: height
            opacity: level > 0 ? 1 : 0
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.1775
                leftMargin: layoutArea.width * 0.293
            }
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
            property double level: 0
        }

        Image {
            id: reservoir1
            source: activity.url + "reservoir1.svg"
            width: layoutArea.width * 0.06
            height: layoutArea.height * 0.15
            sourceSize.width: width
            sourceSize.height: height
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.2925
                leftMargin: layoutArea.width * 0.3225
            }
            opacity: river.level > 0.2 ? 1 : 0
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        }

        Image {
            id: reservoir2
            source: activity.url + "reservoir2.svg"
            width: layoutArea.width * 0.12
            height: layoutArea.height * 0.155
            sourceSize.width: width
            sourceSize.height: height
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.2925
                leftMargin: layoutArea.width * 0.285
            }
            opacity: river.level > 0.5 ? 1 : 0
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        }

        Image {
            id: reservoir3
            source: activity.url + "reservoir3.svg"
            width: layoutArea.width * 0.2
            height: layoutArea.height * 0.17
            sourceSize.width: width
            sourceSize.height: height
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.29
                leftMargin: layoutArea.width * 0.25
            }
            opacity: river.level > 0.8 ? 1 : 0
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        }

        Image {
            id: waterplant
            source: activity.url + "motor.svg"
            width: layoutArea.width * 0.07
            height: layoutArea.height * 0.08
            sourceSize.width: width
            sourceSize.height: height
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.38
                leftMargin: layoutArea.width * 0.4
            }
            z: 20
            property bool running: false
            MouseArea {
                id: motor_area
                enabled: river.level > 0.2
                anchors.fill: parent
                onClicked: {
                    items.audioEffects.play('qrc:/gcompris/src/activities/watercycle/resource/bubble.wav');
                    info.setKey('tower');
                    waterplant.running = true;
                }
            }
        }

        Image {
            id: fillpipe
            anchors.fill: layoutArea
            sourceSize.width: width
            source: activity.url + "fillwater.svg"
            opacity: waterplant.running ? 1 : 0.1
            z: 9
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 300 } }
        }

        Image {
            id: sewageplant
            source: activity.url + "waste.svg"
            height: layoutArea.height * 0.15
            sourceSize.height: height
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.74
                leftMargin: layoutArea.width * 0.66
            }
            z: 11
            property bool running: false
            MouseArea {
                id: waste_area
                enabled: river.opacity == 1
                anchors.fill: parent
                onClicked: {
                    items.audioEffects.play('qrc:/gcompris/src/activities/watercycle/resource/bubble.wav');
                    info.setKey('shower');
                    sewageplant.running = true;
                }
            }
        }

        Image {
            id: wastepipe
            anchors.fill: layoutArea
            sourceSize.width: width
            source: activity.url + "wastewater.svg"
            opacity: sewageplant.running ? 1 : 0.1
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 300 } }
        }

        Image {
            id: tower
            source: activity.url + "watertower.svg"
            width: layoutArea.width * 0.18
            height: layoutArea.height * 0.15
            sourceSize.width: width
            sourceSize.height: height
            anchors {
                top: layoutArea.top
                right: layoutArea.right
                topMargin: layoutArea.height * 0.225
                rightMargin: layoutArea.width * 0.175
            }
            z: 10
            property double level: 0

            Image {
                id: towerfill
                scale: tower.level
                source: activity.url + "watertowerfill.svg"
                width: tower.width * 0.4
                sourceSize.width: width
                anchors {
                    top: tower.top
                    left: tower.left
                    topMargin: tower.height * 0.13
                    leftMargin: tower.width * 0.3
                }
                Behavior on scale { PropertyAnimation { duration: timer.interval } }
            }
        }

        Image {
            id: shower
            source: activity.url + "shower.svg"
            height: layoutArea.height * 0.2
            width: layoutArea.width * 0.15
            sourceSize.height: height
            sourceSize.width: width
            anchors {
                bottom: layoutArea.bottom
                right: layoutArea.right
                bottomMargin: layoutArea.height * 0.32
                rightMargin: layoutArea.width * 0.012
            }
            z: 10
            visible: false
            property bool on: false

            MouseArea {
                id: shower_area
                anchors.fill: parent
                onClicked: {
                    if(!shower.on &&
                            wastepipe.opacity > 0.8 &&
                            fillpipe.opacity > 0.8 && tower.level > 0.5)
                        shower.start();
                    else
                        shower.stop();
                }
            }

            function start() {
                shower.on = true;
                shower.visible = true;
                showerhot.visible = true;
                tuxbath.visible = true;
                showercold.visible = false;
                tuxoff.visible = false;

                if(!items.cycleDone) {
                    info.setKey('done');
                    bonus.good('smiley');
                    items.cycleDone = true;
                }
                items.audioEffects.play('qrc:/gcompris/src/activities/watercycle/resource/apert.wav');
            }

            function stop() {
                shower.on = false;
                shower.visible = true;
                showerhot.visible = false;
                tuxbath.visible = false;
                showercold.visible = true;
                tuxoff.visible = true;
            }
            function hide() {
                shower.visible = false;
                shower.on = false;
                tuxoff.visible = false;
                showercold.visible = false;
                showerhot.visible = false;
                tuxbath.visible = false;
            }
        }

        Image {
            id: tuxoff
            source:activity.url + "tuxoff.svg"
            width: shower.height * 0.4
            sourceSize.width: width
            anchors {
                horizontalCenter: shower.horizontalCenter
                verticalCenter: shower.verticalCenter
                verticalCenterOffset: shower.height * 0.1
                horizontalCenterOffset: -shower.width * 0.05
            }
            z: 10
            visible: false
        }

        Image {
            id: tuxbath
            source: activity.url + "tuxbath.svg"
            width: shower.height * 0.5
            sourceSize.width: width
            anchors {
                horizontalCenter: shower.horizontalCenter
                verticalCenter: shower.verticalCenter
                verticalCenterOffset: shower.height * 0.1
                horizontalCenterOffset: -shower.width * 0.05
            }
            z: 10
            visible: false
        }

        Image {
            id: showerhot
            source: activity.url + "showerhot.svg"
            width: shower.width * 0.1
            sourceSize.width: width
            anchors {
                right: shower.right
                top: shower.top
                rightMargin: shower.width * 0.15
                topMargin: shower.height * 0.25
            }
            z: 10
            visible: false
        }

        Image {
            id: showercold
            source: activity.url + "showercold.svg"
            width: shower.width * 0.1
            sourceSize.width: width
            anchors {
                right: shower.right
                top: shower.top
                rightMargin: shower.width * 0.15
                topMargin: shower.height * 0.25
            }
            z: 10
            visible: false
        }

        // Manage stuff that changes periodically
        Timer {
            id: timer
            interval: 100
            running: true
            repeat: true
            onTriggered: {
                if(rain.opacity > 0.9 && river.level < 1) {
                    river.level += 0.01;
                }
                if(river.level > 0 && fillpipe.opacity > 0.9 && tower.level < 1 && !shower.on) {
                    river.level -= 0.02;
                    tower.level += 0.05;
                }
                if(tower.level > 0 && shower.on) {
                    tower.level -= 0.02;
                }
                if(tower.level <= 0 && boatparked.opacity) {
                    shower.stop();
                }
            }
        }

        GCText {
            id: info
            visible: false
            fontSize: smallSize
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: parent.top
                topMargin: 10 * ApplicationInfo.ratio
                right: parent.right
                rightMargin: 5 * ApplicationInfo.ratio
                left: parent.left
                leftMargin: items.isVertical ? rightMargin : parent.width * 0.50
            }
            width: parent.width
            wrapMode: Text.WordWrap
            z: 100
            onTextChanged: textanim.start();
            property string newKey

            SequentialAnimation {
                id: textanim
                NumberAnimation {
                    target: info
                    property: "opacity"
                    duration: 200
                    from: 1
                    to: 0
                }
                ScriptAction {
                    script: if(items.cycleDone && info.newKey != "done") info.visible = false;
                }
                PropertyAction {
                    target: info
                    property: 'text'
                    value: items.dataset[info.newKey]
                }
                NumberAnimation {
                    target: info
                    property: "opacity"
                    duration: 200
                    from: 0
                    to: 1
                }
            }

            function setKey(key) {
                if(newKey != key) {
                    newKey = key;
                    textanim.start();
                }
            }
        }

        Rectangle {
            id: infoBg
            z: 99
            anchors.fill: info
            color: '#B0D2D2D2'
            radius: width * 0.01
            opacity: info.text ? 0.7 : 0
            visible: info.visible
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home();
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload}
            onHelpClicked: {
                displayDialog(dialogHelp);
            }
            onHomeClicked: {
                if(message.visible)
                    message.visible = false;
                home();
            }
            onReloadClicked: initLevel();
        }

        Bonus {
            id:bonus
        }

    }
}
