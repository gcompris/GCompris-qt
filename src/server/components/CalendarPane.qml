/* GCompris - CalendarPane.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Layouts 1.2
import QtQuick.Controls

import "../singletons"

Column {
    id: calendarPane
    property int lineHeight: Style.defaultLineHeight
    property alias title: parentBox.text
    property bool activated: true
    readonly property int minWidth: 266

    enabled: activated
    visible: activated
    spacing: 0
    clip: true

    property int currentMonth: new Date().getMonth()
    property int currentYear: new Date().getFullYear()
    property int currentDay: new Date().getDate()
    property alias collapseButton: collapseButton
    property var locale: Qt.locale()
    property string startDate: ""
    property string endDate: ""
    property string lastDate: ""
    readonly property int calWidth: parent.width
    readonly property int calHeight: 173
    readonly property int monthHeight: lineHeight + calendarBlock.height + 5

    signal calendarChanged()

    function capitalizeFirstLetter(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }

    function lastDayOfMonth(Year, Month) {
        var date = new Date((new Date(Year, Month, 1)) - 1)
        return date.toLocaleDateString(locale, Locale.ShortFormat).slice(0, 2)
    }

    function strDateToLocale(strDate) {
        return (new Date(strDate.slice(0,4), Number(strDate.slice(4, 6) - 1), strDate.slice(6, 8)).toLocaleDateString(locale, Locale.ShortFormat))
    }

    function strDateToSql(strDate) {
        return (new Date(strDate.slice(0,4), Number(strDate.slice(4, 6) - 1), strDate.slice(6, 8)).toLocaleDateString(locale, 'yyyy-MM-dd 00:00:00'))
    }

    Rectangle {
        id: header
        width: parent.width
        height: calendarPane.lineHeight
        color: Style.colorHeaderPane
        radius: 5

        Text {
            id: parentBox
            anchors.fill: parent
            anchors.leftMargin: 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: (calendarPane.startDate === "") ? qsTr("Calendar") :
                  (calendarPane.startDate === calendarPane.endDate) ? calendarPane.strDateToLocale(calendarPane.startDate) :
                                            calendarPane.strDateToLocale(calendarPane.startDate) + " - " + calendarPane.strDateToLocale(calendarPane.endDate)
            font.pixelSize: Style.defaultPixelSize
            font.bold: true
        }

        SmallButton {
            id: collapseButton
            width: calendarPane.lineHeight
            height: calendarPane.lineHeight
            anchors.right: parent.right
            checkable: true
            checked: false
            text: checked ? "\uf0dd" : "\uf0d9"
            font.pixelSize: Style.defaultPixelSize
            onCheckedChanged: calendarPane.Layout.maximumHeight = (!checked) ? calendarPane.lineHeight : calendarPane.monthHeight
        }
    }

    Rectangle {
        id: calendarBlock
        width: parent.width
        height: childrenRect.height + 5
        color: Style.colorBackgroundPane

        Column {
            spacing: 0

            RowLayout {
                id: monthSelector
                width: calendarPane.calWidth

                SmallButton {
                    id: leftButton
                    Layout.preferredWidth: 25
                    Layout.preferredHeight: 30
                    text: "<"
                    onClicked: {
                        if (--calendarPane.currentMonth < 0) {
                            calendarPane.currentMonth = 11
                            calendarPane.currentYear--
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 5
                    color: Style.colorBackground
                    radius: 3
                    border.width: monthMouseArea.containsMouse ? 2 : 1

                    Text {
                        id: monthName
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: calendarPane.capitalizeFirstLetter(calendarPane.locale.monthName(monthGrid.month, Locale.LongFormat)) + " " + monthGrid.year
                        font.bold: true
                        font.pixelSize: Style.defaultPixelSize + 2
                    }

                    MouseArea {
                        id: monthMouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true
                        onClicked: {
                            calendarPane.startDate = String(calendarPane.currentYear) + ('00'+ (calendarPane.currentMonth + 1)).slice(-2) + '01'
                            calendarPane.endDate = String(calendarPane.currentYear) + ('00'+ (calendarPane.currentMonth + 1)).slice(-2) + calendarPane.lastDayOfMonth(calendarPane.currentYear, calendarPane.currentMonth + 1)
                            if (calendarPane.endDate > calendarPane.lastDate)
                                calendarPane.endDate = calendarPane.lastDate
                            calendarPane.calendarChanged()
                        }
                        onDoubleClicked: {
                            calendarPane.startDate = calendarPane.endDate = ""
                            calendarPane.calendarChanged()
                        }
                    }
                }

                SmallButton {
                    id: rightButton
                    Layout.preferredWidth: 25
                    Layout.preferredHeight: 30
                    text: ">"
                    enabled: (String(calendarPane.currentYear) + ('00'+ (calendarPane.currentMonth + 1)).slice(-2)) < calendarPane.lastDate.slice(0,6)
                    onClicked: {
                        if (++calendarPane.currentMonth > 11) {
                            calendarPane.currentMonth = 0
                            calendarPane.currentYear++
                        }
                    }
                }
            }

            DayOfWeekRow {
                id: dayOfWeek
                locale: monthGrid.locale
                width: calendarPane.calWidth
                height: 25
                font.pixelSize: Style.defaultPixelSize
            }

            MonthGrid {
                id: monthGrid
                month: (calendarPane.currentMonth - 1 + 13) % 12
                year: (calendarPane.currentMonth - 1 + 1 < 0) ? calendarPane.currentYear - 1 : calendarPane.currentYear
                locale: calendarPane.locale
                width: calendarPane.calWidth
                height: calendarPane.calHeight
                font.pixelSize: Style.defaultPixelSize
                clip: true

                delegate: Rectangle {
                    property string dateStr: new Date(model.year, model.month, model.day).toLocaleDateString(monthGrid.locale, "yyyyMMdd")
                    color: (model.month !== monthGrid.month) ? "transparent"
                         : ((dateStr >= startDate) && (dateStr <= endDate)) ? Style.colorDateSelected
                         : Style.colorBackground
                    visible: (dateStr <= lastDate)
                    radius: 3
                    Layout.margins: 3
                    border.width: (model.month !== monthGrid.month) ? 0 : mouseArea.containsMouse ? 2 : 1

                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        opacity: model.month === monthGrid.month ? 1 : 0
                        text: model.day
                        font: monthGrid.font

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            enabled: (model.month === monthGrid.month)
                            hoverEnabled: true
                            onClicked: {
                                var dateCopy = dateStr
                                if (dateStr > lastDate)
                                    dateCopy = lastDate
                                if ((mouse.modifiers & (Qt.ControlModifier | Qt.ShiftModifier)) || (mouse.button === Qt.RightButton))
                                    endDate = dateCopy
                                else
                                    startDate = endDate = dateCopy
                                if (startDate > endDate) {  // swap dates
                                    var mem = startDate
                                    startDate = endDate
                                    endDate = mem
                                }
                                calendarChanged()
                            }
                            onDoubleClicked: {
                                startDate = endDate = ""
                                calendarChanged()
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
