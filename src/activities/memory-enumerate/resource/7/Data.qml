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
    objective: qsTr("Match the numbers up to 8.")
    difficulty: 3

    readonly property string imageUrl: "qrc:/gcompris/src/activities/memory-enumerate/resource/butterfly.svg"

    readonly property var texts: [
        ["", 0],
        ["", 1],
        ["", 2],
        ["", 3],
        ["", 4],
        ["", 5],
        ["", 6],
        ["", 7],
        ["", 8]
    ]

    readonly property var repeaterModels: [
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
        ],
        [
            [{ "itemX": 0.1, "itemY": 0.05, "itemSize": 0.3, "itemRotation": -75, "itemSource": imageUrl},
            { "itemX": 0.6, "itemY": 0.05, "itemSize": 0.3, "itemRotation": 15, "itemSource": imageUrl},
            { "itemX": 0.25, "itemY": 0.35, "itemSize": 0.3, "itemRotation": -10, "itemSource": imageUrl},
            { "itemX": 0.65, "itemY": 0.4, "itemSize": 0.3, "itemRotation": 10, "itemSource": imageUrl},
            { "itemX": 0.1, "itemY": 0.65, "itemSize": 0.3, "itemRotation": 45, "itemSource": imageUrl},
            { "itemX": 0.6, "itemY": 0.7, "itemSize": 0.3, "itemRotation": -45, "itemSource": imageUrl}], ''
        ],
        [
            [{ "itemX": 0.1, "itemY": 0.02, "itemSize": 0.3, "itemRotation": 60, "itemSource": imageUrl},
            { "itemX": 0.6, "itemY": 0.05, "itemSize": 0.3, "itemRotation": -10, "itemSource": imageUrl},
            { "itemX": 0.25, "itemY": 0.25, "itemSize": 0.3, "itemRotation": -165, "itemSource": imageUrl},
            { "itemX": 0.65, "itemY": 0.3, "itemSize": 0.3, "itemRotation": -135, "itemSource": imageUrl},
            { "itemX": 0.1, "itemY": 0.5, "itemSize": 0.3, "itemRotation": 75, "itemSource": imageUrl},
            { "itemX": 0.65, "itemY": 0.6, "itemSize": 0.3, "itemRotation": 10, "itemSource": imageUrl},
            { "itemX": 0.3, "itemY": 0.75, "itemSize": 0.3, "itemRotation": -10, "itemSource": imageUrl}
            ], ''
        ],
        [
            [{ "itemX": 0.05, "itemY": 0.02, "itemSize": 0.3, "itemRotation": -25, "itemSource": imageUrl},
            { "itemX": 0.65, "itemY": 0.03, "itemSize": 0.3, "itemRotation": -10, "itemSource": imageUrl},
            { "itemX": 0.35, "itemY": 0.15, "itemSize": 0.3, "itemRotation": 5, "itemSource": imageUrl},
            { "itemX": 0.05, "itemY": 0.3, "itemSize": 0.3, "itemRotation": 15, "itemSource": imageUrl},
            { "itemX": 0.65, "itemY": 0.35, "itemSize": 0.3, "itemRotation": 170, "itemSource": imageUrl},
            { "itemX": 0.15, "itemY": 0.55, "itemSize": 0.3, "itemRotation": 50, "itemSource": imageUrl},
            { "itemX": 0.65, "itemY": 0.65, "itemSize": 0.3, "itemRotation": -10, "itemSource": imageUrl},
            { "itemX": 0.35, "itemY": 0.8, "itemSize": 0.3, "itemRotation": 5, "itemSource": imageUrl}], ''
        ]
    ]

    readonly property var sounds: [
        ["",
         GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0030.$CA")],
        ["",
         GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0031.$CA")],
        ["",
         GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0032.$CA")],
        ["",
         GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0033.$CA")],
        ["",
         GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0034.$CA")],
        ["",
         GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0035.$CA")],
        ["",
         GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0036.$CA")],
        ["",
         GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0037.$CA")],
        ["",
         GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0038.$CA")]
    ]

    data: [
        { // Level 1
            "columns": 4,
            "rows": 4,
            "texts": texts.slice(0, 9),
            "repeaterModels": repeaterModels.slice(0, 9),
            "sounds": sounds.slice(0, 9)
        }
    ]
}
