/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2018 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Quarters of an hour.")
    difficulty: 5
    data: [
        {
            "numberOfSubLevels": 5,
            "fixedMinutes": 15,
            "displayMinutesHand": true,
            "fixedSeconds": 0,
            "displaySecondsHand": false
        },
        {
            "numberOfSubLevels": 5,
            "fixedMinutes": 45,
            "displayMinutesHand": true,
            "fixedSeconds": 0,
            "displaySecondsHand": false
        }
    ]
}
