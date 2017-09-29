/* GCompris - memory-case-association.js
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
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

var memory_cards = [
            { // Level 1
                columns: 3,
                rows: 2,
                images: images.slice(0,6)
            },
            { // Level 2
                columns: 4,
                rows: 2,
                images: images.slice(6,14)
            },
            { // Level 3
                columns: 5,
                rows: 2,
                images: images.slice(14,24)
            },
            { // Level 4
                columns: 4,
                rows: 3,
                images: images.slice(15,27)
            }
        ]

function get() {
    return memory_cards
}