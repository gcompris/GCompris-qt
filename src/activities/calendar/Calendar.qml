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
import QtQuick.Controls
import QtQuick.Layouts 1.12
import core 1.0

import "calendar.js" as Activity
import "calendar_dataset.js" as Dataset
import "../../core"

ActivityBase {
    id: activity
    property var dataset: Dataset.get()
    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
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
            property alias activityBackground: activityBackground
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias errorRectangle: errorRectangle
            property alias calendar: calendar
            property alias okButton: okButton
            property alias questionItem: instructionPanel.textItem
            property alias score: score
            property alias answerChoices: answerChoices
            property alias okButtonParticles: okButtonParticles
            property bool horizontalLayout: activityBackground.width >= activityBackground.height * 1.5
            property alias daysOfTheWeekModel: daysOfTheWeekModel
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }
        Keys.onPressed: (event) => {
            if(answerChoices.visible) {
                answerChoices.handleKeys(event)
            }
            else {
                handleKeys(event);
            }
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(80 * ApplicationInfo.ratio, activityBackground.height * 0.1)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
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
            anchors.top: instructionPanel.bottom
            anchors.left: parent.left
            anchors.bottom: bar.top
            anchors.margins: GCStyle.halfMargins
            anchors.bottomMargin: GCStyle.baseMargins * 2
            interactive: false

            property bool keyNavigation: false

            width: visible ? Math.min(200 * ApplicationInfo.ratio, parent.width * 0.25) : 0
            cellWidth: width
            cellHeight: Math.min(40 * ApplicationInfo.ratio, height / 7)
            keyNavigationWraps: true
            delegate: ChoiceTable {
                required property int index
                required property int dayIndex
                required property string text
                width: answerChoices.cellWidth
                height: answerChoices.cellHeight
                choices.text: text
                listIndex: index
                day: dayIndex
            }
            Keys.enabled: answerChoices.visible
            function handleKeys(event) {
                if(items.buttonsBlocked) {
                    return;
                }
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
                    Activity.dayOfWeekSelected = model.get(currentIndex).dayIndex
                    answerChoices.currentItem.select()
                }
                if(event.key === Qt.Key_Space) {
                    keyNavigation = true
                    Activity.dayOfWeekSelected = model.get(currentIndex).dayIndex
                    answerChoices.currentItem.select()
                }
                if(event.key === Qt.Key_Return) {
                    keyNavigation = true
                    Activity.dayOfWeekSelected = model.get(currentIndex).dayIndex
                    answerChoices.currentItem.select()
                }
            }

            highlight: Rectangle {
                width: answerChoices.cellWidth
                height: answerChoices.cellHeight
                color: GCStyle.highlightColor
                border.width: GCStyle.thinnestBorder
                border.color: GCStyle.whiteBorder
                radius: GCStyle.halfMargins
                visible: answerChoices.keyNavigation
                y: answerChoices.currentItem.y
            }
            highlightFollowsCurrentItem: false
            focus: answerChoices.visible
        }

        Rectangle {
            id: calendarBox
            anchors {
                top: instructionPanel.bottom
                left: answerChoices.right
                right: parent.right
                topMargin: GCStyle.halfMargins
                rightMargin: answerChoices.visible || !items.horizontalLayout ?
                    GCStyle.halfMargins : 8 * GCStyle.halfMargins
                leftMargin: answerChoices.visible || !items.horizontalLayout ?
                    0 : 7 * GCStyle.halfMargins
            }
            height: items.horizontalLayout ?
                (parent.height - instructionPanel.height - GCStyle.baseMargins * 2 - bar.height - okButton.height) :
                Math.min(parent.width, parent.height - instructionPanel.height - GCStyle.baseMargins * 4 - bar.height - okButton.height)
            color: GCStyle.darkBg
            opacity: 0.3
        }

        Rectangle {
            id: navigationBar
            anchors {
                top: calendarBox.top
                right: calendarBox.right
                left: calendarBox.left
                margins: GCStyle.halfMargins
            }
            height: (calendarBox.height - GCStyle.baseMargins) / 8
            width: calendar.width
            color: GCStyle.lightBg

            BarButton {
                id: previousMonth
                width: Math.max(parent.height * 0.9, parent.height - GCStyle.baseMargins)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: GCStyle.halfMargins
                source: "qrc:/gcompris/src/core/resource/scroll_down.svg"
                rotation: 90
                visible: calendar.navigationBarVisible && (calendar.currentDate.getFullYear() > calendar.minimumDate.getFullYear() || (calendar.currentDate.getFullYear() == calendar.minimumDate.getFullYear() && calendar.currentDate.getMonth() > calendar.minimumDate.getMonth()))
                onClicked: {
                    if(!items.buttonsBlocked)
                        calendar.showPreviousMonth();
                }
            }
            GCText {
                id: dateText
                visible: calendar.navigationBarVisible
                text: grid.title
                color: GCStyle.darkText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSize: mediumSize
                fontSizeMode: Text.Fit
                anchors {
                    left: previousMonth.right
                    right: nextMonth.left
                    top: parent.top
                    bottom: parent.bottom
                    margins: GCStyle.tinyMargins
                    leftMargin: GCStyle.halfMargins
                    rightMargin: GCStyle.halfMargins
                }
            }
            BarButton {
                id: nextMonth
                width: previousMonth.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: previousMonth.anchors.leftMargin
                source: "qrc:/gcompris/src/core/resource/scroll_down.svg"
                rotation: 270
                visible: calendar.navigationBarVisible && (calendar.currentDate.getFullYear() < calendar.maximumDate.getFullYear() || (calendar.currentDate.getFullYear() == calendar.maximumDate.getFullYear() && calendar.currentDate.getMonth() < calendar.maximumDate.getMonth()));
                onClicked: {
                    if(!items.buttonsBlocked)
                        calendar.showNextMonth();
                }
            }
        }

        Rectangle {
            anchors.fill: calendar
            color: GCStyle.lightBg
        }
        GridLayout {
            id: calendar
            anchors {
                top: navigationBar.bottom
                left: calendarBox.left
                right: calendarBox.right
                bottom: calendarBox.bottom
                margins: GCStyle.halfMargins
                topMargin: 0
            }
            columns: 1
            rowSpacing: 0
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
            function addDaysToCurrentDate(daysToAdd: int) {
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
                    radius: 2
                    height: 15 * ApplicationInfo.ratio
                    width: 50
                    Label {
                        text: grid.locale.dayName((grid.locale.firstDayOfWeek+index) % 7, Locale.ShortFormat)
                        font.family: GCSingletonFontLoader.fontName
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 1
                        font.pixelSize: items.horizontalLayout ? parent.height * 0.7 : parent.width * 0.2
                        color: GCStyle.darkText
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
            if(items.buttonsBlocked) {
                return;
            }
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

        ErrorRectangle {
            id: errorRectangle
            imageSize: GCStyle.bigButtonHeight
            function releaseControls() {
                items.buttonsBlocked = false;
            }
            states: [
                State {
                    when: answerChoices.visible
                    PropertyChanges {
                        errorRectangle {
                            x: answerChoices.currentItem ? answerChoices.x + answerChoices.currentItem.x : 0
                            y: answerChoices.currentItem ? answerChoices.y + answerChoices.currentItem.y : 0
                            width: answerChoices.currentItem ? answerChoices.currentItem.width : 0
                            height: answerChoices.currentItem ? answerChoices.currentItem.height : 0
                            radius: answerChoices.currentItem ? answerChoices.currentItem.radius : 0
                            scale: answerChoices.currentItem ? answerChoices.currentItem.scale : 0
                        }
                    }
                },
                State {
                    when: !answerChoices.visible
                    PropertyChanges {
                        errorRectangle {
                            x: calendarBox.x
                            y: calendarBox.y
                            width: calendarBox.width
                            height: calendarBox.height
                            radius: calendarBox.radius
                            scale: calendarBox.scale
                        }
                    }
                }
            ]
        }

        // Answer Submission button.
        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: GCStyle.bigButtonHeight
            enabled: !items.buttonsBlocked
            z: 10
            anchors.top: calendarBox.bottom
            anchors.right: calendarBox.right
            anchors.margins: GCStyle.halfMargins
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
            anchors.top: undefined
            anchors.bottom: undefined
            anchors.left:  undefined
            anchors.verticalCenter: okButton.verticalCenter
            anchors.right: answerChoices.visible ? calendarBox.right : okButton.left
            anchors.margins: okButton.visible ? GCStyle.baseMargins : GCStyle.halfMargins
            onStop: { Activity.nextSubLevel(); }
        }
    }
}
