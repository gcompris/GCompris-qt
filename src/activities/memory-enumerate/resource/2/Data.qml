/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0
import GCompris 1.0 as GCompris

Data {
    objective: qsTr("Match the numbers up to 3.")
    difficulty: 1

    readonly property string url: "qrc:/gcompris/src/activities/memory-enumerate/resource/"

    readonly property var texts: [
                ["", 1],
                ["", 2],
                ["", 3]

            ]

    readonly property var images: [
                [url + 'math_1.svg', ''],
                [url + 'math_2.svg', ''],
                [url + 'math_3.svg', '']
            ]

    readonly property var sounds: [
                ["",
                 GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0031.$CA")],
                ["",
                 GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0032.$CA")],
                ["",
                 GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0033.$CA")]
            ]

    data: [
        { // Level 1
            "columns": 3,
            "rows": 2,
            "texts": texts.slice(0, 4),
            "images": images.slice(0, 4),
            "sounds": sounds.slice(0, 4)
        }
    ]
}
