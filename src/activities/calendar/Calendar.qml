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
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
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
            property bool horizontalLayout: background.width > background.height
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }

        // Question time delay
        Timer {
            id: questionDelay
            repeat: false
            interval: 1600
            onTriggered: {
                Activity.currentSubLevel++
                Activity.initQuestion()
            }
            onRunningChanged: okButtonMouseArea.enabled = !okButtonMouseArea.enabled
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
            style: CalendarStyle {
                navigationBar: Rectangle {
                    height: Math.round(TextSingleton.implicitHeight * 2.73)
                    color: "lightBlue"
                    Rectangle {
                        color: Qt.rgba(1,1,1,0.6)
                        height: 1
                        width: parent.width
                    }
                    Rectangle {
                        anchors.bottom: parent.bottom
                        height: 1
                        width: parent.width
                        color: "#ddd"
                    }
                    BarButton {
                        id: previousMonth
                        height: parent.height
                        width: height * 0.75
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
                        onClicked: control.showPreviousMonth()
                    }
                    Label {
                        id: dateText
                        text: styleData.title
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: TextSingleton.implicitHeight * 1.25
                        font.family: ApplicationSettings.font
                        fontSizeMode: Text.Fit
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: previousMonth.right
                        anchors.leftMargin: 2
                        anchors.right: nextMonth.left
                        anchors.rightMargin: 2
                    }
                    BarButton {
                        id: nextMonth
                        height: parent.height
                        width: height * 0.75
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        source: "qrc:/gcompris/src/core/resource/bar_next.svg"
                        onClicked: control.showNextMonth()
                    }
                }
                dayDelegate: Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: (!addExtraMargin || control.weekNumbersVisible) && styleData.index % CalendarUtils.daysInAWeek === 0 ? 0 : -1
                    anchors.rightMargin: !addExtraMargin && styleData.index % CalendarUtils.daysInAWeek === CalendarUtils.daysInAWeek - 1 ? 0 : -1
                    anchors.bottomMargin: !addExtraMargin && styleData.index >= CalendarUtils.daysInAWeek * (CalendarUtils.weeksOnACalendarMonth - 1) ? 0 : -1
                    anchors.topMargin: styleData.selected ? -1 : 0
                    color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "#F2F2F2"
                    border.color: "#cec4c4"
                    radius: 5
                    property bool addExtraMargin: control.frameVisible && styleData.selected
                    property color sameMonthDateTextColor: "#373737"
                    property color selectedDateColor: "#3778d0"
                    property color selectedDateTextColor: "white"
                    property color differentMonthDateTextColor: "#bbb"
                    property color invalidDateColor: "#dddddd"
                    Label {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignRight
                        font.family: ApplicationSettings.font
                        font.pixelSize: Math.min(parent.height/3, parent.width/3)
                        color: {
                            var theColor = invalidDateColor;
                            if (styleData.valid) {
                                // Date is within the valid range.
                                theColor = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if (styleData.selected)
                                    theColor = selectedDateTextColor;
                            }
                            theColor;
                        }
                    }
                }
                dayOfWeekDelegate: Rectangle {
                    color: gridVisible ? "#F2F2F2" : "transparent"
                    implicitHeight: Math.round(TextSingleton.implicitHeight * 2.25)
                    Label {
                        text: control.__locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
                        font.family: ApplicationSettings.font
                        anchors.centerIn: parent
                    }
                }

            }

            onVisibleMonthChanged: {
                Activity.monthSelected = visibleMonth
            }
            onVisibleYearChanged: {
                Activity.yearSelected = visibleYear
            }
            onClicked: {
                Activity.daySelected = selectedDate.getDate()
            }
            onReleased: {
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
                ChoiceTable {
                    width: items.horizontalLayout ? calendar.width * 0.33 : calendar.width * 0.50
                    height: calendar.height / 7.3
                    choices.text: modelData
                    anchors.rightMargin: 2
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

        // Answer Submission button.
        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: items.horizontalLayout ? calendarBox.width * 0.16 : calendarBox.width * 0.28
            height: width
            sourceSize.width: width
            sourceSize.height: height
            y: parent.height * 0.8
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
                id: okButtonMouseArea
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


