/* GCompris - MonthGridDelegate.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import GCompris 1.0
import "../../core"

ColumnLayout {
    id: root

    property int visibleMonth

    readonly property color sameMonthDateTextColor: "#373737"
    readonly property color selectedDateColor: "#3778d0"
    readonly property color selectedDateTextColor: "white"
    readonly property color differentMonthDateTextColor: "#bbb"
    readonly property color invalidDateColor: "#dddddd"

    property bool selected: calendar.selectedDay == day && month == root.visibleMonth
    Rectangle {
        id: caseBox
        color: selected ? selectedDateColor : "#F2F2F2"
        width: root.width
        height: root.height
        radius: 2
        border.width: 1
        border.color: "lightgray"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(month == root.visibleMonth) {
                    calendar.selectedDay = day;
                }
                else if((month < root.visibleMonth && (root.visibleMonth != 11 || month != 0)) || (root.visibleMonth == 0 && month == 11)) {
                    calendar.showPreviousMonth();
                }
                else if(month > root.visibleMonth || (root.visibleMonth == 11 && month == 0)) {
                    calendar.showNextMonth();
                }
            }
        }

        Label {
            id: dayText
            text: day
            anchors.centerIn: parent
            font.family: GCSingletonFontLoader.fontLoader.name
            font.pixelSize: Math.min(parent.height/3, parent.width/3)
            color: {
                var theColor = invalidDateColor;
                // Date is within the valid range.
                theColor = (month == root.visibleMonth) ? sameMonthDateTextColor : differentMonthDateTextColor;
                if (root.selected)
                    theColor = selectedDateTextColor;
                return theColor;
            }
            Layout.fillWidth: true
        }
    }
}
