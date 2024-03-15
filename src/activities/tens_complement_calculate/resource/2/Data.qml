/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2024 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("2 pairs to make from 5 numbers.")
    difficulty: 4
    data: [
        {
            "value": [
                [
                    {
                        "randomValues": true,
                        "numberOfElements": 5
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 5
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 5
                    }
                ],
                [
                    {
                        "randomValues": true,
                        "numberOfElements": 5
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 5
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 5
                    },
                    {
                        "randomValues": true,
                        "numberOfElements": 5
                    }
                ]
            ]
        }
    ]
}
