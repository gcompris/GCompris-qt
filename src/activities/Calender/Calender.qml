/* GCompris - Calender.qml
 *
 * Copyright (C) 2017 YOUR NAME <xx@yy.org>
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
import QtQuick 2.6
import GCompris 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls.Private 1.0
import "../../core"
import "Calender.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        signal start
        signal stop
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/gcompris/src/activities/fifteen/resource/background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)

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
            property alias calender: calender
            property alias okButton: okButton
            property alias instructions: instructions

        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Rectangle{
            id: calenderBox
            width: parent.width * 0.40
            height: parent.width * 0.40
            anchors.bottom: bar.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: "black"
            opacity: 0.3

        }
        Calendar {
            id: calender
            weekNumbersVisible: false
            width: calenderBox.width * 0.85
            height: calenderBox.height * 0.85
            anchors.centerIn: calenderBox
            //anchors.bottom: items.bar.top
            frameVisible: true
            focus: true
            // weekNumbersVisible: true
            navigationBarVisible : false

            onClicked:{
                console.log(typeof selectedDate.getDate())
            }//visibleYear: 2019
            //locale: Qt.locale("en_AU")
            visibleMonth: 02
            visibleYear: 2018
            minimumDate: "2018-03-01"
            maximumDate: "2018-03-31"
        }
        Rectangle {
            id: instructionBox
            //anchors.left: categoryBackground.left
            //anchors.right: categoryImage.left
            //anchors.leftMargin: 0.32 * parent.width
            //anchors.rightMargin: 0.03 * parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: calenderBox.top
            anchors.bottomMargin: 10
            color: "#87A6DD"
            opacity: 0.85 //items.instructionsVisible ? 0.85 : 0
            z: 3
            radius: 10
            border.width: 2
            width: calenderBox.width * 2
            height: calenderBox.height * 0.125
            /* gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }*/
        }

        GCText {
            id: instructions
            text: "The date is: " + new Date().toLocaleDateString(Qt.locale("de_DE")) + " \n  " +new Date().toLocaleDateString(Qt.locale("en_US"))
            //visible: items.instructionsVisible
            anchors.fill: instructionBox
            anchors.bottom: instructionBox.bottom
            fontSizeMode: Text.Fit
            wrapMode: Text.Wrap
            z: 3
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: calenderBox.width * 0.16
            height: width
            sourceSize.width: width
            sourceSize.height: height
            y: parent.height*0.8
            z: 2
            anchors {
                rightMargin: 14 * ApplicationInfo.ratio
                left: calenderBox.right
                leftMargin: calenderBox.width * 0.1
                bottom: calenderBox.bottom

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {}
                //Activity.allPlaced();
            }
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
        Score {
            id: score
            z: 1003
            anchors.bottom: background.bottom
            anchors.right: background.right
            //currentSubLevel = 1
            currentSubLevel: 1
            numberOfSubLevels: 5
        }
    }
}


