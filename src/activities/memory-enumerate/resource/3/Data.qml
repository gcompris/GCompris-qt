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

import GCompris 1.0
import GCompris 1.0 as GCompris

Data {
    objective: qsTr("Match the numbers up to 4.")
    difficulty: 1

    readonly property string imageUrl: "qrc:/gcompris/src/activities/memory-enumerate/resource/butterfly.svg"

    readonly property var texts: [
                ["", 1],
                ["", 2],
                ["", 3],
                ["", 4]
            ]

    readonly property var repeaterModels: [
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
        ]
    ]

    readonly property var sounds: [
                ["",
                 GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0031.$CA")],
                ["",
                 GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0032.$CA")],
                ["",
                 GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0033.$CA")],
                ["",
                 GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0034.$CA")],
            ]

    data: [
        { // Level 1
            "columns": 4,
            "rows": 2,
            "texts": texts.slice(0, 4),
            "repeaterModels": repeaterModels.slice(0, 4),
            "sounds": sounds.slice(0, 4)
        }
    ]
}
