/* GCompris
 *
 * Copyright (C) 2014 Bruno Coudoin
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

.import GCompris 1.0 as GCompris //for ApplicationInfo

var url = "qrc:/gcompris/src/activities/memory-enumerate/resource/"

var texts = [
            ["", 0],
            ["", 1],
            ["", 2],
            ["", 3],
            ["", 4],
            ["", 5],
            ["", 6],
            ["", 7],
            ["", 8],
            ["", 9]
        ]

var images = [
            [url + 'math_0.svg', ''],
            [url + 'math_1.svg', ''],
            [url + 'math_2.svg', ''],
            [url + 'math_3.svg', ''],
            [url + 'math_4.svg', ''],
            [url + 'math_5.svg', ''],
            [url + 'math_6.svg', ''],
            [url + 'math_7.svg', ''],
            [url + 'math_8.svg', ''],
            [url + 'math_9.svg', '']
        ]

var sounds = [
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
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0038.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/U0039.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/10.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/11.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/12.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/13.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/14.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/15.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/16.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/17.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/18.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/19.$CA")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/20.$CA")]
        ]


var memory_cards = [
            { // Level 1
                columns: 3,
                rows: 2,
                texts: texts.slice(0, 6),
                images: images.slice(0, 6),
                sounds: sounds.slice(0, 6)
            },
            { // Level 2
                columns: 3,
                rows: 2,
                texts: texts.slice(4, 10),
                images: images.slice(4, 10),
                sounds: sounds.slice(4, 10)
            },
            { // Level 3
                columns: 5,
                rows: 2,
                texts: texts.slice(0, 10),
                images: images.slice(0, 10),
                sounds: sounds.slice(0, 10)
            }
        ]


function get() {
    return memory_cards
}
