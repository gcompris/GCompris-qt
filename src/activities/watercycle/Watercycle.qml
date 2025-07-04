/* GCompris - watercycle.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>(GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Big refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick
import core 1.0

import "../../core"

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
        sourceSize.width: width
        sourceSize.height: height

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: [message]

        onStart: {}
        onStop: {
            tuxboat.state = "tuxboatRestarted"
            timer.stop()
            harbor1Sound.stop()
            harbor2Sound.stop()
            waterSound.stop()
            bubbleSound.stop()
            apertSound.stop()
        }

        function initLevel() {
            if(message.visible)
                return;
            timer.stop();
            items.cycleDone = false;
            river.level = 0;
            sun_area.enabled = true;
            sun.state = "sunDown";
            sun.hasRun = false;
            vapor.animLoop = false;
            vapor.state = "vaporDownRestarted";
            rainAnim.stop();
            rain.down();
            cloud.isUp = false;
            tuxboat.state = "tuxboatRestarted";
            boatparked.opacity = 1;
            shower.stop();
            waterplant.running = false;
            sewageplant.running = false;
            tower.level = 0;
            infoPanel.setKey('start');
            infoPanel.visible = true;
            timer.restart();
        }

        GCSoundEffect {
            id: harbor1Sound
            source: "qrc:/gcompris/src/activities/watercycle/resource/harbor1.wav"
        }

        GCSoundEffect {
            id: harbor2Sound
            source: "qrc:/gcompris/src/activities/watercycle/resource/harbor2.wav"
        }

        GCSoundEffect {
            id: bleepSound
            source: "qrc:/gcompris/src/core/resource/sounds/bleep.wav"
        }

        GCSoundEffect {
            id: waterSound
            source: "qrc:/gcompris/src/core/resource/sounds/water.wav"
        }

        GCSoundEffect {
            id: bubbleSound
            source: "qrc:/gcompris/src/activities/watercycle/resource/bubble.wav"
        }

        GCSoundEffect {
            id: apertSound
            source: "qrc:/gcompris/src/activities/watercycle/resource/apert.wav"
        }

        QtObject {
            id: items
            property var dataset: {
                "none": "",
                "start": qsTr("The sun is the main component of the water cycle. Click on the sun to start the water cycle."),
                "sun": qsTr("As the sun rises, the water of the sea starts heating and evaporates."),
                "cloud": qsTr("Water vapor condenses to form clouds and when clouds become heavy, it rains. Click on the cloud."),
                "rain": qsTr("The rain causes rivers to swell up and this water is transported to us via motor pumps through water-towers." +
                             " Click on the motor pump to supply water to residents."),
                "tower": qsTr("See the tower filled with water. Activate the sewage treatment station by clicking on it."),
                "shower": qsTr("Great, click on the shower, as Tux arrives home."),
                "done":  qsTr("Fantastic, you have completed the water cycle. You can continue playing.")
            }

            property bool cycleDone: false
            property bool isVertical: activityBackground.width < activityBackground.height - bar.height * 1.2
            property bool textOnSide: activityBackground.width > layoutArea.width * 1.5
        }

        IntroMessage {
            id: message
            z: 100
            onIntroDone: {
                tuxboat.state = "tuxboatRight";
                sun.state = "sunDown";
                infoPanel.setKey('start');
                sun_area.enabled = true;
            }
            intro: ListModel {
                ListElement {
                    text: qsTr("The water cycle (also known as the hydrologic cycle) is the journey water takes as it circulates from the land to the sky and back again. The sun's heat provides energy to evaporate water from water bodies like oceans.")
                }
                ListElement {
                    text: qsTr("Plants also lose water to the air through transpiration. The water vapor cools down forming tiny droplets in clouds. When the clouds meet cool air over the land, precipitation is triggered and falls down as rain.")
                }
                ListElement {
                    text: qsTr("Some of the water is trapped between rock or clay layers, called groundwater. But most of the water flows as runoff, eventually returning to the seas via rivers.")
                }
                ListElement {
                    text: qsTr("Your goal is to complete the water cycle before Tux reaches home. Click on the different components which make up the water cycle. First click on the sun, then on the cloud, the water pumping station near the river, the sewage treatment, and at last regulate the switch to provide water to Tux's shower.")
                }
            }
        }

        Item {
            id: layoutArea
            width: parent.height - bar.height * 1.2
            height: width
            anchors.left: activityBackground.left
            states: [
                State {
                    name: "verticalLayout"
                    when: items.isVertical
                    PropertyChanges {
                        layoutArea {
                            width: activityBackground.width
                            anchors.bottomMargin: bar.height * 0.2
                            anchors.leftMargin: 0
                        }
                    }
                    AnchorChanges {
                        target: layoutArea
                        anchors.top: undefined
                        anchors.bottom: bar.top
                    }
                },
                State {
                    name: "horizontalLayout"
                    when: !items.isVertical
                    PropertyChanges {
                        layoutArea {
                            width: activityBackground.height - bar.height * 1.2
                            anchors.bottomMargin: 0
                            anchors.leftMargin: GCStyle.baseMargins
                        }
                    }
                    AnchorChanges {
                        target: layoutArea
                        anchors.top: activityBackground.top
                        anchors.bottom: undefined
                    }
                }
            ]
        }

        Image {
            id: sky
            anchors.top: layoutArea.top
            anchors.left: layoutArea.left
            width: layoutArea.width
            height: layoutArea.height * 0.305
            sourceSize.width: width
            sourceSize.height: height
            source: activity.resourceUrl + "sky.svg"
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
            source: activity.resourceUrl + "sea.svg"
            z: 3
        }

        Image {
            id: landscape
            anchors.fill: layoutArea
            sourceSize.width: width
            sourceSize.height: height
            source: activity.resourceUrl + "landscape.svg"
            z: 6
        }

        Image {
            id: tuxboat
            opacity: 1
            source: activity.resourceUrl + "boat.svg"
            width: layoutArea.width * 0.12
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            anchors{
                bottom: layoutArea.bottom
                bottomMargin: layoutArea.height * 0.02
                left: layoutArea.left
                leftMargin: 0
            }
            z: 30
            state: "tuxboatLeft"

            states: [
                State {
                    name: "tuxboatLeft"
                    PropertyChanges {
                        tuxboat {
                            anchors.leftMargin: 0
                            opacity: 1
                        }
                    }
                },
                State {
                    name: "tuxboatRight"
                    PropertyChanges {
                        tuxboat {
                            anchors.leftMargin: layoutArea.width - tuxboat.width
                            opacity: 0
                        }
                    }
                },
                State {
                    name: "tuxboatRestarted"
                    PropertyChanges {
                        tuxboat {
                            anchors.leftMargin: layoutArea.width - tuxboat.width
                            opacity: 0
                        }
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "tuxboatLeft"; to: "tuxboatRight";
                    SequentialAnimation {
                        ScriptAction { script: harbor1Sound.play() }
                        NumberAnimation { property: "tuxboat.anchors.leftMargin"; easing.type: Easing.InOutSine; duration: 15000 }
                        ScriptAction { script: harbor2Sound.play() }
                        NumberAnimation { property: "tuxboat.opacity"; easing.type: Easing.InOutQuad; duration: 200 }
                        ScriptAction { script: {
                                boatparked.opacity = 1;
                                shower.stop();
                            }
                        }
                    }
                },
                Transition {
                    from: "tuxboatRight"; to: "tuxboatLeft";
                    PropertyAction { properties: "tuxboat.anchors.leftMargin, tuxboat.opacity" }
                    ScriptAction { script: boatparked.opacity = 0 }
                },
                Transition {
                    from: "tuxboatRight, tuxboatLeft"; to: "tuxboatRestarted"
                    PropertyAction { properties: "tuxboat.anchors.leftMargin, tuxboat.opacity" }
                }
            ]
        }

        Image {
            id: boatparked
            source: activity.resourceUrl + "boat_parked.svg"
            width: layoutArea.width * 0.12
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
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
            source: activity.resourceUrl + "sun.svg"
            width: layoutArea.width * 0.1
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            anchors {
                left: layoutArea.left
                top: layoutArea.top
                leftMargin: layoutArea.width * 0.056
                topMargin: layoutArea.height * 0.056
            }
            z: 2
            property bool hasRun: false
            MouseArea {
                id: sun_area
                anchors.fill: sun
                onClicked: {
                    if(cloud.opacity == 0)
                        sun.state = "sunUp";
                }
            }
            state: "sunUp"

            states: [
                State {
                    name: "sunDown"
                    PropertyChanges {
                        sun {
                            anchors.topMargin: layoutArea.height * 0.256
                        }
                    }
                },
                State {
                    name: "sunUp"
                    PropertyChanges {
                        sun {
                            anchors.topMargin: layoutArea.height * 0.056
                        }
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "sunUp"; to: "sunDown";
                    NumberAnimation { property: "sun.anchors.topMargin"; easing.type: Easing.InOutQuad; duration: 5000 }
                },
                Transition {
                    from: "sunDown"; to: "sunUp";
                    ScriptAction { script: {
                            bleepSound.play();
                            infoPanel.setKey('sun');
                            sun.hasRun = true;
                            vapor.animLoop = true;
                            vapor.state = "vaporUp";
                            cloud.isUp = true;
                        }
                    }
                    NumberAnimation { property: "sun.anchors.topMargin"; easing.type: Easing.InOutQuad; duration: 5000 }
                }
            ]
        }

        Image {
            id: vapor
            opacity: 0
            source: activity.resourceUrl + "vapor.svg"
            width: layoutArea.width * 0.1
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            property bool animLoop: false
            anchors {
                left: sun.left
                top: layoutArea.top
                topMargin: layoutArea.height * 0.28
            }
            z: 10
            state: "vaporDown"

            states: [
                State {
                    name: "vaporDown"
                    PropertyChanges {
                        vapor {
                            opacity: 0
                            anchors.topMargin: layoutArea.height * 0.28
                        }
                    }
                },
                State {
                    name: "vaporUp"
                    PropertyChanges {
                        vapor {
                            opacity: 1
                            anchors.topMargin: layoutArea.height * 0.1
                        }
                    }
                },
                State {
                    name: "vaporDownRestarted"
                    PropertyChanges {
                        vapor {
                            opacity: 0
                            anchors.topMargin: layoutArea.height * 0.28
                        }
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "vaporDown, vaporDownRestarted"; to: "vaporUp";
                    SequentialAnimation {
                        NumberAnimation { property: "vapor.opacity"; duration: 200 }
                        NumberAnimation { property: "vapor.anchors.topMargin"; duration: 5000 }
                        ScriptAction { script: vapor.state = "vaporDown" }
                    }
                },
                Transition {
                    from: "vaporUp"; to: "vaporDown";
                    SequentialAnimation {
                        NumberAnimation { property: "vapor.opacity"; duration: 200 }
                        PropertyAction { property: "vapor.anchors.topMargin" }
                        ScriptAction { script: {
                                if(vapor.animLoop === true) {
                                    vapor.animLoop = false;
                                    vapor.state = "vaporUp";
                                } else {
                                    infoPanel.setKey("cloud");
                                }
                            }
                        }
                    }
                },
                Transition {
                    from: "vaporUp, vaporDown"; to: "vaporDownRestarted";
                    ScriptAction { script: vapor.animLoop = false }
                    PropertyAction { properties: "vapor.anchors.topMargin, vapor.opacity" }
                }
            ]
        }

        Image {
            id: cloud
            opacity: 0
            source: activity.resourceUrl + "cloud.svg"
            sourceSize.width: layoutArea.width * 0.256
            fillMode: Image.PreserveAspectFit
            width: 0
            property bool isUp: false
            property double originMargin: layoutArea.width * 0.05
            property double upMargin: layoutArea.width * 0.38
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
                        cloud {
                            opacity: 0
                            width: 0
                            anchors.leftMargin: cloud.originMargin
                        }
                    }
                },
                State {
                    name: "cloudIsUp"
                    when: cloud.isUp
                    PropertyChanges {
                        cloud {
                            opacity: 1
                            width: cloud.sourceSize.width
                            anchors.leftMargin: cloud.upMargin
                        }
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "cloudIsDown"; to: "cloudIsUp";
                    NumberAnimation { property: "cloud.opacity"; easing.type: Easing.InOutQuad; duration: 5000 }
                    NumberAnimation { properties: "cloud.width, cloud.anchors.leftMargin"; easing.type: Easing.InOutQuad; duration: 15000 }
                },
                Transition {
                    from: "cloudIsUp"; to: "cloudIsDown";
                    PropertyAction { properties: "cloud.opacity, cloud.width, cloud.anchors.leftMargin" }
                }
            ]

            MouseArea {
                id: cloud_area
                anchors.fill: cloud
                enabled: infoPanel.newKey === 'cloud'
                onClicked: {
                    sun.state = "sunDown";
                    rain.up();
                }
            }
        }

        Image {
            id: rain
            source: activity.resourceUrl + "rain.svg"
            width: layoutArea.height * 0.146
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            opacity: 0
            anchors {
                top: layoutArea.top
                topMargin: layoutArea.width * 0.123
                left: cloud.left
                leftMargin: cloud.width * 0.25
            }
            z: 12
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
                waterSound.play();
                infoPanel.setKey('rain');
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
            source: activity.resourceUrl + "river.svg"
            width: layoutArea.width * 0.431
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            opacity: level > 0 ? 1 : 0
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.3309
                leftMargin: layoutArea.width * 0.292
            }
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
            property double level: 0
        }

        Image {
            id: reservoir1
            source: activity.resourceUrl + "reservoir1.svg"
            width: layoutArea.width * 0.112
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.3309
                leftMargin: layoutArea.width * 0.2948
            }
            opacity: river.level > 0.2 ? 1 : 0
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        }

        Image {
            id: reservoir2
            source: activity.resourceUrl + "reservoir2.svg"
            width: layoutArea.width * 0.1604
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.3309
                leftMargin: layoutArea.width * 0.2691
            }
            opacity: river.level > 0.5 ? 1 : 0
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        }

        Image {
            id: reservoir3
            source: activity.resourceUrl + "reservoir3.svg"
            width: layoutArea.width * 0.1965
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.3309
                leftMargin: layoutArea.width * 0.2532
            }
            opacity: river.level > 0.8 ? 1 : 0
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        }

        Image {
            id: waterplant
            source: activity.resourceUrl + "motor.svg"
            width: layoutArea.width * 0.083
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.367
                leftMargin: layoutArea.width * 0.371
            }
            z: 20
            property bool running: false
            MouseArea {
                id: motor_area
                enabled: river.level > 0.2
                anchors.fill: parent
                onClicked: {
                    bubbleSound.play();
                    infoPanel.setKey('tower');
                    waterplant.running = true;
                }
            }
        }

        Image {
            id: fillpipe
            width: layoutArea.width * 0.354
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            source: activity.resourceUrl + "fillwater.svg"
            opacity: waterplant.running ? 1 : 0.2
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.405
                leftMargin: layoutArea.width * 0.422
            }
            z: 9
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 300 } }
        }

        Image {
            id: sewageplant
            source: activity.resourceUrl + "waste.svg"
            height: layoutArea.height * 0.144
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.778
                leftMargin: layoutArea.width * 0.682
            }
            z: 11
            property bool running: false
            MouseArea {
                id: waste_area
                enabled: river.opacity == 1 && waterplant.running
                anchors.fill: parent
                onClicked: {
                    bubbleSound.play();
                    infoPanel.setKey('shower');
                    sewageplant.running = true;
                }
            }
        }

        Image {
            id: wastepipe
            width: layoutArea.width * 0.275
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            source: activity.resourceUrl + "wastewater.svg"
            opacity: sewageplant.running ? 1 : 0.2
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.597
                leftMargin: layoutArea.width * 0.536
            }
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 300 } }
        }

        Image {
            id: tower
            source: activity.resourceUrl + "watertower.svg"
            width: layoutArea.width * 0.135
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.226
                leftMargin: layoutArea.width * 0.686
            }
            z: 10
            property double level: 0

            Image {
                id: towerfill
                scale: tower.level
                source: activity.resourceUrl + "watertowerfill.svg"
                width: tower.width * 0.5
                sourceSize.width: width
                fillMode: Image.PreserveAspectFit
                anchors {
                    top: tower.top
                    topMargin: tower.height * 0.085
                    horizontalCenter: tower.horizontalCenter
                }
                Behavior on scale { PropertyAnimation { duration: timer.interval } }
            }
        }

        Image {
            id: shower
            source: activity.resourceUrl + "shower.svg"
            width: layoutArea.width * 0.184
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.557
                leftMargin: layoutArea.width * 0.791
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
                tuxbath.visible = true;

                if(!items.cycleDone) {
                    infoPanel.setKey('done');
                    bonus.good('smiley');
                    items.cycleDone = true;
                }
                apertSound.play();
            }

            function stop() {
                shower.on = false;
                shower.visible = true;
                tuxbath.visible = false;
            }
            function hide() {
                shower.visible = false;
                shower.on = false;
                tuxbath.visible = false;
            }
        }

        Image {
            id: tuxbath
            source: activity.resourceUrl + "tuxbath.svg"
            width: shower.width
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: shower
            z: 10
            visible: false
        }

        Image {
            id: city
            source: activity.resourceUrl + "city.svg"
            width: layoutArea.width * 0.202
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.465
                leftMargin: layoutArea.width * 0.44
            }
            z: 10
        }

        Image {
            id: tuxHouse
            source: activity.resourceUrl + "tuxHouse.svg"
            width: layoutArea.width * 0.036
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.638
                leftMargin: layoutArea.width * 0.765
            }
            z: 10
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

        GCTextPanel {
            id: infoPanel
            z: 100
            color: "#b2d2d2d2"
            border.width: 0
            panelWidth: 10 // set in states but is required so need an init value
            panelHeight: layoutArea.height - GCStyle.halfMargins
            opacity: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.halfMargins
            textItem.color: GCStyle.darkText
            textItem.fontSize: textItem.smallSize
            textItem.wrapMode: Text.WordWrap
            textItem.onTextChanged: textanim.start();
            property string newKey

            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }

            states: [
                State {
                    name: "verticalInfo"
                    when: items.isVertical
                    PropertyChanges {
                        infoPanel {
                            panelWidth: layoutArea.width
                            anchors.horizontalCenterOffset: 0
                        }
                    }
                },
                State {
                    name: "horizontalInfoSide"
                    when: !items.isVertical && items.textOnSide
                    PropertyChanges {
                        infoPanel {
                            panelWidth: activityBackground.width - layoutArea.width - 3 * GCStyle.halfMargins
                            anchors.horizontalCenterOffset: layoutArea.width * 0.5 + GCStyle.halfMargins
                        }
                    }
                },
                State {
                    name: "horizontalInfoOver"
                    when: !items.isVertical && !items.textOnSide
                    PropertyChanges {
                        infoPanel {
                            panelWidth: (activityBackground.width - 3 * GCStyle.halfMargins) * 0.5
                            anchors.horizontalCenterOffset: infoPanel.panelWidth * 0.5
                        }
                    }
                }
            ]

            SequentialAnimation {
                id: textanim
                NumberAnimation {
                    target: infoPanel
                    property: "opacity"
                    duration: 200
                    to: 0
                }
                ScriptAction {
                    script: if(items.cycleDone && infoPanel.newKey != "done") infoPanel.visible = false;
                }
                PropertyAction {
                    target: infoPanel.textItem
                    property: 'text'
                    value: items.dataset[infoPanel.newKey]
                }
                NumberAnimation {
                    target: infoPanel
                    property: "opacity"
                    duration: 200
                    from: 0
                    to: 1
                }
            }

            function setKey(key: string) {
                if(newKey != key) {
                    newKey = key;
                    textanim.start();
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: activity.home();
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload}
            onHelpClicked: {
                activity.displayDialog(dialogHelp);
            }
            onHomeClicked: activity.home()
            onReloadClicked: activityBackground.initLevel();
        }

        Bonus {
            id:bonus
        }

    }
}
