/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

Data {
    objective: qsTr("Time containing minutes.")
    difficulty: 5
    data: [
        {
            "numberOfSubLevels": 5,
            "fixedMinutes": 25,
            "displayMinutesHand": true,
            "fixedSeconds": 0,
            "displaySecondsHand": false
        },
        {
            "numberOfSubLevels": 5,
            "fixedMinutes": 55,
            "displayMinutesHand": true,
            "fixedSeconds": 0,
            "displaySecondsHand": false
        },
        {
            "numberOfSubLevels": 5,
            "fixedMinutes": 35,
            "displayMinutesHand": true,
            "fixedSeconds": 0,
            "displaySecondsHand": false
        },
        {
            "numberOfSubLevels": 10,
            "displayMinutesHand": true,
            "fixedSeconds": 0,
            "displaySecondsHand": false
        }

    ]
}
