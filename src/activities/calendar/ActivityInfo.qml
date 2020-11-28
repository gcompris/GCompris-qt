/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "calendar/Calendar.qml"
    difficulty: 4
    icon: "calendar/calendar.svg"
    author: "Amit Sagtani &lt;asagtani06@gmail.com&gt;"
    //: Activity title
    title: qsTr("Calendar")
    //: Help title
    description: qsTr("Read the instructions and select the correct date on the calendar.")
    //intro: "Select the asked date on the calendar"
    //: Help goal
    goal: qsTr("Learn how to use a calendar.")
    //: Help prerequisite
    prerequisite: qsTr("Concept of week, month and year.")
    //: Help manual
    manual: qsTr("Read the instructions and select the correct date on the calendar, and then validate your answer by clicking on the OK button.") + ("<br><br>") + qsTr("In some levels, you need to find the day of the week for a given date. In this case, click on the corresponding day of the week in the list.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate through the answers") + ("</li><li>") +
          qsTr("Space or Enter: validate your answer") + ("</li></ul>")
    credit: ""
    section: "math measures"
    createdInVersion: 9000
}
