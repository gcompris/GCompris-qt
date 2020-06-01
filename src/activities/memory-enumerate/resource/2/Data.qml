/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
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
