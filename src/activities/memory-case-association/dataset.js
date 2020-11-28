/* GCompris - dataset.js
 *
 * SPDX-FileCopyrightText: 2017 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core


var url = "qrc:/gcompris/src/activities/categorization/resource/images/alphabets/"

var images = [
                [url + 'lowerA.svg', url + 'upperA.svg'],
                [url + 'lowerB.svg', url + 'upperB.svg'],
                [url + 'lowerC.svg', url + 'upperC.svg'],
                [url + 'lowerD.svg', url + 'upperD.svg'],
                [url + 'lowerE.svg', url + 'upperE.svg'],
                [url + 'lowerF.svg', url + 'upperF.svg'],
                [url + 'lowerG.svg', url + 'upperG.svg'],
                [url + 'lowerH.svg', url + 'upperH.svg'],
                [url + 'lowerI.svg', url + 'upperI.svg'],
                [url + 'lowerJ.svg', url + 'upperJ.svg'],
                [url + 'lowerK.svg', url + 'upperK.svg'],
                [url + 'lowerL.svg', url + 'upperL.svg'],
                [url + 'lowerM.svg', url + 'upperM.svg'],
                [url + 'lowerN.svg', url + 'upperN.svg'],
                [url + 'lowerO.svg', url + 'upperO.svg'],
                [url + 'lowerP.svg', url + 'upperP.svg'],
                [url + 'lowerQ.svg', url + 'upperQ.svg'],
                [url + 'lowerR.svg', url + 'upperR.svg'],
                [url + 'lowerS.svg', url + 'upperS.svg'],
                [url + 'lowerT.svg', url + 'upperT.svg'],
                [url + 'lowerU.svg', url + 'upperU.svg'],
                [url + 'lowerV.svg', url + 'upperV.svg'],
                [url + 'lowerW.svg', url + 'upperW.svg'],
                [url + 'lowerX.svg', url + 'upperX.svg'],
                [url + 'lowerY.svg', url + 'upperY.svg'],
                [url + 'lowerZ.svg', url + 'upperZ.svg']
            ]

var sounds = [
            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('A')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('A'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('B')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('B'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('C')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('C'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('D')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('D'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('E')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('E'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('F')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('F'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('G')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('G'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('H')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('H'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('I')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('I'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('J')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('J'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('K')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('K'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('L')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('L'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('M')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('M'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('N')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('N'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('O')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('O'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('P')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('P'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('Q')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('Q'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('R')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('R'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('S')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('S'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('T')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('T'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('U')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('U'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('V')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('V'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('W')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('W'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('X')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('X'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('Y')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('Y'))],

            [GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('Z')),
             GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/alphabet/" + Core.getSoundFilenamForChar('Z'))]
        ]

var memory_cards = [
            { // Level 1
                columns: 3,
                rows: 2,
                images: images.slice(0, 6),
                sounds: sounds.slice(0, 6)
            },
            { // Level 2
                columns: 4,
                rows: 2,
                images: images.slice(6, 14),
                sounds: sounds.slice(6, 14)
            },
            { // Level 3
                columns: 5,
                rows: 2,
                images: images.slice(14, 24),
                sounds: sounds.slice(14, 24)
            },
            { // Level 4
                columns: 4,
                rows: 3,
                images: images.slice(14, 26),
                sounds: sounds.slice(14, 26)
            }
        ]

function get() {
    return memory_cards
}