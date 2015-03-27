/* GCompris - aviActivi.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   Avi Illouz <avi.illouz@gmail.com> (Qt Quick port)
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

import "../../core"
import "aviActivi.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#c1f70c"
        signal start
        signal stop

        Rectangle {

            property color buttonColor: "lightgray"
            property color onHoverColor: "black"
            property color borderColor: "gray"

            id: simpleButton;
            border.width: 3
            width: 130; height: 70;

            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.bottom: parent.bottom;
            anchors.bottomMargin: 20;


            Text {
                id: buttonLabel
                anchors.centerIn: parent
                text: "Click!"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 12
            }

            MouseArea {
                id: buttonMouseArea
                anchors.fill: parent
                onClicked:
                {
                    //toggle flower visabilty
                    flower.visible = flower.visible ? false : true

                    //toggle title color
                    activityTitle.color = flower.visible ? "red" : "black"
                }
                hoverEnabled: true
            }

            color: buttonMouseArea.pressed ? Qt.darker(buttonColor, 1.5) : buttonColor
        }

        Image {
            id: flower
            fillMode: Image.PreserveAspectFit
            source: "flower.svg"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: 500/2; height: 707/2;
            z: 1
            visible: false

        }
        Image {
            id: computer
            source: "computer.svg"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }



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
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            id: activityTitle
            anchors.centerIn: parent.Top
            anchors.horizontalCenter: parent.horizontalCenter
            text: "aviActivi activity"
            fontSize: smallSize
        }

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
    }

}
