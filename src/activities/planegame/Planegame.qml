/* gcompris - Planegame.qml

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.1
import QtMultimedia 5.0
import GCompris 1.0

import "qrc:/gcompris/src/core"
import "planegame.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: { focus = true; }
    onStop: { }

    Keys.onPressed: Activity.processPressedKey(event)
    Keys.onReleased: Activity.processReleasedKey(event)

    property int oldWidth: width
    onWidthChanged: {
        // Reposition helico and clouds, same for height
        if(Activity.plane !== undefined) {
            Activity.repositionObjectsOnWidthChanged(width/oldWidth)
        }
        oldWidth = width
    }

    property int oldHeight: height
    onHeightChanged: {
        // Reposition helico and clouds, same for height
        if(Activity.plane !== undefined) {
            Activity.repositionObjectsOnHeightChanged(height / oldHeight)
        }
        oldHeight = height
    }

    pageComponent: Image {
        id: background
        anchors.fill: parent
        signal start
        signal stop
        source: "qrc:/gcompris/src/activities/planegame/resource/background.svgz"

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias plane: plane
            property alias bonusSound: bonusSound
            property alias audioNumber: audioNumber
            property alias movePlaneTimer: movePlaneTimer
            property alias cloudCreation: cloudCreation
        }
        onStart: {
            Activity.start(main, items)
            movePlaneTimer.start();
            cloudCreation.start()
        }
        onStop: {
            Activity.stop();
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            visible: false
            anchors.bottom: background.bottom
            anchors.right: background.right
        }

        Timer {
            id: movePlaneTimer
            running: false
            repeat: true
            interval: 100 + (40 / (bar.level))
            onTriggered: {
                Activity.handleCollisionsWithCloud();
                Activity.computeSpeed();
                Activity.move();
            }
        }

        Timer {
            id: cloudCreation
            running: false
            repeat: true
            interval: 10200 - (bar.level * 200)
            onTriggered: Activity.createCloud()
        }

        Plane {
            id: plane
            background: background
            score: score
        }

        Audio {
            id: bonusSound
            source: "qrc:/gcompris/src/activities/planegame/resource/bonus.wav"
            onError: console.log("Plane.qml, bonus play error: " + errorString)
        }

        Audio {
            id: audioNumber
            onError: console.log("Plane.qml, bonus play error: " + errorString)
        }

        Item {
            id: multitouchFourArrowsOnSides
            anchors.fill: parent
            visible: ApplicationInfo.isMobile

            Arrow {
                id: leftArrow
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                mirror: true

                onButtonPressedChanged: Activity.leftPressed = buttonPressed
            }

            Arrow {
                id: rightArrow
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                onButtonPressedChanged: Activity.rightPressed = buttonPressed
            }
            Arrow {
                id: topArrow
                rotation: 270
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                onButtonPressedChanged: Activity.upPressed = buttonPressed;
            }
            Arrow {
                id: downArrow
                rotation: 90
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                onButtonPressedChanged: Activity.downPressed = buttonPressed
            }
        }
    }
}
