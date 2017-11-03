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
            property bool horizontalLayout: background.width > background.height * 1.5
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
            width: items.horizontalLayout ? parent.width * 0.45 : (answerChoices.visible ? parent.width * 0.50 : parent.width * 0.70)
            height: items.horizontalLayout ? parent.height * 0.70 : (answerChoices.visible ? parent.width * 0.50: parent.height * 0.40)
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
            frameVisible: true
            focus: !answerChoices.visible
            __locale: Qt.locale(ApplicationSettings.locale)
            style: CalendarStyle {
                navigationBar: Rectangle {
                    height: Math.round(TextSingleton.implicitHeight * 2.73)
                    color: "lightBlue"
                    Rectangle {
                        color: Qt.rgba(1, 1, 1, 0.6)
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
                        visible: ((calendar.visibleYear + calendar.visibleMonth) > Activity.minRange) ? true : false
                        onClicked: control.showPreviousMonth()
                    }
                    GCText {
                        id: dateText
                        text: styleData.title
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
                        height: parent.height
                        width: height * 0.75
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        source: "qrc:/gcompris/src/core/resource/bar_next.svg"
                        visible: ((calendar.visibleYear + calendar.visibleMonth) < Activity.maxRange) ? true : false
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
            if(event.key === Qt.Key_Space) {
                Activity.checkAnswer()
                event.accepted = true
            }
            if(event.key === Qt.Key_Enter) {
                Activity.checkAnswer()
                event.accepted = true
            }
            if(event.key === Qt.Key_Return) {
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

        // Creates a table consisting of days of weeks.
        GridView {
            id: answerChoices
            model: [qsTr("Sunday"), qsTr("Monday"), qsTr("Tuesday"), qsTr("Wednesday"), qsTr("Thursday"), qsTr("Friday"), qsTr("Saturday")]
            anchors.top: calendarBox.top
            anchors.left: questionItem.left
            anchors.right: calendarBox.left
            interactive: false

            property bool keyNavigation: false

            width: calendar.width * 0.5
            height: (calendar.height / 6.5) * 7
            cellWidth: calendar.width * 0.5
            cellHeight: calendar.height / 6.5
            keyNavigationWraps: true
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            delegate: ChoiceTable {
                width: calendar.width * 0.5
                height: calendar.height / 6.5
                choices.text: modelData
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
                if(event.key === Qt.Key_Enter) {
                    keyNavigation = true
                    Activity.dayOfWeekSelected = currentIndex
                    answerChoices.currentItem.select()
                }
                if(event.key === Qt.Key_Space) {
                    keyNavigation = true
                    Activity.dayOfWeekSelected = currentIndex
                    answerChoices.currentItem.select()
                }
                if(event.key === Qt.Key_Return) {
                    keyNavigation = true
                    Activity.dayOfWeekSelected = currentIndex
                    answerChoices.currentItem.select()
                }
            }

            highlight: Rectangle {
                width: calendar.width * 0.5
                height: calendar.height / 6.5
                color: "black"
                opacity: 0.8
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
            color: "black"
            border.width: 2
            radius: 10
            opacity: 0.85
            z: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 10
            }
            width: items.horizontalLayout ? calendarBox.width * 2 : parent.width - 20
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
            width: 50 * ApplicationInfo.ratio
            height: width
            sourceSize.width: width
            sourceSize.height: height
            y: parent.height * 0.8
            z: 10
            anchors {
                horizontalCenter: score.horizontalCenter
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
            fontSize: items.horizontalLayout ? 16 : (answerChoices.visible ? 12 : 8)
            anchors.top: calendarBox.top
            anchors.bottom: undefined
            anchors.left: calendarBox.right
            anchors.right: undefined
            anchors.margins: items.horizontalLayout ? 30 : 10
        }
    }
}


