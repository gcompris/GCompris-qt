
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
    property bool isEmbedded: true
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/odd_even/"
    property variant levels: [
        {
            "type": "lesson",
            "name": qsTr("odd even numbers"),
            "image": imagesPrefix + "numbers.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "even2.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/odd_even/",
                    "good": ["even2.svg","even4.svg","even6.svg","even8.svg"],
                    "bad": ["odd1.svg","odd3.svg","odd5.svg","odd7.svg"]
                },
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "even2.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/odd_even/",
                    "good": ["even72.svg","even22.svg","even96.svg","even2.svg","even4.svg","even10.svg"],
                    "bad": ["odd47.svg","odd15.svg","odd35.svg","odd3.svg","odd9.svg","odd7.svg"]
                },
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "even2.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/odd_even/",
                    "good": ["even786.svg","even276.svg","even192.svg","even92.svg","even88.svg"],
                    "bad": ["odd111.svg","odd145.svg","odd39.svg","odd353.svg","odd23.svg"]
                }
            ]
        }
    ]
}
