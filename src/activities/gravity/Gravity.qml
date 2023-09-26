/* GCompris - Gravity.qml
*
* SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> and Matilda Bernard (GTK+ version)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (complete activity rewrite)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "gravity.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    Keys.onPressed: Activity.processKeyPress(event)
    Keys.onReleased: Activity.processKeyRelease(event)

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#171717"

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: message

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property bool startMessage: true
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias processTimer: processTimer
            property alias planetCreation: planetCreation
            property int maxPlanetSize: background.width - spaceship.width
            property int minPlanetSize: background.width * 0.2
            property alias planet0: planet0
            property alias planet1: planet1
            property alias arrow: arrow
            property GCSfx audioEffects: activity.audioEffects
            property double gravity: 0
            property int planetFrequency: 0
            property int spaceSpeed: planetFrequency * 4
            property alias spaceship: spaceship
            property alias station: station
            property alias stationDown: stationDown
            // the center value for the spaceship
            property double spaceshipX
            property double spaceshipY: parent.height  * 0.5
            property int borderMargin: spaceship.width * 0.5
            property bool onScreenControls: ApplicationInfo.isMobile
            property alias explosion: explosion
        }

        onStart: {
            explosion.hide()
            Activity.start(items,message)
        }
        onStop: {
            explosionTimer.stop()
            spaceRepeat.stop()
            Activity.stop()
        }

        onWidthChanged: {
            initSpace()
            items.spaceshipX = parent.width * 0.5
        }
        onHeightChanged: {
            initSpace()
            items.spaceshipX = parent.width * 0.5
        }
        // alternate rewind space1 and space2
        property bool rewindSpace1: true

        function initSpace(){
            space1.height = Math.max(parent.width, parent.height)
            space1.y = 0
            space2.y = -space1.height
            down.duration = items.spaceSpeed * 0.5
            down2.duration = items.spaceSpeed
            spaceRepeat.interval = items.spaceSpeed * 0.5
            space1.startMoving()
            space2.startMoving()
            spaceRepeat.restart()
            rewindSpace1 = true
            station.width = background.width
            station.y = -station.height
        }

        Image {
            id: space1
            source: Activity.url+"background.svg"
            width: height
            height: Math.max(parent.width, parent.height)
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            y: 0
            function startMoving() {
                down.restart()
            }
        }
        NumberAnimation {
            id: down
            target: space1
            property: "y"
            to: space1.height
            duration: items.spaceSpeed * 0.5
        }

        Image {
            id: space2
            source: Activity.url+"background.svg"
            width: space1.height
            height: space1.height
            sourceSize.height: space1.height
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            y: -space1.height
            function startMoving() {
                down2.restart()
            }
        }
        NumberAnimation {
            id: down2
            target: space2
            property: "y"
            to: space1.height
            duration: items.spaceSpeed
        }

        Timer {
            id: spaceRepeat
            running: false
            repeat: true
            interval: items.spaceSpeed * 0.5
            onTriggered: {
                if(rewindSpace1) {
                    down.duration = 0
                    space1.y = -space1.height
                    down.duration = items.spaceSpeed
                    space1.startMoving()
                } else {
                    down2.duration = 0
                    space2.y = -space1.height
                    down2.duration = items.spaceSpeed
                    space2.startMoving()
                }
                rewindSpace1 = !rewindSpace1
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: {
                home()
                Activity.initLevel()
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                Activity.stop()
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: if(!bonus.isPlaying) Activity.previousLevel()
            onNextLevelClicked: if(!bonus.isPlaying) Activity.nextLevel()
            onHomeClicked: home();
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                loose.connect(Activity.initLevel)
                win.connect(Activity.nextLevel)
            }
        }

        IntroMessage {
            id: message
            onIntroDone: {
                items.startMessage = false
                items.processTimer.start()
                Activity.createPlanet()
                items.planetCreation.start()
            }
            intro: [
                qsTr("Gravity is universal and Newton's law of universal gravitation extends gravity"
                     +" beyond earth. This force of gravitational attraction is directly dependent"
                     +" upon the mass of both objects and inversely proportional to"
                     +" the square of the distance between their centers."),
                qsTr("Since the gravitational force is directly proportional to the mass of both interacting"
                     +" objects, more massive objects will attract each other with a greater gravitational"
                     +" force."),
                qsTr("But as this force is inversely proportional to the square of the distance"
                     +" between the two interacting objects, more distance will"
                     +" result in weaker gravitational force."),
                qsTr("Your goal is to move the spaceship and avoid hitting the planets until you reach the"
                     +" space station. The arrow indicates the direction and the intensity of the gravity"
                     +" on your ship."),
                qsTr("Try to stay near the center of the screen, and anticipate by looking at the size"
                    +" and direction of the arrow.")
            ]
            z: 110
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
        }

        Planet {
            id: planet0
            leftSide: true
        }

        Planet {
            id: planet1
            leftSide: false
        }

        Image {
            id: station
            source: Activity.url + "space_station.svg"
            x: 0
            y: -height
            width: background.width
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
        }
        NumberAnimation {
            id: stationDown
            target: station
            property: "y"
            to: items.spaceshipY - (station.height * 0.5)
            duration: items.planetFrequency / 4
            onRunningChanged: if(station.y > -station.height) {
                Activity.stop();
                items.bonus.good("lion");
            }
        }

        Image {
            id: spaceship
            source: Activity.url + "tux_spaceship.svg"
            sourceSize.width: 120 * ApplicationInfo.ratio
            x: items.spaceshipX - width * 0.5
            y: items.spaceshipY - height * 0.5
            z: 100

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
        }

        Image {
            id: explosion
            anchors.centerIn: spaceship
            width: spaceship.width
            height: width
            source: Activity.url + "crash.svg"
            visible: false
            scale: 0
            opacity: 0
            z: 105

            Timer {
                id: explosionTimer
                interval: 600; running: false; repeat: false
                onTriggered: explosion.opacity = 0
            }

            function show() {
                visible = true;
                opacity = 100
                scale = 1;
                explosionTimer.running = true
            }
            function hide() {
                visible = false;
                scale = 0;
                explosionTimer.running = false
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.Linear
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutCubic
                }
            }

        }

        // line to show force magnitude and direction
        Image {
            id: arrow
            visible: width >= 20 && processTimer.running
            x: items.gravity > 0 ?
                   items.spaceshipX : items.spaceshipX - width
            y: spaceship.y - height * 1.1
            z: 101
            sourceSize.height: height
            width: Math.abs(items.gravity * 2000)
            height: 40 * ApplicationInfo.ratio
            source: Activity.url + "arrow.svg"
            rotation: items.gravity < 0 ? 0 : 180
            Behavior on width {
                NumberAnimation{ duration: 100 }
            }
        }

        Row {
            id: leftRightControl
            anchors.horizontalCenter: background.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: spacing
            width: leftButton.width + rightButton.width + spacing
            height: leftButton.height
            visible: items.onScreenControls
            z: 102
            opacity: 0.4
            spacing: height

            ControlButton {
                id: leftButton
                source: "qrc:/gcompris/src/core/resource/arrow_left.svg"
                onPressed: Activity.processKeyPress({key: Qt.Key_Left});
                onReleased: Activity.processKeyRelease({key: Qt.Key_Left});
                exceed: height * 0.4
            }

            ControlButton {
                id: rightButton
                source: "qrc:/gcompris/src/core/resource/arrow_right.svg"
                onPressed: Activity.processKeyPress({key: Qt.Key_Right});
                onReleased: Activity.processKeyRelease({key: Qt.Key_Right});
                exceed: leftButton.exceed
            }
        }

        Timer {
            id: planetCreation
            running: false
            repeat: true
            interval: items.planetFrequency
            onTriggered: {
                Activity.destroyPlanet()
                Activity.createPlanet()
            }
        }

        Timer {
            id: processTimer
            interval: 16
            running: false
            repeat: true
            onTriggered: {
                Activity.moveSpaceship()
            }
        }
    }
}
