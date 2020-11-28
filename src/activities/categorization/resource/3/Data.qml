/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   shivam828787@gmail.com <email.shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Unfamiliar categories.")
    difficulty: 5
    data:  [
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_household_goods.qml"
        ],
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_monuments.qml"
        ],
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_renewable.qml"
        ],
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_transports.qml"
        ],
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_odd_even.qml"
        ],
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_tools.qml"
        ]
    ]
}
