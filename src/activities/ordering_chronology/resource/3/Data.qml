/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Tux gathers an apple.")
    difficulty: 5
    data: [
        {
            // To override the default hardcoded instruction, define instruction string
            // instruction: "overridden instruction"
            values: [
                'qrc:/gcompris/src/activities/chronos/resource/images/tuxtree-01.svg',
                'qrc:/gcompris/src/activities/chronos/resource/images/tuxtree-02.svg',
                'qrc:/gcompris/src/activities/chronos/resource/images/tuxtree-03.svg',
                'qrc:/gcompris/src/activities/chronos/resource/images/tuxtree-04.svg'
            ]
        }
    ]
}
