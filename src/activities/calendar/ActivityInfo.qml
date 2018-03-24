/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
    name: "calendar/Calendar.qml"
    difficulty: 4
    icon: "calendar/calendar.svg"
    author: "Amit Sagtani &lt;asagtani06@gmail.com&gt;"
    demo: true
    //: Activity title
    title: qsTr("Calendar")
    //: Help title
    description: qsTr("Read the instructions and select the correct date on the calendar")
    //intro: "Select the asked date on the calendar"
    //: Help goal
    goal: qsTr("Learn how to use a calendar")
    //: Help prerequisite
    prerequisite: qsTr("Concept of week, month and year")
    //: Help manual
    manual: qsTr("Read the instructions and select the correct date on the calendar.")
    credit: ""
    section: "discovery"
    createdInVersion: 9000
}
