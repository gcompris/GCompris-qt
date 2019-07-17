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
            "instruction": qsTr("This activity teaches students to find the exact date."),
            "instructionQml": ""
        },
        {
            "instruction": qsTr("For example if today is 15 December 2019, find the date 5 days after today,"),
            "instructionQml": "qrc:/gcompris/src/activities/find_the_day/resource/Tutorial1.qml"
        },
        {
            "instruction": qsTr("What will be the date 20 days after 25 July 2018"),
            "instructionQml" : "qrc:/gcompris/src/activities/find_the_day/resource/Tutorial2.qml"
        },
        {
            "instruction": qsTr("What will be the date 5 days after 11 August 2018."),
            "instructionQml" : "qrc:/gcompris/src/activities/find_the_day/resource/Tutorial3.qml"
        },
        {
            "instruction": qsTr("What will be the date 25 days after 18 April 2018."),
            "instructionQml": "qrc:/gcompris/src/activities/find_the_day/resource/Tutorial4.qml"
        }
    ]
}
