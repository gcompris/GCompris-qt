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
import "../../core"
import "Calender.js" as Activity
import "calender_dataset.js" as Dataset

ActivityBase {
    id: activity
    property var dataset: Dataset
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
            property alias questionItemBackground: questionItemBackground
            property alias questionItem: questionItem
            property alias questionsModel: questionsModel
            property alias score: score

        }

        onStart: { Activity.start(items, dataset) }
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
            frameVisible: true
            focus: true
            onClicked:{
                console.log(typeof selectedDate.getDate())
                Activity.dateSelected = selectedDate
            }
        }

        ListModel {
            id: questionsModel
        }

        Rectangle {
            id: questionItemBackground
            color: "black"
            border.width: 2
            radius: 10
            opacity: 0.85
            z: 10
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 10
            }
            width: calenderBox.width * 2
            height: calenderBox.height * 0.125
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
        }

        GCText {
            id: questionItem
            text: "The date is: " + new Date().toLocaleDateString(Qt.locale("de_DE")) + " \n  " +new Date().toLocaleDateString(Qt.locale("en_US"))
            anchors.fill: questionItemBackground
            anchors.bottom: questionItemBackground.bottom
            fontSizeMode: Text.Fit
            wrapMode: Text.Wrap
            z: 10
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
            z: 10
            anchors {
                rightMargin: 14 * ApplicationInfo.ratio
                left: calenderBox.right
                leftMargin: calenderBox.width * 0.1
                bottom: calenderBox.bottom

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Activity.checkAnswer()
                }
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
        }
    }
}


