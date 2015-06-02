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

var texts = [
            [qsTr("zero"), 0],
            [qsTr("one"), 1],
            [qsTr("two"), 2],
            [qsTr("three"), 3],
            [qsTr("four"), 4],
            [qsTr("five"), 5],
            [qsTr("six"), 6],
            [qsTr("seven"), 7],
            [qsTr("eight"), 8],
            [qsTr("nine"), 9],
            [qsTr("ten"), 10],
            [qsTr("eleven"), 11],
            [qsTr("twelve"), 12],
            [qsTr("thirteen"), 13],
            [qsTr("fourteen"), 14],
            [qsTr("fifteen"), 15],
            [qsTr("sixteen"), 16],
            [qsTr("seventeen"), 17],
            [qsTr("eighteen"), 18],
            [qsTr("nineteen"), 19],
            [qsTr("twenty"), 20]
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
                sounds: sounds.slice(0, 6)
            },
            { // Level 2
                columns: 3,
                rows: 2,
                texts: texts.slice(5, 11),
                sounds: sounds.slice(5, 11)
            },
            { // Level 3
                columns: 5,
                rows: 2,
                texts: texts.slice(0, 11),
                sounds: sounds.slice(0, 11)
            },
            { // Level 4
                columns: 5,
                rows: 2,
                texts: texts.slice(10, 21),
                sounds: sounds.slice(10, 21)
            },
            { // Level 5
                columns: 6,
                rows: 3,
                texts: texts.slice(0, 21),
                sounds: sounds.slice(0, 21)
            }
        ]


function get() {
    return memory_cards
}
