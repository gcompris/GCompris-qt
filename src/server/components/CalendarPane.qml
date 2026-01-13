/* GCompris - CalendarPane.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls

import "../components"
import "../singletons"

Column {
    id: calendarPane
    property bool activated: true
    property alias title: title.text
    height: childrenRect.height
    width: parent.width
    enabled: activated
    visible: activated
    spacing: 0
    clip: true

    property int currentMonth: new Date().getMonth()
    property int currentYear: new Date().getFullYear()
    property int currentDay: new Date().getDate()
    property alias collapseButton: collapseButton
    property var locale: Qt.locale(Master.locale)
    property string startDate: ""
    property string endDate: ""
    property string lastDate: ""
    readonly property int calHeight: Style.controlSize * 6
    readonly property int monthHeight: Style.lineHeight + calendarBlock.height + 5

    signal calendarChanged()

    function capitalizeFirstLetter(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }

    function lastDayOfMonth(Year, Month) {
        var date = new Date((new Date(Year, Month, 1)) - 1);
        return date.toLocaleDateString(locale, Locale.ShortFormat).slice(0, 2);
    }

    function strDateToLocale(strDate) {
        return (new Date(strDate.slice(0,4), Number(strDate.slice(4, 6) - 1), strDate.slice(6, 8)).toLocaleDateString(locale, Locale.ShortFormat));
    }

    function strDateToSql(strDate) {
        return (new Date(strDate.slice(0,4), Number(strDate.slice(4, 6) - 1), strDate.slice(6, 8)).toLocaleDateString(locale, 'yyyy-MM-dd 00:00:00'));
    }

    Rectangle {
        id: header
        width: parent.width
        height: Style.lineHeight
        color: Style.selectedPalette.base
        border.width: Style.defaultBorderWidth
        border.color: Style.selectedPalette.accent

        DefaultLabel {
            id: title
            anchors {
                left: parent.left
                right: collapseButton.left
                margins: Style.margins
                verticalCenter: parent.verticalCenter
            }
            horizontalAlignment: Text.AlignHCenter
            text: (calendarPane.startDate === "") ? qsTr("Calendar") :
                  (calendarPane.startDate === calendarPane.endDate) ? calendarPane.strDateToLocale(calendarPane.startDate) :
                                            calendarPane.strDateToLocale(calendarPane.startDate) + " - " + calendarPane.strDateToLocale(calendarPane.endDate)
            font.bold: true
            color: Style.selectedPalette.text
        }

        CollapseButton {
            id: collapseButton
            anchors.right: parent.right
            checked: false
        }
    }

    Rectangle {
        id: calendarBlock
        width: parent.width
        height: visible ? calendarColumn.height + calendarColumn.y : 0
        color: Style.selectedPalette.alternateBase
        visible: collapseButton.checked

        Column {
            id: calendarColumn
            y: Style.tinyMargins
            width: parent.width
            height: childrenRect.height + Style.smallMargins
            spacing: 0

            Row {
                id: monthSelector
                width: calendarPane.width - Style.smallMargins
                anchors.horizontalCenter: parent.horizontalCenter

                SmallButton {
                    id: leftButton
                    width: Style.controlSize
                    height: Style.controlSize
                    icon.source: "qrc:/gcompris/src/server/resource/icons/dark_dropdownArrow.svg"
                    rotation: 90
                    onClicked: {
                        if(--calendarPane.currentMonth < 0) {
                            calendarPane.currentMonth = 11;
                            calendarPane.currentYear--;
                        }
                    }
                }

                SmallButtonText {
                    height: Style.controlSize
                    width: parent.width - leftButton.width * 2
                    text: calendarPane.capitalizeFirstLetter(calendarPane.locale.monthName(monthGrid.month, Locale.LongFormat)) + " " + monthGrid.year
                    onClicked: {
                        calendarPane.startDate = String(calendarPane.currentYear) +
                            ('00'+ (calendarPane.currentMonth + 1)).slice(-2) + '01';
                        calendarPane.endDate = String(calendarPane.currentYear) +
                            ('00'+ (calendarPane.currentMonth + 1)).slice(-2) +
                            calendarPane.lastDayOfMonth(calendarPane.currentYear, calendarPane.currentMonth + 1);
                        if(calendarPane.endDate > calendarPane.lastDate) {
                            calendarPane.endDate = calendarPane.lastDate;
                        }
                        calendarPane.calendarChanged();
                    }
                    onDoubleClicked: {
                        calendarPane.startDate = calendarPane.endDate = "";
                        calendarPane.calendarChanged();
                    }
                }

                SmallButton {
                    id: rightButton
                    width: Style.controlSize
                    height: Style.controlSize
                    icon.source: "qrc:/gcompris/src/server/resource/icons/dark_dropdownArrow.svg"
                    rotation: 270
                    enabled: (String(calendarPane.currentYear) + ('00'+ (calendarPane.currentMonth + 1)).slice(-2)) < calendarPane.lastDate.slice(0,6)
                    onClicked: {
                        if(++calendarPane.currentMonth > 11) {
                            calendarPane.currentMonth = 0;
                            calendarPane.currentYear++;
                        }
                    }
                }
            }

            DayOfWeekRow {
                id: dayOfWeek
                locale: monthGrid.locale
                width: calendarPane.width - Style.margins
                anchors.horizontalCenter: parent.horizontalCenter
                height: Style.lineHeight
                font.pixelSize: Style.textSize
                delegate: Text {
                    text: shortName
                    font: dayOfWeek.font
                    fontSizeMode: Text.Fit
                    color: Style.selectedPalette.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    required property string shortName
                }
            }

            MonthGrid {
                id: monthGrid
                month: (calendarPane.currentMonth - 1 + 13) % 12
                year: (calendarPane.currentMonth - 1 + 1 < 0) ? calendarPane.currentYear - 1 : calendarPane.currentYear
                locale: calendarPane.locale
                width: dayOfWeek.width
                height: calendarPane.calHeight
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Style.textSize
                clip: true

                delegate: Rectangle {
                    id: dayDelegate
                    property string dateStr: new Date(model.year, model.month, model.day).toLocaleDateString(monthGrid.locale, "yyyyMMdd")

                    property bool selected: ((dateStr >= calendarPane.startDate) && (dateStr <= calendarPane.endDate))

                    property bool hovered: mouseArea.containsMouse

                    color: selected ? Style.selectedPalette.highlight :
                        (hovered ? Style.selectedPalette.accent : Style.selectedPalette.base)
                    enabled: model.month === monthGrid.month
                    opacity: enabled ? 1 : 0
                    visible: (dateStr <= lastDate)
                    radius: 3
                    border.color: hovered ? Style.selectedPalette.text :
                                            Style.selectedPalette.accent
                    border.width: hovered ? 2 : 0

                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Style.textSize
                        fontSizeMode: Text.Fit
                        text: model.day
                        color: dayDelegate.selected || dayDelegate.hovered ?
                                Style.selectedPalette.highlightedText :
                                Style.selectedPalette.text

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            hoverEnabled: true
                            onClicked: (mouse)=> {
                                var dateCopy = dateStr
                                if(dateCopy == startDate && dateCopy == endDate && dateCopy != "") {
                                    startDate = endDate = "";
                                    calendarChanged();
                                    return
                                }
                                if(dateStr > lastDate) {
                                    dateCopy = lastDate;
                                }
                                if((mouse.modifiers & (Qt.ControlModifier | Qt.ShiftModifier)) || (mouse.button === Qt.RightButton)) {
                                    endDate = dateCopy;
                                } else {
                                    startDate = endDate = dateCopy;
                                }
                                if(startDate > endDate) {  // swap dates
                                    var mem = startDate;
                                    startDate = endDate;
                                    endDate = mem;
                                }
                                calendarChanged();
                            }
                            onDoubleClicked: {
                                startDate = endDate = "";
                                calendarChanged();
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        lastDate = new Date(currentYear, currentMonth, currentDay).toLocaleDateString(locale, "yyyyMMdd")
    }
}
