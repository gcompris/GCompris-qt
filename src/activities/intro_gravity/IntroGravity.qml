/* GCompris - intro_gravity.qml
*
* Copyright (C) 2015 Siddhesh suthar <siddhesh.it@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> and Matilda Bernard (GTK+ version)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
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
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "intro_gravity.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property int oldWidth: width
    onWidthChanged: {
        // Reposition planets and asteroids, same for height
        Activity.repositionObjectsOnWidthChanged(width / oldWidth)
        oldWidth = width
    }

    property int oldHeight: height
    onHeightChanged: {
        // Reposition planets and asteroids, same for height
        Activity.repositionObjectsOnHeightChanged(height / oldHeight)
        oldHeight = height
    }


    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url+"background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
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
            property alias planetLeft: planetLeft
            property alias planetRight: planetRight
            property alias scaleLeft: planetLeft.value
            property alias scaleRight: planetRight.value
            property alias spaceship: spaceship
            property alias shuttle: shuttle
            property alias shuttleMotion: shuttleMotion
            property alias timer: timer
            property alias arrow: arrow
            property alias asteroidCreation: asteroidCreation
            property GCSfx audioEffects: activity.audioEffects
            property double distLeft: Math.abs(spaceshipX / ApplicationInfo.ratio)
            property double distRight: Math.abs((background.width - spaceshipX) / ApplicationInfo.ratio)
            property double forceLeft: (Math.pow(scaleLeft, 2) / Math.pow(distLeft, 2)) * Math.pow(10, 6)
            property double forceRight: (Math.pow(scaleRight, 2) / Math.pow(distRight, 2)) * Math.pow(10, 6)
            // the center value for the spaceship
            property double spaceshipX
            property double spaceshipY: parent.height / 2
        }

        onStart: Activity.start(items,message)
        onStop: Activity.stop()

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        IntroMessage {
            id: message
            onIntroDone: {
                items.timer.start()
                items.asteroidCreation.start()
                items.shuttleMotion.restart()
            }
            intro: [
                qsTr("Gravity is universal and Newton's law of universal gravitation extends gravity"
                     +" beyond earth. This force of gravitational attraction is directly dependent"
                     +" upon the masses of both objects and inversely proportional to"
                     +" the square of the distance that separates their centers."),
                qsTr("Since the gravitational force is directly proportional to the mass of both interacting "
                     +"objects, more massive objects will attract each other with a greater gravitational "
                     +"force. So as the mass of either object increases, the force of gravitational "
                     +"attraction between them also increases"),
                qsTr("But this force is inversely proportional to the square of the separation distance "
                     +"between the two interacting objects, more separation distance will "
                     +"result in weaker gravitational forces."),
                qsTr("Your goal is to let Tux's spaceship move by changing the mass "
                     +"of its surrounding planets. Don't get too close to the planets "
                     +"or you will crash on them. "
                     +"The arrow indicates the direction of the force on your ship."),
                qsTr("Avoid the asteroid and join the space "
                     +"shuttle to win.")
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

        Planet {
            id: planetLeft
            x: 0
            width: parent.width * 0.5
            height: parent.height
            planetSource: Activity.url + "saturn.svg"
            planetWidth: 240 * ApplicationInfo.ratio
            isLeft: true
        }

        Planet {
            id: planetRight
            x: parent.width / 2
            width: parent.width * 0.5
            height: parent.height
            planetSource: Activity.url + "neptune.svg"
            planetWidth: 184 * ApplicationInfo.ratio
            isLeft: false
        }


        Image {
            id: spaceship
            source: Activity.url + "tux_spaceship.svg"
            sourceSize.width: 120 * ApplicationInfo.ratio
            x: items.spaceshipX - width / 2
            y: items.spaceshipY - height / 2
        }

        // line to show force magnitude and direction
        Image {
            id: arrow
            visible: !message.displayed && width > 6 && timer.running
            x: items.forceLeft < items.forceRight ?
                   items.spaceshipX : items.spaceshipX - width
            y: spaceship.y - 80
            z: 11
            sourceSize.width: 120 * 10 * ApplicationInfo.ratio
            width: Math.min(background.width / 4, Math.abs(items.forceLeft - items.forceRight) * 6)
            height: 40 * ApplicationInfo.ratio
            source: Activity.url +"arrow.svg"
            rotation: items.forceLeft > items.forceRight ? 0 : 180
            Behavior on rotation {
                NumberAnimation{ duration: 100 }
            }
            Behavior on width {
                NumberAnimation{ duration: 100 }
            }
        }

        Image {
            id: shuttle
            source: Activity.url + "space_shuttle.svg"
            sourceSize.width: 80 * ApplicationInfo.ratio
            z: 10

            NumberAnimation {
                id: shuttleMotion
                target: shuttle
                property: "y"
                to: 0 - shuttle.height
                duration: 40000 / (Activity.currentLevel+1)
            }
        }

        Timer {
            id: timer
            interval: 16
            running: false
            repeat: true
            onTriggered: {
                Activity.moveSpaceship()
                Activity.handleCollisionWithAsteroid()
            }
        }

        Timer {
            id: asteroidCreation
            running: false
            repeat: true
            interval: 10200 - (bar.level * 200)
            onTriggered: Activity.createAsteroid()
        }

    }
}
