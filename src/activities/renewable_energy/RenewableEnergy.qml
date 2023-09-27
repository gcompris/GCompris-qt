/* GCompris - renewable_energy.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Big refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/renewable_energy/resource/"
    property string url2: "qrc:/gcompris/src/activities/watercycle/resource/"

    pageComponent: Image {
        id: background
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

        // Add here the QML items you need to access in javascript

        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property bool isVertical: background.width < background.height - bar.height * 1.2
            property alias bonus: bonus
            property GCSfx audioEffects: activity.audioEffects
            // we initialize it to -1, so onStart it forces a layout refresh when it's set to 0
            property int currentLevel: -1
            property int numberOfLevel: 3
            property bool sunIsUp: true
            property color consumeColor: "#E09C4C"
            property color consumeColorBorder: "#81531E"
            property color produceColor: "#E9E87F"
            property color produceColorBorder: "#82811E"
            property bool hasWon: false

            onSunIsUpChanged: {
                if(sunIsUp)
                    sun.state = "sunUp"
                else
                    sun.state = "sunDown"
            }
        }

        onStart: items.currentLevel = Core.getInitialLevel(items.numberOfLevel);
        onStop: {
            hydro.item.stopTimer();
            if(wind.item)
                wind.item.stopTimer();
        }

        function initLevel() {
            if(message.visible)
                return;
            residentSmallSwitch.on = false
            residentBigSwitch.on = false
            tuxSwitch.on = false
            stepDown.started = false
            hydro.item.stop()
            if(wind.item)
                wind.item.stop()
            if(solar.item)
                solar.item.stop()
        }

        function nextLevel() {
            if(items.numberOfLevel <= ++items.currentLevel) {
                // Stay on the last level
                items.currentLevel = items.numberOfLevel - 1
            }
        }

        function previousLevel() {
            items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
        }

        function checkForNextLevel() {
            switch(items.currentLevel) {
                case 0:
                    if(tuxSwitch.on)
                        win()
                    break
                case 1:
                    if(tuxSwitch.on && residentSmallSwitch.on)
                        win()
                    break
                case 2:
                    if(!items.hasWon &&
                            tuxSwitch.on && residentSmallSwitch.on && residentBigSwitch.on) {
                        items.hasWon = true
                        win()
                    }
                    break
            }
        }

        Item {
            id: layoutArea
            width: parent.height - bar.height * 1.2
            height: width
            anchors.horizontalCenter: background.horizontalCenter
            states: [
                State {
                    name: "verticalLayout"
                    when: items.isVertical
                    PropertyChanges {
                        target: layoutArea
                        width: parent.width
                        anchors.bottomMargin: bar.height * 0.2
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
                        target: layoutArea
                        width: parent.height - bar.height * 1.2
                        anchors.bottomMargin: 0
                    }
                    AnchorChanges {
                        target: layoutArea
                        anchors.top: parent.top
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
            source: activity.url2 + "sky.svg"
            visible: true
        }

        Image {
            id: sun
            source: activity.url2 + "sun.svg"
            width: layoutArea.width * 0.1
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            anchors {
                left: layoutArea.left
                top: layoutArea.top
                leftMargin: layoutArea.width * 0.056
                topMargin: layoutArea.height * 0.256
            }

            MouseArea {
                id: sun_area
                anchors.fill: sun
                onClicked: {
                    if(hydro.item.cloudOpacity == 0)
                        items.sunIsUp = true;
                }
            }
            state: "sunUp"
            states: [
                State {
                    name: "sunDown"
                    PropertyChanges {
                        target: sun
                        anchors.topMargin: layoutArea.height * 0.256
                    }
                },
                State {
                    name: "sunUp"
                    PropertyChanges {
                        target: sun
                        anchors.topMargin: layoutArea.height * 0.056
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
                            hydro.item.vaporAnimLoop = true;
                            hydro.item.vaporIsUp = true;
                            hydro.item.cloudIsUp = true;
                        }
                    }
                    NumberAnimation { property: "anchors.topMargin"; easing.type: Easing.InOutQuad; duration: 5000 }
                }
            ]
        }

        Image {
            id: sea
            anchors.left: layoutArea.left
            anchors.bottom: layoutArea.bottom
            width: layoutArea.width
            height: layoutArea.height * 0.7
            sourceSize.width: width
            sourceSize.height: height
            source: activity.url2 + "sea.svg"
        }

        Image {
            id: landscape
            anchors.fill: layoutArea
            sourceSize.width: width
            sourceSize.height: height
            source: activity.url2 + "landscape.svg"
        }

        Loader {
            id: wind
            anchors.fill: layoutArea
            source: items.currentLevel > 0 ? "Wind.qml" : ""
        }

        Loader {
            id: solar
            anchors.fill: layoutArea
            source: items.currentLevel > 1 ? "Solar.qml" : ""
        }

        Loader {
            id: hydro
            anchors.fill: layoutArea
            source: "Hydro.qml"
        }

        IntroMessage {
            id: message
            z: 100
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            onIntroDone: {
                hydro.item.start()
            }
            intro: [
                qsTr("Tux has come back from fishing on his boat. " +
                     "Bring the electrical system back up so he can have light in his home."),
                qsTr("Click on different active elements: sun, cloud, dam, solar array, " +
                     "wind farm and transformers, in order to reactivate the entire electrical system."),
                qsTr("When the system is back up and Tux is in his home, push the light button for him. " +
                     "To win you must switch on all the consumers while all the producers are up."),
                qsTr("Learn about an electrical system based on renewable energy. Enjoy.")
            ]
        }

        Rectangle {
            id: check
            opacity: 0
            width: background.width * 0.9
            height: layoutArea.height * 0.9
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: layoutArea.verticalCenter
            z: 100
            border.width: 2
            radius: 5
            color: "#D2D2D2"
            property bool shown: false

            GCText {
                id: warning
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: parent.height * 0.9
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr( "It is not possible to consume more electricity " +
                           "than what is produced. There is a key limitation in the " +
                           "distribution of electricity, with minor exceptions, " +
                           "electrical energy cannot be stored, and therefore it " +
                           "must be generated as it is needed. A sophisticated " +
                           "system of control is therefore required to ensure electric " +
                           "generation very closely matches the demand. If supply and demand " +
                           "are not in balance, generation plants and transmission equipment " +
                           "can shut down which, in the worst cases, can lead to a major " +
                           "regional blackout.")
                fontSizeMode: Text.Fit
                minimumPointSize: 8
                wrapMode: Text.WordWrap
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: check.opacity > 0
                onClicked: check.opacity = 0
            }
        }

        Image {
            id: stepDown
            z: 50
            source: activity.url + "transformer_off.svg"
            width: layoutArea.width * 0.07
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.width * 0.462
                leftMargin: layoutArea.width * 0.727
            }
            MouseArea {
                anchors.centerIn: parent
                // Size the area for a touch screen
                width: parent.width * 1.2
                height: parent.height * 1.2
                onClicked: {
                    onClicked: parent.started = !parent.started
                }
            }
            property bool started: false
            property int powerIn:
                started ? (hydro.item.power +
                           (wind.item ? wind.item.power : 0) +
                           (solar.item ? solar.item.power : 0)) : 0
            property int powerOut:
                started ? (tux.powerConsumed +
                           residentSmallLights.powerConsumed +
                           residentBigLights.powerConsumed) : 0

            onPowerInChanged: checkPower()

            // Check powerOut does not exceed powerIn. Cut some consumers in case.
            function checkPower() {
                if(powerOut > powerIn && residentBigSwitch.on) {
                    residentBigSwitch.on = false
                    if(!check.shown && powerIn) check.opacity = 1
                }

                if(!started || (powerOut > powerIn && residentSmallSwitch.on)) {
                    residentSmallSwitch.on = false
                    if(!check.shown && powerIn) check.opacity = 1
                }

                if(!started || (powerOut > powerIn && tuxSwitch.on)) {
                    tuxSwitch.on = false
                    if(!check.shown && powerIn) check.opacity = 1
                }
            }
        }

        Image {
            id: stepDownOn
            z: 50
            source: activity.url + "transformer_on.svg"
            anchors.fill: stepDown
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            visible: stepDown.started
        }

        Rectangle {
            id: produceMeter
            width: pow.width * 1.1
            height: pow.height * 1.1
            border.color: items.produceColorBorder
            radius: 5
            color: items.produceColor
            anchors {
                bottom: stepDown.top
                left: stepDown.horizontalCenter
            }
            GCText {
                id: pow
                anchors.centerIn: parent
                fontSize: smallSize * 0.5
                text: stepDown.powerIn.toString() + "W"
            }
        }

        Image {
            id: stepDownWire
            source: activity.url + "hydroelectric/stepdownwire_off.svg"
            width: layoutArea.width * 0.154
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                left: layoutArea.left
                top: layoutArea.top
                leftMargin: layoutArea.width * 0.623
                topMargin: layoutArea.width * 0.503
            }
        }

        Image {
            id: stepDownWireOn
            source: activity.url + "hydroelectric/stepdownwire_on.svg"
            anchors.fill: stepDownWire
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            visible: stepDown.powerIn > 0
        }

        Image {
            id: consumerPole
            source: activity.url + "consumer_pole.svg"
            width: layoutArea.width * 0.037
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                leftMargin: layoutArea.width * 0.681
                topMargin: layoutArea.width * 0.514
            }
        }

        Rectangle {
            id: consumeMeter
            width: stepdown_info.width * 1.1
            height: stepdown_info.height * 1.1
            border.color: items.consumeColorBorder
            radius: 5
            color: items.consumeColor
            anchors {
                bottom: consumerPole.top
                right: consumerPole.horizontalCenter
            }
            GCText {
                id: stepdown_info
                anchors.centerIn: parent
                fontSize: smallSize * 0.5
                text: stepDown.powerOut.toString() + "W"
            }
        }

        Image {
            id: tuxHouse
            source: activity.url2 + "tuxHouse.svg"
            width: layoutArea.width * 0.036
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.638
                leftMargin: layoutArea.width * 0.765
            }
        }

        Image {
            id: tuxHouseOn
            source: activity.url + "tux_house_on.svg"
            anchors.fill: tuxHouse
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            visible: tuxSwitch.on
        }

        Image {
            id: city
            source: activity.url2 + "city.svg"
            width: layoutArea.width * 0.202
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                topMargin: layoutArea.height * 0.465
                leftMargin: layoutArea.width * 0.44
            }
        }

        Image {
            id: residentSmallLights
            source: activity.url + "resident_smallon.svg"
            anchors.fill: city
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            visible: items.currentLevel > 0 && powerConsumed
            property int power: 1000
            property int powerConsumed: on ? power : 0
            property bool on: residentSmallSwitch.on
        }

        Image {
            id: residentSmallSwitch
            visible: items.currentLevel > 0
            source: activity.url + (on ? "on.svg" : "off.svg")
            width: layoutArea.width * 0.053
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                left: layoutArea.left
                top: layoutArea.top
                leftMargin: layoutArea.width * 0.535
                topMargin: layoutArea.height * 0.608
            }
            property bool on: false
            MouseArea {
                id: small_area
                enabled: parent.visible
                anchors.centerIn: parent
                // Size the area for a touch screen
                width: parent.width * 1.2
                height: width
                onClicked: {
                    if(stepDown.powerIn - stepDown.powerOut >= residentSmallLights.power)
                        parent.on = !parent.on
                    else
                        parent.on = false

                    checkForNextLevel()
                }
            }
        }

        Rectangle {
            id: smallConsumeRect
            width: small_consume.width * 1.1
            height: small_consume.height * 1.1
            border.color: items.consumeColorBorder
            radius: 5
            color: items.consumeColor
            anchors {
                top: residentSmallSwitch.bottom
                horizontalCenter: residentSmallSwitch.horizontalCenter
            }
            GCText {
                id: small_consume
                anchors.centerIn: parent
                text: residentSmallLights.powerConsumed.toString() + "W"
                fontSize: smallSize * 0.5
            }
            visible: items.currentLevel > 0
        }

        Image {
            id: residentBigSwitch
            visible: items.currentLevel > 1
            source: activity.url + (on ? "on.svg" : "off.svg")
            width: layoutArea.width * 0.053
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                left: layoutArea.left
                top: layoutArea.top
                leftMargin: layoutArea.width * 0.629
                topMargin: layoutArea.height * 0.608
            }
            property bool on: false
            MouseArea {
                id: big_area
                visible: parent.visible
                anchors.centerIn: parent
                // Size the area for a touch screen
                width: parent.width * 1.2
                height: width
                onClicked: {
                    if(stepDown.powerIn - stepDown.powerOut >= residentBigLights.power)
                        parent.on = !parent.on
                    else
                        parent.on = false

                    checkForNextLevel()
                }
            }
        }

        Rectangle {
            id: bigConsumeRect
            width: bigConsume.width * 1.1
            height: bigConsume.height * 1.1
            border.color: items.consumeColorBorder
            radius : 5
            color: items.consumeColor
            anchors {
                top: residentBigSwitch.bottom
                horizontalCenter: residentBigSwitch.horizontalCenter
            }
            GCText {
                id: bigConsume
                anchors.centerIn: parent
                text: residentBigLights.powerConsumed.toString() + "W"
                fontSize: smallSize * 0.5
            }
            visible: items.currentLevel > 1
        }

        Image {
            id: residentBigLights
            source: activity.url + "resident_bigon.svg"
            anchors.fill: city
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            visible: items.currentLevel > 0 && powerConsumed
            property int power: 2000
            property int powerConsumed: on ? power : 0
            property bool on: residentBigSwitch.on
        }

        // Tux is visible when tuxboat animation stops
        // It's light can be activated after stepdown is on

        Image {
            id: tux
            source: activity.url + (on ? "lightson.svg" : "lightsoff.svg")
            width: layoutArea.width * 0.184
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                leftMargin: layoutArea.width * 0.79
                topMargin: layoutArea.width *  0.557
            }
            visible: false
            property int power: 100
            property int powerConsumed: on ? power : 0
            property bool on: tuxSwitch.on
        }

        Image {
            id: tuxSwitch
            source: activity.url + (on ? "on.svg" : "off.svg")
            width: layoutArea.width * 0.053
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            property bool on: false
            visible: tux.visible
            anchors {
                top: layoutArea.top
                left: layoutArea.left
                leftMargin: layoutArea.width * 0.868
                topMargin: layoutArea.width * 0.722
            }
            MouseArea {
                id: off_area
                anchors.centerIn: parent
                // Size the area for a touch screen
                width: parent.width * 1.2
                height: width
                enabled: tuxSwitch.visible
                onClicked: {
                    if(stepDown.powerIn - stepDown.powerOut >= tux.power)
                        parent.on = !parent.on
                    else
                        parent.on = false
                    checkForNextLevel()
                }
            }
        }

        Rectangle {
            id: tuxMeter
            width: tuxConsume.width * 1.1
            height: tuxConsume.height * 1.1
            border.color: items.consumeColorBorder
            radius : 5
            color: items.consumeColor
            anchors {
                top: tuxSwitch.bottom
                horizontalCenter: tuxSwitch.horizontalCenter
            }
            GCText {
                id: tuxConsume
                anchors.centerIn: parent
                fontSize: smallSize * 0.5
                text: tux.powerConsumed.toString() + "W"
            }
            visible: tux.visible
        }

        function win() {
            items.bonus.good("flower")
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: previousLevel()
            onNextLevelClicked: nextLevel()
            onHomeClicked: {
                if(message.visible)
                    message.visible = false;
                home();
            }
            onReloadClicked: initLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(nextLevel)
        }
    }
}
