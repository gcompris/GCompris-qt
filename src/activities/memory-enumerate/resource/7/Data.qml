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
    objective: qsTr("Match the numbers up to 8.")
    difficulty: 3

    readonly property string url: "qrc:/gcompris/src/activities/memory-enumerate/resource/"

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

    readonly property var images: [
        [url + 'math_0.svg', ''],
        [url + 'math_1.svg', ''],
        [url + 'math_2.svg', ''],
        [url + 'math_3.svg', ''],
        [url + 'math_4.svg', ''],
        [url + 'math_5.svg', ''],
        [url + 'math_6.svg', ''],
        [url + 'math_7.svg', ''],
        [url + 'math_8.svg', ''],
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
            "images": images.slice(0, 9),
            "sounds": sounds.slice(0, 9)
        }
    ]
}
