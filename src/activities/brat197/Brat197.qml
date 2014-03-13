/* GCompris - brat197.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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

import "qrc:/gcompris/src/core"
import "brat197.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image{
        id: background
        anchors.fill: parent
        source: "resource/background.jpeg"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript


        onStart: { Activity.start(activity.main, background, bar, bonus, rectangle, img1, img2, text, button, button1, rectangle1, buttonText, buttonText1) }
        onStop: { Activity.stop() }




        Rectangle{
            id: button
            color: "black"
            width: 150
            height: 50
            x: parent.width/2 + 70
            y: parent.height/2 + 70
            Text{
                id : buttonText
                anchors.centerIn: parent
                text: "Click to see a Rectangle!"
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {Activity.handleclick()
                    animateColor.start()
                }}
            PropertyAnimation {id: animateColor; target: button; properties: "color"; to: "green"; duration: 1}

            SequentialAnimation on color {
                    ColorAnimation { to: "yellow"; duration: 1000 }
                    ColorAnimation { to: "blue"; duration: 1000 }
                }
}
        Rectangle{
            id: button1
            color: "black"
            width: 180
            height: 50
            x: parent.width/2 - 140
            y: parent.height/2 + 70
            Text{
                id : buttonText1
                anchors.centerIn: parent
                text: "Click to see a Circle!"
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {Activity.handleclick1()
                    animateColor1.start()
            }
            }
            PropertyAnimation {id: animateColor1; target: button1; properties: "color"; to: "green"; duration: 1}
            SequentialAnimation on color {
                    ColorAnimation { to: "yellow"; duration: 1000 }
                    ColorAnimation { to: "blue"; duration: 1000 }
                }

}


        Rectangle {
            id: rectangle1
            width: 10
            height: 10
            x: parent.width - 150
            color: "white"
            border.color: "black"
            border.width: 3
            radius: 100
            opacity: 0
        }

        Rectangle {
            id: rectangle
            width: 60
            height: 60
            color: "white"
            border.color: "black"
            border.width: 3
            radius: 0
            opacity: 0
        }



        Image {
            id: img1
            width: 100
            height: 100
            x: 150
            source: "resource/minus.jpeg"
            opacity: 1
            MouseArea{
                anchors.fill: parent
                onClicked: {text.font.pointSize -= 1}
            }
        }

        Image {
            id: img2
            x: 350
            width: 100
            height:100
            source: "resource/plus.jpeg"
            opacity: 1
            MouseArea{
                anchors.fill: parent
                onClicked: {text.font.pointSize += 1}
            }
        }

        Text {
            id: text
            anchors.centerIn: parent
            text: "GSoC. Click - to make it smaller. Click + to make it bigger."
            font.pointSize: 18
            x: 0
            y: parent.height/2
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
    }

}
