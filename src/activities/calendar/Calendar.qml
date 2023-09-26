/* GCompris - Calendar.qml
 *
 * SPDX-FileCopyrightText: 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Amit Sagtani <asagtani06@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.calendar 1.0
import GCompris 1.0

import "calendar.js" as Activity
import "calendar_dataset.js" as Dataset
import "../../core"

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
        sourceSize.width: width
        sourceSize.height: height

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
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

        Rectangle {
            id: navigationBar
            anchors.top: calendarBox.top
            anchors.horizontalCenter: calendarBox.horizontalCenter
            anchors.topMargin: calendarBox.height * 0.02
            height: calendarBox.height * 0.96 * 0.12
            width: calendar.width
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
                visible: calendar.navigationBarVisible && (calendar.currentDate.getFullYear() > calendar.minimumDate.getFullYear() || (calendar.currentDate.getFullYear() == calendar.minimumDate.getFullYear() && calendar.currentDate.getMonth() > calendar.minimumDate.getMonth()))
                onClicked: {
                    calendar.showPreviousMonth();
                }
            }
            GCText {
                id: dateText
                visible: calendar.navigationBarVisible
                text: grid.title
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
                visible: calendar.navigationBarVisible && (calendar.currentDate.getFullYear() < calendar.maximumDate.getFullYear() || (calendar.currentDate.getFullYear() == calendar.maximumDate.getFullYear() && calendar.currentDate.getMonth() < calendar.maximumDate.getMonth()));
                onClicked: {
                    calendar.showNextMonth();
                }
            }
        }

        Rectangle {
            anchors.fill: calendar
            color: "#F2F2F2"
        }
        GridLayout {
            id: calendar
            width: calendarBox.width * 0.96
            height: calendarBox.height * 0.96 - navigationBar.height
            anchors.top: navigationBar.bottom
            anchors.horizontalCenter: calendarBox.horizontalCenter
            columns: 1
            rowSpacing: -5
            property bool navigationBarVisible
            property var minimumDate
            property var maximumDate
            property date currentDate: new Date()
            property int selectedDay
            onSelectedDayChanged: {
                var date = new Date(calendar.currentDate);
                date.setDate(selectedDay);
                calendar.currentDate = date;
                Activity.daySelected = selectedDay;
            }

            function showPreviousMonth() {
                var date = new Date(calendar.currentDate);
                date.setMonth(date.getMonth()-1);
                if(minimumDate.getTime() <= date.getTime()) {
                       calendar.currentDate = date;
                }
            }
            function showNextMonth() {
                var date = new Date(calendar.currentDate);
                date.setMonth(date.getMonth()+1);
                if(date.getTime()<= maximumDate.getTime()) {
                       calendar.currentDate = date;
                }
            }
            function selectPreviousDay() {
                addDaysToCurrentDate(-1);
            }
            function selectNextDay() {
                addDaysToCurrentDate(1);
            }
            function selectPreviousWeek() {
                addDaysToCurrentDate(-7);
            }
            function selectNextWeek() {
                addDaysToCurrentDate(7);
            }
            function addDaysToCurrentDate(daysToAdd) {
                var date = new Date(calendar.currentDate);
                date.setDate(date.getDate()+daysToAdd);
                if(minimumDate.getTime() <= date.getTime() &&
                   date.getTime()<= maximumDate.getTime()) {
                    calendar.currentDate = date;
                    calendar.selectedDay = calendar.currentDate.getDate();
                }
            }
            function selectFirstDayOfMonth() {
                var date = new Date(calendar.currentDate);
                date.setDate(1);
                calendar.currentDate = date;
                calendar.selectedDay = calendar.currentDate.getDate();
            }
            function selectLastDayOfMonth() {
                // on some months, it goes to the next month...
                if(calendar.currentDate.getDate() == 31) return;
                var date = new Date(calendar.currentDate);
                date.setMonth(calendar.currentDate.getMonth()+1);
                date.setDate(0);
                calendar.currentDate = date;
                calendar.selectedDay = calendar.currentDate.getDate();
            }

            DayOfWeekRow {
                id: dayOfWeekRow
                locale: grid.locale
                font.bold: false
                spacing: 2
                delegate: Rectangle {
                    color: "lightgray"
                    height: 50
                    width: 50
                    radius: 5
                    Label {
                        text: grid.locale.dayName((grid.locale.firstDayOfWeek+index) % 7, Locale.ShortFormat)
                        font.family: GCSingletonFontLoader.fontLoader.name
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 1
                        font.pixelSize: items.horizontalLayout ? parent.height * 0.7 : parent.width * 0.2
                        color: "#373737"
                        anchors.centerIn: parent
                    }
                }
                Layout.fillWidth: true
            }

            MonthGrid {
                id: grid
                locale: Qt.locale(ApplicationInfo.localeShort)
                month: parent.currentDate.getMonth()
                year: parent.currentDate.getFullYear()
                spacing: 0

                readonly property int gridLineThickness: 1

                Layout.fillWidth: true
                Layout.fillHeight: true

                delegate: MonthGridDelegate {
                    id: gridDelegate
                    visibleMonth: grid.month
                }
            }
        }

        function handleKeys(event) {
            if(event.key === Qt.Key_Space && okButton.enabled) {
                Activity.checkAnswer()
                event.accepted = true
            }
            if(event.key === Qt.Key_Enter && okButton.enabled) {
                Activity.checkAnswer()
                event.accepted = true
            }
            if(event.key === Qt.Key_Return && okButton.enabled) {
                Activity.checkAnswer()
                event.accepted = true
            }
            if(event.key === Qt.Key_Home) {
                calendar.selectFirstDayOfMonth();
                event.accepted = true;
            }
            if(event.key === Qt.Key_End) {
                calendar.selectLastDayOfMonth();
                event.accepted = true;
            }
            if(event.key === Qt.Key_PageUp) {
                calendar.showPreviousMonth();
                event.accepted = true;
            }
            if(event.key === Qt.Key_PageDown) {
                calendar.showNextMonth();
                event.accepted = true;
            }
            if(event.key === Qt.Key_Left) {
                calendar.selectPreviousDay();
                event.accepted = true;
            }
            if(event.key === Qt.Key_Up) {
                calendar.selectPreviousWeek();
                event.accepted = true;
            }
            if(event.key === Qt.Key_Down) {
                calendar.selectNextWeek();
                event.accepted = true;
            }
            if(event.key === Qt.Key_Right) {
                calendar.selectNextDay();
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
            enabled: !bonus.isPlaying && !questionDelay.running
            z: 10
            anchors.top: calendarBox.bottom
            anchors.right: calendarBox.right
            anchors.margins: items.horizontalLayout ? 30 : 6
            ParticleSystemStarLoader {
                id: okButtonParticles
                clip: false
            }
            onClicked: {
                Activity.checkAnswer()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
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
