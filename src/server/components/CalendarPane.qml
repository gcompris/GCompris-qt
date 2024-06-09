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
    id: gcCalendar
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
        height: lineHeight
        color: Style.colorHeaderPane
        radius: 5

        Text {
            id: parentBox
            anchors.fill: parent
            anchors.leftMargin: 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: (startDate === "") ? qsTr("Calendar") :
                  (startDate === endDate) ? strDateToLocale(startDate) :
                                            strDateToLocale(startDate) + " - " + strDateToLocale(endDate)
            font.pixelSize: Style.defaultPixelSize
            font.bold: true
        }

        SmallButton {
            id: collapseButton
            width: lineHeight
            height: lineHeight
            anchors.right: parent.right
            checkable: true
            checked: false
            text: checked ? "\uf0dd" : "\uf0d9"
            font.pixelSize: Style.defaultPixelSize
            onCheckedChanged: calendarPane.Layout.maximumHeight = (!checked) ? lineHeight : monthHeight
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
                width: calWidth

                Button {
                    id: leftButton
                    Layout.preferredWidth: 25
                    text: "<"
                    onClicked: {
                        if (--currentMonth < 0) {
                            currentMonth = 11
                            currentYear--
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
                        text: capitalizeFirstLetter(gcCalendar.locale.monthName(monthGrid.month, Locale.LongFormat)) + " " + monthGrid.year
                        font.bold: true
                        font.pixelSize: 15
                    }

                    MouseArea {
                        id: monthMouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true
                        onClicked: {
                            startDate = String(currentYear) + ('00'+ (currentMonth + 1)).slice(-2) + '01'
                            endDate = String(currentYear) + ('00'+ (currentMonth + 1)).slice(-2) + lastDayOfMonth(currentYear, currentMonth + 1)
                            if (endDate > lastDate)
                                endDate = lastDate
                            calendarChanged()
                        }
                        onDoubleClicked: {
                            startDate = endDate = ""
                            calendarChanged()
                        }
                    }
                }

                Button {
                    id: rightButton
                    Layout.preferredWidth: 25
                    text: ">"
                    enabled: (String(currentYear) + ('00'+ (currentMonth + 1)).slice(-2)) < lastDate.slice(0,6)
                    onClicked: {
                        if (++currentMonth > 11) {
                            currentMonth = 0
                            currentYear++
                        }
                    }
                }
            }

            DayOfWeekRow {
                id: dayOfWeek
                locale: monthGrid.locale
                width: calWidth
                height: 25
            }

            MonthGrid {
                id: monthGrid
                month: (currentMonth - 1 + 13) % 12
                year: (currentMonth - 1 + 1 < 0) ? currentYear - 1 : currentYear
                locale: gcCalendar.locale
                width: calWidth
                height: calHeight
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
