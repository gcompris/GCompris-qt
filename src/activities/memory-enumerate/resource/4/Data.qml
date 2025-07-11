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
    objective: qsTr("Match the numbers up to 5.")
    difficulty: 2

    readonly property string imageUrl: "qrc:/gcompris/src/activities/memory-enumerate/resource/butterfly.svg"

    readonly property list<var> texts: [
        ["", 0],
        ["", 1],
        ["", 2],
        ["", 3],
        ["", 4],
        ["", 5]
    ]

    readonly property list<var> repeaterModels: [
        [
            [{ "itemX": 0, "itemY": 0, "itemSize": 0, "itemRotation": 0, "itemSource": imageUrl}], ''
        ],
        [
            [{ "itemX": 0.3, "itemY": 0.45, "itemSize": 0.3, "itemRotation": 30, "itemSource": imageUrl}], ''
        ],
        [
            [{ "itemX": 0.25, "itemY": 0.1, "itemSize": 0.3, "itemRotation": 50, "itemSource": imageUrl},
            { "itemX": 0.4, "itemY": 0.6, "itemSize": 0.3, "itemRotation": -50, "itemSource": imageUrl}], ''
        ],
        [
            [{ "itemX": 0.1, "itemY": 0.05, "itemSize": 0.3, "itemRotation": -10, "itemSource": imageUrl},
            { "itemX": 0.6, "itemY": 0.35, "itemSize": 0.3, "itemRotation": -25, "itemSource": imageUrl},
            { "itemX": 0.2, "itemY": 0.55, "itemSize": 0.3, "itemRotation": 30, "itemSource": imageUrl}], ''
        ],
        [
            [{ "itemX": 0.5, "itemY": 0.05, "itemSize": 0.3, "itemRotation": -40, "itemSource": imageUrl},
            { "itemX": 0.1, "itemY": 0.3, "itemSize": 0.3, "itemRotation": 45, "itemSource": imageUrl},
            { "itemX": 0.6, "itemY": 0.5, "itemSize": 0.3, "itemRotation": -15, "itemSource": imageUrl},
            { "itemX": 0.25, "itemY": 0.65, "itemSize": 0.3, "itemRotation": -30, "itemSource": imageUrl}], ''
        ],
        [
            [{ "itemX": 0.55, "itemY": 0.05, "itemSize": 0.3, "itemRotation": -15, "itemSource": imageUrl},
            { "itemX": 0.1, "itemY": 0.15, "itemSize": 0.3, "itemRotation": -150, "itemSource": imageUrl},
            { "itemX": 0.5, "itemY": 0.35, "itemSize": 0.3, "itemRotation": 45, "itemSource": imageUrl},
            { "itemX": 0.1, "itemY": 0.55, "itemSize": 0.3, "itemRotation": -45, "itemSource": imageUrl},
            { "itemX": 0.6, "itemY": 0.75, "itemSize": 0.3, "itemRotation": -10, "itemSource": imageUrl}], ''
        ]
    ]

    readonly property list<var> sounds: [
        ["",
         "voices-$CA/$LOCALE/alphabet/U0030.$CA"],
        ["",
         "voices-$CA/$LOCALE/alphabet/U0031.$CA"],
        ["",
         "voices-$CA/$LOCALE/alphabet/U0032.$CA"],
        ["",
         "voices-$CA/$LOCALE/alphabet/U0033.$CA"],
        ["",
         "voices-$CA/$LOCALE/alphabet/U0034.$CA"],
        ["",
         "voices-$CA/$LOCALE/alphabet/U0035.$CA"]
    ]

    data: [
        { // Level 1
            "columns": 4,
            "rows": 3,
            "texts": texts.slice(0, 6),
            "repeaterModels": repeaterModels.slice(0, 6),
            "sounds": sounds.slice(0, 6)
        }
    ]
}
