/* GCompris - renewable_energy.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import "../../core"

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string url: "qrc:/gcompris/src/activities/renewable_energy/resource/"
    property var barAtStart

    property int oldWidth: width
    onWidthChanged: {
        oldWidth: width
    }

    property int oldHeight: height
    onHeightChanged: {
        oldHeight: height
    }

    pageComponent: Item {
        id: background
        anchors.fill: parent

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
            property GCSfx audioEffects: activity.audioEffects
            property int currentLevel
            property int numberOfLevel: 3
            property bool sunIsUp
            property color consumeColor: '#ffff8100'
            property color produceColor: '#ffffec00'
            property bool hasWon: false
        }

        onStart: {
            barAtStart = ApplicationSettings.isBarHidden;
            ApplicationSettings.isBarHidden = true;
        }
        onStop: {
            ApplicationSettings.isBarHidden = barAtStart;
            initLevel()
        }

        function initLevel() {
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
            if(--items.currentLevel < 0) {
                items.currentLevel = items.numberOfLevel - 1
            }
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

        Loader {
            id: hydro
            anchors.fill: parent
            source: "Hydro.qml"
        }

        Loader {
            id: wind
            anchors.fill: parent
            source: items.currentLevel > 0 ? "Wind.qml" : ""
        }

        Loader {
            id: solar
            anchors.fill: parent
            source: items.currentLevel > 1 ? "Solar.qml" : ""
        }

        IntroMessage {
            id: message
            opacity: items.currentLevel == 0 ? 1 : start()
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
                message.opacity = 0
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
            Behavior on opacity { PropertyAnimation { duration: 200 } }
        }

        Rectangle {
            id: check
            opacity: 0
            width: 400 * ApplicationInfo.ratio
            height: 200 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            z: 100
            border.width: 2
            radius: 5
            color: "#d0f0f0"
            property bool shown: false

            GCText {
                id: warning
                anchors.fill: parent
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
                minimumPointSize: 10
                wrapMode: Text.WordWrap
                fontSize: smallSize
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
            source: activity.url + (started ? "transformer.svg" : "transformer_off.svg")
            sourceSize.width: parent.width * 0.06
            height: parent.height * 0.09
            anchors {
                top: parent.top
                left: parent.left
                topMargin: parent.height * 0.41
                leftMargin: parent.width * 0.72
            }
            MouseArea {
                anchors.centerIn: parent
                // Size the area for a touch screen
                width: 70 * ApplicationInfo.ratio
                height: width
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

                if(powerOut > powerIn && residentSmallSwitch.on) {
                    residentSmallSwitch.on = false
                    if(!check.shown && powerIn) check.opacity = 1
                }

                if(powerOut > powerIn && tuxSwitch.on) {
                    tuxSwitch.on = false
                    if(!check.shown && powerIn) check.opacity = 1
                }
            }
        }

        Image {
            source:  activity.url + "right.svg"
            sourceSize.width: stepDown.width / 2
            sourceSize.height: stepDown.height / 2
            anchors {
                right: stepDown.left
                bottom: stepDown.bottom
                bottomMargin: parent.height * 0.03
            }

            Rectangle {
                id: produceMeter
                width: pow.width * 1.1
                height: pow.height * 1.1
                border.color: "black"
                radius: 5
                color: items.produceColor
                anchors {
                    top: parent.top
                    right: parent.left

                }
                GCText {
                    id: pow
                    anchors.centerIn: parent
                    fontSize: smallSize * 0.5
                    text: stepDown.powerIn.toString() + "W"
                }
            }
        }

        Image {
            source: activity.url + "down.svg"
            sourceSize.width: stepDown.width / 2
            sourceSize.height: stepDown.height / 2
            anchors {
                left: stepDown.left
                top: stepDown.top
                topMargin: stepDown.height * 0.8
                leftMargin: parent.width * 0.05
            }

            Rectangle {
                id: consumeMeter
                width: stepdown_info.width * 1.1
                height: stepdown_info.height * 1.1
                border.color: "black"
                radius: 5
                color: items.consumeColor
                anchors {
                    top: parent.top
                    topMargin: parent.height * 0.1
                    left: parent.right
                }
                GCText {
                    id: stepdown_info
                    anchors.centerIn: parent
                    fontSize: smallSize * 0.5
                    text: stepDown.powerOut.toString() + "W"
                }
            }
        }

        Image {
            id: stepDownWire
            source: activity.url + "hydroelectric/stepdown.svg"
            sourceSize.width: parent.width
            anchors.fill: parent
            visible: power > 0
            property int power: stepDown.powerIn
        }

        Image {
            id: residentSmallSwitch
            visible: items.currentLevel > 0
            source: activity.url + (on ? "on.svg" : "off.svg")
            sourceSize.height: parent.height * 0.03
            sourceSize.width: parent.height * 0.03
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: parent.width * 0.55
                topMargin: parent.height * 0.65
            }
            property bool on: false
            MouseArea {
                id: small_area
                visible: parent.visible
                anchors.centerIn: parent
                // Size the area for a touch screen
                width: 70 * ApplicationInfo.ratio
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


        Image {
            id: tuxHouseOn
            source: activity.url + "tux_house_on.svg"
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            anchors.fill: parent
            visible: tuxSwitch.on
        }

        Image {
            id: residentSmallLights
            source: activity.url + "resident_smallon.svg"
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            anchors.fill: parent
            visible: items.currentLevel > 0 && powerConsumed
            property int power: 1000
            property int powerConsumed: on ? power : 0
            property bool on: residentSmallSwitch.on
        }

        Rectangle {
            id: smallConsumeRect
            width: small_consume.width * 1.1
            height: small_consume.height * 1.1
            border.color: "black"
            radius: 5
            color: items.consumeColor
            anchors {
                top: residentSmallSwitch.bottom
                left:residentSmallSwitch.left
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
            sourceSize.height: parent.height * 0.03
            sourceSize.width: parent.height * 0.03
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: parent.width * 0.60
                topMargin: parent.height * 0.65
            }
            property bool on: false
            MouseArea {
                id: big_area
                visible: parent.visible
                anchors.centerIn: parent
                // Size the area for a touch screen
                width: 70 * ApplicationInfo.ratio
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

        Image {
            id: residentBigLights
            source: activity.url + "resident_bigon.svg"
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            anchors.fill: parent
            visible: items.currentLevel > 0 && powerConsumed
            property int power: 2000
            property int powerConsumed: on ? power : 0
            property bool on: residentBigSwitch.on
        }

        Rectangle {
            id: bigConsumeRect
            width: bigConsume.width * 1.1
            height: bigConsume.height * 1.1
            border.color: "black"
            radius : 5
            color: items.consumeColor
            anchors {
                top: residentBigSwitch.bottom
                left: residentBigSwitch.left
            }
            GCText {
                id: bigConsume
                anchors.centerIn: parent
                text: residentBigLights.powerConsumed.toString() + "W"
                fontSize: smallSize * 0.5
            }
            visible: items.currentLevel > 1
        }

        // Tux is visible when tuxboat animation stops
        // It's light can be activated after stepdown is on

        Image {
            id: tux
            source: activity.url + (on ? "lightson.svg" : "lightsoff.svg")
            sourceSize.height: parent.height * 0.2
            sourceSize.width: parent.width * 0.15
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: parent.height * 0.3
                rightMargin: parent.width * 0.02
            }
            visible: false
            property int power: 100
            property int powerConsumed: on ? power : 0
            property bool on: tuxSwitch.on

            Image {
                id: tuxSwitch
                source: activity.url + (on ? "on.svg" : "off.svg")
                sourceSize.height: parent.height*0.20
                sourceSize.width: parent.height*0.20
                property bool on: false
                anchors {
                    right: tux.right
                    top: tux.top
                    rightMargin: tux.width * 0.20
                    topMargin: tux.height * 0.30
                }
                MouseArea {
                    id: off_area
                    anchors.centerIn: parent
                    // Size the area for a touch screen
                    width: 70 * ApplicationInfo.ratio
                    height: width
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
                border.color: "black"
                radius : 5
                color: items.consumeColor
                anchors {
                    bottom: tuxSwitch.top
                    left: tuxSwitch.left
                }
                GCText {
                    id: tuxConsume
                    anchors.centerIn: parent
                    fontSize: smallSize * 0.5
                    text: tux.powerConsumed.toString() + "W"
                }
                visible: tux.visible
            }
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
            level: items.currentLevel + 1
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(nextLevel)
        }
    }
}
