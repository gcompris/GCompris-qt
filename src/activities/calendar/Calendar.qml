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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0
import QtQuick.Controls 1.5
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.4
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
            property bool horizontalLayout: background.width >= background.height * 1.5
            property alias daysOfTheWeekModel: daysOfTheWeekModel
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }
        Keys.onPressed: (answerChoices.visible) ? answerChoices.handleKeys(event) : handleKeys(event);

        // Question time delay
        Timer {
            id: questionDelay
            repeat: false
            interval: 1600
            onTriggered: {
                Activity.initQuestion()
            }
            onRunningChanged: okButtonMouseArea.enabled = !okButtonMouseArea.enabled
        }

        Rectangle {
            id: calendarBox
            width: items.horizontalLayout ? (answerChoices.visible ? parent.width * 0.75 : parent.width * 0.80) :
                                            (answerChoices.visible ? parent.width * 0.65 : parent.width * 0.85)
            height: items.horizontalLayout ? parent.height * 0.68 : parent.height - bar.height - questionItemBackground.height - okButton.height * 1.5
            anchors.top: questionItem.bottom
            anchors.topMargin: 5
            anchors.rightMargin: answerChoices.visible ? 100 : undefined
            anchors.horizontalCenterOffset: answerChoices.visible ? 80 : 0
            anchors.horizontalCenter: parent.horizontalCenter
            color: "black"
            opacity: 0.3
        }

        Calendar {
            id: calendar
            weekNumbersVisible: false
            width: calendarBox.width * 0.96
            height: calendarBox.height * 0.96
            anchors.centerIn: calendarBox
            frameVisible: true
            focus: !answerChoices.visible
            __locale: Qt.locale(ApplicationInfo.localeShort)
            style: CalendarStyle {
                navigationBar: Rectangle {
                    height: calendar.height * 0.12
                    color: "#f2f2f2"
                    
                    BarButton {
                        id: previousMonth
                        height: parent.height * 0.8
                        width: previousMonth.height
                        sourceSize.height: previousMonth.height
                        sourceSize.width: previousMonth.width
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: parent.height * 0.1
                        source: "qrc:/gcompris/src/core/resource/scroll_down.svg"
                        rotation: 90
                        visible: ((calendar.visibleYear + calendar.visibleMonth) > Activity.minRange) ? true : false
                        onClicked: calendar.showPreviousMonth()
                    }
                    GCText {
                        id: dateText
                        text: styleData.title
                        color: "#373737"
                        horizontalAlignment: Text.AlignHCenter
                        fontSizeMode: Text.Fit
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: previousMonth.right
                        anchors.leftMargin: 2
                        anchors.right: nextMonth.left
                        anchors.rightMargin: 2
                    }
                    BarButton {
                        id: nextMonth
                        height: previousMonth.height
                        width: nextMonth.height
                        sourceSize.height: nextMonth.height
                        sourceSize.width: nextMonth.width
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: previousMonth.anchors.leftMargin
                        source: "qrc:/gcompris/src/core/resource/scroll_down.svg"
                        rotation: 270
                        visible: ((calendar.visibleYear + calendar.visibleMonth) < Activity.maxRange) ? true : false
                        onClicked: calendar.showNextMonth()
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
                    readonly property color sameMonthDateTextColor: "#373737"
                    readonly property color selectedDateColor: "#3778d0"
                    readonly property color selectedDateTextColor: "white"
                    readonly property color differentMonthDateTextColor: "#bbb"
                    readonly property color invalidDateColor: "#dddddd"
                    Label {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignRight
                        font.family: GCSingletonFontLoader.fontLoader.name
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
                    color: "lightgray"
                    implicitHeight: Math.round(TextSingleton.implicitHeight * 2.25)
                    Label {
                        text: control.__locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
                        font.family: GCSingletonFontLoader.fontLoader.name
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 1
                        font.pixelSize: items.horizontalLayout ? parent.height * 0.7 : parent.width * 0.2
                        color: "#373737"
                        anchors.centerIn: parent
                    }
                }
            }
            onVisibleMonthChanged: {
                Activity.monthSelected = visibleMonth
                Activity.daySelected = selectedDate.getDate()
            }
            onVisibleYearChanged: {
                Activity.yearSelected = visibleYear
                Activity.daySelected = selectedDate.getDate()
            }
            onClicked: {
                Activity.daySelected = selectedDate.getDate()
            }
            onSelectedDateChanged: {
                Activity.daySelected = selectedDate.getDate()
            }

        }

        function handleKeys(event) {
            if(event.key === Qt.Key_Space && okButtonMouseArea.enabled) {
                Activity.checkAnswer()
                event.accepted = true
            }
            if(event.key === Qt.Key_Enter && okButtonMouseArea.enabled) {
                Activity.checkAnswer()
                event.accepted = true
            }
            if(event.key === Qt.Key_Return && okButtonMouseArea.enabled) {
                Activity.checkAnswer()
                event.accepted = true
            }
            if(event.key === Qt.Key_Home) {
                calendar.__selectFirstDayOfMonth();
                event.accepted = true;
            }
            if(event.key === Qt.Key_End) {
                calendar.__selectLastDayOfMonth();
                event.accepted = true;
            }
            if(event.key === Qt.Key_PageUp) {
                calendar.__selectPreviousMonth();
                event.accepted = true;
            }
            if(event.key === Qt.Key_PageDown) {
                calendar.__selectNextMonth();
                event.accepted = true;
            }
            if(event.key === Qt.Key_Left) {
                calendar.__selectPreviousDay();
                event.accepted = true;
            }
            if(event.key === Qt.Key_Up) {
                calendar.__selectPreviousWeek();
                event.accepted = true;
            }
            if(event.key === Qt.Key_Down) {
                calendar.__selectNextWeek();
                event.accepted = true;
            }
            if(event.key === Qt.Key_Right) {
                calendar.__selectNextDay();
                event.accepted = true;
            }
        }

        ListModel {
            id: daysOfTheWeekModel
            ListElement { text: qsTr("Sunday"); dayIndex: 0 }
            ListElement { text: qsTr("Monday"); dayIndex: 1 }
            ListElement { text: qsTr("Tuesday"); dayIndex: 2 }
            ListElement { text: qsTr("Wednesday"); dayIndex: 3 }
            ListElement { text: qsTr("Thursday"); dayIndex: 4 }
            ListElement { text: qsTr("Friday"); dayIndex: 5 }
            ListElement { text: qsTr("Saturday"); dayIndex: 6 }
        }

        // Creates a table consisting of days of weeks.
        GridView {
            id: answerChoices
            model: daysOfTheWeekModel
            anchors.top: calendarBox.top
            anchors.left: questionItem.left
            anchors.topMargin: 5
            interactive: false

            property bool keyNavigation: false

            width: calendarBox.x - anchors.rightMargin
            height: (calendar.height / 6.5) * 7
            cellWidth: calendar.width * 0.5
            cellHeight: calendar.height / 6.5
            keyNavigationWraps: true
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            delegate: ChoiceTable {
                width: answerChoices.width
                height: answerChoices.height / 7
                choices.text: text
                anchors.rightMargin: 2
            }
            Keys.enabled: answerChoices.visible
            function handleKeys(event) {
                if(event.key === Qt.Key_Down) {
                    keyNavigation = true
                    answerChoices.moveCurrentIndexDown()
                }
                if(event.key === Qt.Key_Up) {
                    keyNavigation = true
                    answerChoices.moveCurrentIndexUp()
                }
                if(event.key === Qt.Key_Enter && !questionDelay.running) {
                    keyNavigation = true
                    Activity.dayOfWeekSelected = model.get(currentIndex).dayIndex
                    answerChoices.currentItem.select()
                }
                if(event.key === Qt.Key_Space && !questionDelay.running) {
                    keyNavigation = true
                    Activity.dayOfWeekSelected = model.get(currentIndex).dayIndex
                    answerChoices.currentItem.select()
                }
                if(event.key === Qt.Key_Return && !questionDelay.running) {
                    keyNavigation = true
                    Activity.dayOfWeekSelected = model.get(currentIndex).dayIndex
                    answerChoices.currentItem.select()
                }
            }

            highlight: Rectangle {
                width: parent.width * 1.2
                height: parent.height / 7
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#e99e33"
                border.width: 2
                border.color: "#f2f2f2"
                radius: 5
                visible: answerChoices.keyNavigation
                y: answerChoices.currentItem.y
                Behavior on y {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
            }
            highlightFollowsCurrentItem: false
            focus: answerChoices.visible
        }

        Rectangle {
            id: questionItemBackground
            color: "#373737"
            border.width: 2
            border.color: "#f2f2f2"
            radius: 10
            opacity: 0.85
            z: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 10
            }
            width: parent.width - 20
            height: parent.height * 0.1
        }

        // Displays the question.
        GCText {
            id: questionItem
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
            height: bar.height * 0.8
            width: okButton.height
            sourceSize.width: okButton.width
            sourceSize.height: okButton.height
            z: 10
            anchors.top: calendarBox.bottom
            anchors.right: calendarBox.right
            anchors.margins: items.horizontalLayout ? 30 : 6
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
            height: okButton.height
            width: height
            anchors.top: calendarBox.bottom
            anchors.bottom: undefined
            anchors.left:  undefined
            anchors.right: answerChoices.visible ? calendarBox.right : okButton.left
            anchors.margins: items.horizontalLayout ? 30 : 8
        }
    }
}


