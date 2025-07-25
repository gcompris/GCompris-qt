/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 * SPDX-FileCopyrightText: 2023 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import core 1.0
import core 1.0 as GCompris

Data {
    objective: qsTr("Match the numbers up to 2.")
    difficulty: 1

    readonly property string imageUrl: "qrc:/gcompris/src/activities/memory-enumerate/resource/butterfly.svg"

    readonly property list<var> texts: [
                ["", 1],
                ["", 2]
            ]

    readonly property list<var> repeaterModels: [
        [
            [{ "itemX": 0.3, "itemY": 0.45, "itemSize": 0.3, "itemRotation": 30, "itemSource": imageUrl}], ''
        ],
        [
            [{ "itemX": 0.25, "itemY": 0.1, "itemSize": 0.3, "itemRotation": 50, "itemSource": imageUrl},
            { "itemX": 0.4, "itemY": 0.6, "itemSize": 0.3, "itemRotation": -50, "itemSource": imageUrl}], ''
        ]
    ]

    readonly property list<var> sounds: [
                ["",
                 "voices-$CA/$LOCALE/alphabet/U0031.$CA"],
                ["",
                 "voices-$CA/$LOCALE/alphabet/U0032.$CA"]
            ]

    data: [
        { // Level 1
            "columns": 2,
            "rows": 2,
            "texts": texts.slice(0, 2),
            "repeaterModels": repeaterModels.slice(0, 2),
            "sounds": sounds.slice(0, 2)
        }
    ]
}
