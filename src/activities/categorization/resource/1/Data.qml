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
    objective: qsTr("Very familiar categories.")
    difficulty: 3
    data:  [
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_colors.qml"
        ],
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_animals.qml"
        ],
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_food.qml"
        ],
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_numbers.qml"
        ],
        [
            "qrc:/gcompris/src/activities/categorization/resource/board/category_birds.qml"
        ]
    ]
}
