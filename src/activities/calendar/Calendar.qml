/* GCompris - Calendar.qml
 *
 * Copyright (C) 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Amit Sagtani <asagtani06@gmail.com>
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
import "calendar.js" as Activity
import "calendar_dataset.js" as Dataset

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
            property alias calendar: calendar
            property alias okButton: okButton
            property alias questionItem: questionItem
            property alias score: score
            property alias answerChoices: answerChoices
            property alias questionDelay: questionDelay
            property alias okButtonParticles: okButtonParticles
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }

        // Question time delay
        Timer {
            id: questionDelay
            repeat: false
            interval: 1600
            onTriggered: {
                Activity.currentSubLevel ++
                Activity.initQuestion()
            }
        }

        Rectangle {
            id: calendarBox
            width: parent.width * 0.40
            height: parent.height * 0.70
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.bottom: bar.top
            anchors.bottomMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            color: "black"
            opacity: 0.3
        }

        Calendar {
            id: calendar
            weekNumbersVisible: false
            width: calendarBox.width * 0.85
            height: calendarBox.height * 0.85
            anchors.centerIn: calendarBox
            visibleMonth: 2
            visibleYear: 2018
            frameVisible: true
            focus: true
            __locale: Qt.locale(ApplicationSettings.locale)
            onVisibleMonthChanged: {
                Activity.monthSelected = visibleMonth
            }
            onVisibleYearChanged: {
                Activity.yearSelected = visibleYear
            }
            onClicked: {
                Activity.daySelected = selectedDate.getDate()
            }
        }

        // Creates a table consisting of days of weeks.
        Column {
            id: answerChoices
            anchors.top: calendar.top
            anchors.right: calendarBox.left
            spacing: 2
            Repeater {
                model: [qsTr("Sunday"), qsTr("Monday"), qsTr("Tuesday"), qsTr("Wednesday"), qsTr("Thursday"), qsTr("Friday"), qsTr("Saturday")]
                ChoiceTable{
                    width: calendar.width * 0.33
                    height: calendar.height / 7.3
                    choices.text: modelData
                }
            }
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
            width: calendarBox.width * 2
            height: calendarBox.height * 0.125
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
        }

        // Displays the question.
        GCText {
            id: questionItem
            text: ""
            anchors.fill: questionItemBackground
            anchors.bottom: questionItemBackground.bottom
            fontSizeMode: Text.Fit
            wrapMode: Text.Wrap
            z: 10
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        // Answer Submition button.
        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: calendarBox.width * 0.16
            height: width
            sourceSize.width: width
            sourceSize.height: height
            y: parent.height*0.8
            z: 10
            anchors {
                rightMargin: 14 * ApplicationInfo.ratio
                left: calendarBox.right
                leftMargin: calendarBox.width * 0.1
                bottom: calendarBox.bottom
            }
            ParticleSystemStarLoader {
                id: okButtonParticles
                clip: false
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
            anchors.top: questionItemBackground.bottom
            anchors.topMargin: 5
            anchors.bottom: calendar.top
            anchors.right: questionItemBackground.right
            anchors.rightMargin: 0
        }
    }
}


