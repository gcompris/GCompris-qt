/* GCompris
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
