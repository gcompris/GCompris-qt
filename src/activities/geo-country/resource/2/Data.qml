/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <email.shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Countries of Asia.")
    difficulty: 6
    data: [
        [
            //India
            "qrc:/gcompris/src/activities/geo-country/resource/board/board12_0.qml"
        ],
        [
            //Turkey
            "qrc:/gcompris/src/activities/geo-country/resource/board/board5_0.qml",
            "qrc:/gcompris/src/activities/geo-country/resource/board/board5_1.qml"
        ],
        [
            //China
            "qrc:/gcompris/src/activities/geo-country/resource/board/board14_0.qml"
        ]
    ]
}
