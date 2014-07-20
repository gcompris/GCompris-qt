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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
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
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U0030.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U0031.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U0032.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U0033.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U0034.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U0035.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U0036.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U0037.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U0038.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U0039.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/10.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/11.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/12.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/13.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/14.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/15.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/16.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/17.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/18.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/19.ogg")],
            ["",
             GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/20.ogg")]
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
