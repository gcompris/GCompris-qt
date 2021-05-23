/* GCompris - watercycle.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>(GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
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
    property var barAtStart

    pageComponent: Item {
        id: background
        anchors.fill: parent

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart: {
            barAtStart = ApplicationSettings.isBarHidden;
            ApplicationSettings.isBarHidden = true;
            shower.hide();
            river.level = 0;
        }

        onStop: {
            ApplicationSettings.isBarHidden = barAtStart;
        }

        function initLevel() {
            if(message.visible)
                return;
            items.restarted = true;
            timer.stop();
            items.cycleDone = false;
            river.level = 0;
            sun_area.enabled = true;
            sun.down();
            sun.hasRun = false;
            vaporAnim.stop();
            vapor.opacity = 0;
            vapor.y = background.height * 0.28
            rainAnim.stop();
            rain.down();
            cloudanimOn.stop();
            cloudanimOff.stop();
            cloud.down();
            tuxboat.opacity = 0;
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
                anim.running = true;
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

        Image {
            id: sky
            anchors.top: parent.top
            sourceSize.width: parent.width
            source: activity.url + "sky.svg"
            height: (background.height - landscape.paintedHeight) / 2 + landscape.paintedHeight * 0.3
            z: 1
        }

        Image {
            id: sea
            anchors {
                left: parent.left
                bottom: parent.bottom
            }
            sourceSize.width: parent.width
            source: activity.url + "sea.svg"
            height: (background.height - landscape.paintedHeight) / 2 + landscape.paintedHeight * 0.7
            z:3
        }

        Image {
            id: landscape
            anchors.fill: parent
            sourceSize.width: parent.width
            source: activity.url + "landscape.svg"
            z: 6
        }

        Image {
            id: tuxboat
            opacity: 1
            source: activity.url + "boat.svg"
            sourceSize.width: parent.width*0.15
            sourceSize.height: parent.height*0.15
            anchors{
                bottom: parent.bottom
                bottomMargin: 15
            }
            x:0
            z:30

            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
            NumberAnimation on x {
                id: anim
                running: false
                to: parent.width - tuxboat.width
                duration: 15000
                easing.type: Easing.InOutSine
                onRunningChanged: {
                    if(!anim.running)
                    {
                        items.audioEffects.play('qrc:/gcompris/src/activities/watercycle/resource/harbor2.wav');
                        tuxboat.opacity = 0;
                        boatparked.opacity = 1;
                        shower.stop();
                        if(!sun.hasRun && !items.restarted)
                            info.setKey('start');
                    } else {
                        items.audioEffects.play('qrc:/gcompris/src/activities/watercycle/resource/harbor1.wav');
                    }
                }
            }
        }

        Image {
            id: boatparked
            source: activity.url + "boat_parked.svg"
            sourceSize.width: parent.width*0.15
            sourceSize.height: parent.height*0.15
            opacity: 0
            anchors {
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 20
            }
            z: 29
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
        }

        Image {
            id: sun
            source: activity.url + "sun.svg"
            sourceSize.width: parent.width * 0.05
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: parent.width*0.05
                topMargin: parent.height * 0.28
            }
            z: 2
            property bool hasRun: false
            MouseArea {
                id: sun_area
                anchors.fill: sun
                onClicked: {
                    if(cloud.opacity == 0)
                        sun.up();
                }
            }
            Behavior on anchors.topMargin { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
            function up() {
                items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/bleep.wav');
                info.setKey('sun');
                sun.hasRun = true;
                sun.anchors.topMargin = parent.height * 0.05;
                vapor.up();
            }
            function down() {
                sun.anchors.topMargin = parent.height * 0.28;
            }
        }

        Image {
            id: vapor
            opacity: 0
            state: "vapor"
            source: activity.url + "vapor.svg"
            sourceSize.width: parent.width*0.05
            anchors {
                left: sun.left
            }
            y: background.height * 0.28
            z: 10

            SequentialAnimation {
                id: vaporAnim
                loops: 2
                NumberAnimation {
                    target: vapor
                    property: "opacity"
                    duration: 200
                    from: 0
                    to: 1
                }
                NumberAnimation {
                    target: vapor
                    property: "y"
                    duration: 5000
                    from: background.height * 0.28
                    to: background.height * 0.1
                }
                NumberAnimation {
                    target: vapor
                    property: "opacity"
                    duration: 200
                    from: 1
                    to: 0
                }
                NumberAnimation {
                    target: vapor
                    property: "y"
                    duration: 0
                    to: background.height * 0.28
                }
                onRunningChanged: {
                    if(!running && !items.restarted)
                        info.setKey('cloud');
                }
            }
            function up() {
                vaporAnim.start();
                cloud.up();
            }
        }


        Image {
            id: cloud
            opacity: 0
            source: activity.url + "cloud.svg"
            sourceSize.width: parent.width * 0.20
            fillMode: Image.PreserveAspectFit
            width: 0
            anchors {
                top: parent.top
                topMargin: parent.height * 0.05
            }
            x: parent.width * 0.05
            z: 11
            MouseArea {
                id: cloud_area
                anchors.fill: cloud
                enabled: info.newKey === 'cloud'
                onClicked: {
                    sun.down();
                    rain.up();
                }
            }
            ParallelAnimation {
                id: cloudanimOn
                running: false
                PropertyAnimation {
                    target: cloud
                    property: 'opacity'
                    easing.type: Easing.InOutQuad
                    duration: 5000
                    from: 0
                    to: 1
                }
                PropertyAnimation {
                    target: cloud
                    property: 'width'
                    easing.type: Easing.InOutQuad
                    duration: 15000
                    from: 0
                    to: cloud.sourceSize.width
                }
                PropertyAnimation {
                    target: cloud
                    property: 'x'
                    easing.type: Easing.InOutQuad
                    duration: 15000
                    from: background.width * 0.05
                    to: background.width * 0.4
                }
            }
            SequentialAnimation {
                id: cloudanimOff
                running: false
                PropertyAnimation {
                    target: cloud
                    property: 'opacity'
                    easing.type: Easing.InOutQuad
                    duration: 3000
                    from: 1
                    to: 0
                }
                PropertyAnimation {
                    target: cloud
                    property: 'width'
                    easing.type: Easing.InOutQuad
                    duration: 0
                    to: 0
                }
                PropertyAnimation {
                    target: cloud
                    property: 'x'
                    easing.type: Easing.InOutQuad
                    duration: 0
                    to: background.width * 0.05
                }
            }

            function up() {
                cloudanimOn.start();
            }
            function down() {
                opacity = 0;
                width = 0;
                x = parent.width * 0.05;
            }
        }

        Image {
            id: rain
            source: activity.url + "rain.svg"
            sourceSize.height: cloud.height * 2
            opacity: 0
            anchors {
                top: cloud.bottom
            }
            x: cloud.x
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
                        cloud.down();
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
            sourceSize.width: parent.width * 0.415
            sourceSize.height: parent.height * 0.74
            width: parent.width * 0.415
            height: parent.height * 0.74
            opacity: level > 0 ? 1 : 0
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height*0.1775
                leftMargin: parent.width*0.293
            }
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
            property double level: 0
        }

        Image {
            id: reservoir1
            source: activity.url + "reservoir1.svg"
            sourceSize.width: parent.width*0.06
            width: parent.width*0.06
            height: parent.height*0.15
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height*0.2925
                leftMargin: parent.width*0.3225
            }
            opacity: river.level > 0.2 ? 1 : 0
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        }

        Image {
            id: reservoir2
            source: activity.url + "reservoir2.svg"
            sourceSize.width: parent.width*0.12
            width: parent.width*0.12
            height: parent.height*0.155
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height*0.2925
                leftMargin: parent.width*0.285
            }
            opacity: river.level > 0.5 ? 1 : 0
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        }

        Image {
            id: reservoir3
            source: activity.url + "reservoir3.svg"
            sourceSize.width: parent.width*0.2
            width: parent.width*0.2
            height: parent.height*0.17
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height*0.29
                leftMargin: parent.width*0.25
            }
            opacity: river.level > 0.8 ? 1 : 0
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 5000 } }
        }

        Image {
            id: waterplant
            source: activity.url + "motor.svg"
            sourceSize.width: parent.width*0.07
            sourceSize.height: parent.height*0.08
            anchors {
                top: parent.top
                left:parent.left
                topMargin: parent.height*0.38
                leftMargin: parent.width*0.4
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
            anchors.fill: parent
            sourceSize.width: parent.width
            width: parent.width
            source: activity.url + "fillwater.svg"
            opacity: waterplant.running ? 1 : 0.1
            z: 9
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 300 } }
        }

        Image {
            id: sewageplant
            source: activity.url + "waste.svg"
            sourceSize.height: parent.height * 0.15
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height*0.74
                leftMargin: parent.width*0.66
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
            anchors.fill: parent
            sourceSize.width: parent.width
            width: parent.width
            source: activity.url + "wastewater.svg"
            opacity: sewageplant.running ? 1 : 0.1
            z: 10
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 300 } }
        }

        Image {
            id: tower
            source: activity.url + "watertower.svg"
            sourceSize.width: parent.width*0.18
            sourceSize.height: parent.height*0.15
            anchors {
                top: parent.top
                right: parent.right
                topMargin: parent.height*0.225
                rightMargin: parent.width*0.175
            }
            z: 10
            property double level: 0

            Image {
                id: towerfill
                scale: tower.level
                source: activity.url + "watertowerfill.svg"
                sourceSize.width: tower.width*0.4
                anchors {
                    top: tower.top
                    left:tower.left
                    topMargin: tower.height*0.13
                    leftMargin: tower.width*0.3
                }
                Behavior on scale { PropertyAnimation { duration: timer.interval } }
            }
        }

        Image {
            id: shower
            source: activity.url + "shower.svg"
            sourceSize.height: parent.height*0.2
            sourceSize.width: parent.width*0.15
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: parent.height* 0.32
                rightMargin: parent.width*0.012
            }
            z: 10
            visible: false
            property bool on: false

            MouseArea {
                id: shower_area
                anchors.fill: parent
                onClicked: {
                    if(!shower.on &&
                            river.opacity == 1 && wastepipe.opacity > 0.8 &&
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
            sourceSize.width: shower.height * 0.4
            anchors {
                horizontalCenter: shower.horizontalCenter
                verticalCenter: shower.verticalCenter
                verticalCenterOffset: shower.height*0.1
                horizontalCenterOffset: -shower.width*0.05
            }
            z: 10
            visible: false
        }

        Image {
            id: tuxbath
            source: activity.url + "tuxbath.svg"
            sourceSize.width: shower.height * 0.5
            anchors {
                horizontalCenter: shower.horizontalCenter
                verticalCenter: shower.verticalCenter
                verticalCenterOffset: shower.height*0.1
                horizontalCenterOffset: -shower.width*0.05
            }
            z: 10
            visible: false
        }

        Image {
            id: showerhot
            source: activity.url + "showerhot.svg"
            sourceSize.width: shower.width * 0.1
            anchors {
                right: shower.right
                top: shower.top
                rightMargin: shower.width*0.15
                topMargin: shower.height*0.25
            }
            z: 10
            visible: false
        }

        Image {
            id: showercold
            source: activity.url + "showercold.svg"
            sourceSize.width: shower.width * 0.1
            anchors {
                right: shower.right
                top: shower.top
                rightMargin: shower.width*0.15
                topMargin: shower.height*0.25
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
            visible: true
            fontSize: smallSize
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: parent.top
                topMargin: 10 *ApplicationInfo.ratio
                right: parent.right
                rightMargin: 5 * ApplicationInfo.ratio
                left: parent.left
                leftMargin: parent.width * 0.50
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
            color: '#8ebfc7'
            radius: width * 0.01
            opacity: info.text ? 0.7 : 0
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
