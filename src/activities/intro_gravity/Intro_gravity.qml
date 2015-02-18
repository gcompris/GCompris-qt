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
import QtQuick 2.2
import QtQuick.Controls 1.3
import GCompris 1.0

import "../../core"
import "intro_gravity.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property variant dataset

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url+"background.png"
        sourceSize.width: parent.width
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
            property alias scaleLeft: sliderLeft.value
            property alias scaleRight: sliderRight.value
            property alias shuttle: shuttle
            property alias timer: timer
            property alias arrow: arrow
            property alias asteroidCreation: asteroidCreation
            property GCAudio audioEffects: activity.audioEffects

        }

        onStart: { Activity.start(items,dataset) }
        onStop: { Activity.stop() }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
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

        Message{
            id: message
            anchors {
                top: parent.top
                topMargin: shuttle.y + shuttle.height + 20
                right: parent.right
                rightMargin: 200
                left: parent.left
                leftMargin: 200
            }
        }

        Image {
            id: planetLeft
            source: Activity.url+"saturn.png"
            x: 70
            y: parent.height/2 - height

            Behavior on scale{
                NumberAnimation{ duration: 100 }
            }
        }

        Slider{
            id: sliderLeft
            x: 20
            y: planetLeft.y
            activeFocusOnPress: true
            orientation: Qt.Vertical
            value: 1.5
            stepSize: 0.1
            updateValueWhileDragging: true
            maximumValue: 2.0
            minimumValue: 1.0
            tickmarksEnabled: true
            onValueChanged:{
                planetLeft.scale = value
            }

        }

        Image{
            id: planetRight
            source: Activity.url+"neptune.png"
            x: parent.width - 130
            y: parent.height/2 - height

            Behavior on scale{
                NumberAnimation{ duration: 100 }
            }
        }


        Slider{
            id: sliderRight
            x: planetRight.x + planetRight.width + 20
            y: planetRight.y
            activeFocusOnPress: true
            orientation: Qt.Vertical
            value: 1.5
            stepSize: 0.1
            updateValueWhileDragging: true
            maximumValue: 2.0
            minimumValue: 1.0
            tickmarksEnabled: true
            onValueChanged:{
                planetRight.scale = value
            }

        }

        Image{
            id: shuttle
            source: Activity.url +"tux_spaceship.png"
            x: parent.width/2
            y: parent.height/2 - height +10

        }

        //for drawing the line to show force magnitude and direction
        Image{
            id: arrow
            x: shuttle.x - shuttle.width ; y: shuttle.y -80
            width: 50; height: 20
            scale : 1
            source: Activity.url +"arrowright.svg"
            Behavior on scale {
                NumberAnimation{ duration: 48 }
            }
        }

        Timer{
            id: timer
            interval: 16
            running: false
            repeat: true
            onTriggered: {
                Activity.moveShuttle()
                Activity.moveAsteroid()
            }
        }

        Timer{
            id: asteroidCreation
            running: false
            repeat: true
            interval: 10200 - (bar.level * 200)
            onTriggered: Activity.createAsteroid()
            }

    }
}
