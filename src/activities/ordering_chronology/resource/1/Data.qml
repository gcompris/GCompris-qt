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
    objective: qsTr("Cycle of life of a flower.")
    difficulty: 5
    data: [
        {
            // To override the default hardcoded instruction, define instruction string
            // instruction: "overridden instruction"
            values: [
                'qrc:/gcompris/src/activities/chronos/resource/images/garden-01.svg',
                'qrc:/gcompris/src/activities/chronos/resource/images/garden-02.svg',
                'qrc:/gcompris/src/activities/chronos/resource/images/garden-03.svg',
                'qrc:/gcompris/src/activities/chronos/resource/images/garden-04.svg'
            ]
        }
    ]
}
