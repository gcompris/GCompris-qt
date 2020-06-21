/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <email.shivam828787@gmail.com>
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
    objective: qsTr("Countries of Europe.")
    difficulty: 6
    data: [
        [
            //France
            "qrc:/gcompris/src/activities/geo-country/resource/board/board1_0.qml"
        ],
        [
            //Germany
            "qrc:/gcompris/src/activities/geo-country/resource/board/board2_0.qml"
        ],
        [
            //Poland
            "qrc:/gcompris/src/activities/geo-country/resource/board/board4_0.qml"
        ],
        [
            //Norway
            "qrc:/gcompris/src/activities/geo-country/resource/board/board6_0.qml"
        ],
        [
            //Italy
            "qrc:/gcompris/src/activities/geo-country/resource/board/board11_0.qml",
            "qrc:/gcompris/src/activities/geo-country/resource/board/board11_1.qml",
            "qrc:/gcompris/src/activities/geo-country/resource/board/board11_2.qml",
            "qrc:/gcompris/src/activities/geo-country/resource/board/board11_3.qml"
        ],
        [
            //Scotland
            "qrc:/gcompris/src/activities/geo-country/resource/board/board15_0.qml",
            "qrc:/gcompris/src/activities/geo-country/resource/board/board15_1.qml",
            "qrc:/gcompris/src/activities/geo-country/resource/board/board15_2.qml",
            "qrc:/gcompris/src/activities/geo-country/resource/board/board15_3.qml"
        ],
        [
            //Romania
            "qrc:/gcompris/src/activities/geo-country/resource/board/board16_0.qml"
        ]
    ]
}
