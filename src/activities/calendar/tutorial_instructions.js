/* GCompris - tutorial_instructions.js
 *
 * Copyright (C) 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
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

function get() {
    return [
        {
            "instruction": qsTr("This activity teaches how to use a calendar."),
            "instructionQml": ""
        },
        {
            "instruction": qsTr("For every year there are 12 months namely,"),
            "instructionQml": "qrc:/gcompris/src/activities/calendar/resource/Tutorial1.qml"
        },

        {
            "instruction": qsTr("For every week there are 7 days namely,"),
            "instructionQml" : "qrc:/gcompris/src/activities/calendar/resource/Tutorial2.qml"
        },

        {
            "instruction": qsTr("The number of days in a month are fixed for every year, except for february."),
            "instructionQml" : "qrc:/gcompris/src/activities/calendar/resource/Tutorial3.qml"
        },
        {
            "instruction": qsTr("Calculating Leap years."),
            "instructionQml": "qrc:/gcompris/src/activities/calendar/resource/Tutorial4.qml"
        },
        {
            "instruction": qsTr("Select the leap year out of the two."),
            "instructionQml": "qrc:/gcompris/src/activities/calendar/resource/Tutorial5.qml"
        }
    ]
}
