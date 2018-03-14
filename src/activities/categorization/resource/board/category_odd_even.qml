
/* GCompris
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
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
import QtQuick 2.0

QtObject {
    property bool isEmbedded: false
    property bool allowExpertMode: false
    property string imagesPrefix: "qrc:/gcompris/data/words/numbers/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("odd even numbers"),
            "image": imagesPrefix + "11.svg",
            "content": [
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "16.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/numbers/",
                    "good": ["02.svg","04.svg","06.svg","08.svg", "10.svg","12.svg"],
                    "bad": ["01.svg","03.svg","05.svg","07.svg","09.svg","11.svg"]
                },
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "02.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/numbers/",
                    "good": ["even72.svg","even22.svg","even96.svg","even92.svg","even88.svg","even192.svg"],
                    "bad": ["odd47.svg","15.svg","odd35.svg","odd23.svg","odd39.svg","odd111.svg"]
                },
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "02.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/numbers/",
                    "good": ["even786.svg","even276.svg","even192.svg","even92.svg"],
                    "bad": ["odd111.svg","odd145.svg","odd39.svg","odd353.svg","odd23.svg"]
                },
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "02.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/numbers/",
                    "good": ["even22.svg","even88.svg","even192.svg","even786.svg","even72.svg"],
                    "bad": ["odd47.svg","odd353.svg","odd35.svg","15.svg"]
                },
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "02.svg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/numbers//",
                    "good": ["16.svg","10.svg","12.svg"],
                    "bad": ["01.svg","07.svg","05.svg"]
                },
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "16.svg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/numbers/",
                    "good": ["02.svg","08.svg","04.svg"],
                    "bad": ["09.svg","03.svg","11.svg"]
                }
            ]
        }
    ]
}
