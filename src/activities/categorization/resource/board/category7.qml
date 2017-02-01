
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
                    "good": ["even2.png","even4.png","even6.png","even8.png"],
                    "bad": ["odd1.png","odd3.png","odd5.png","odd7.png"]
                },
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "even2.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/odd_even/",
                    "good": ["even72.png","even22.png","even96.png","even2.png","even4.png","even10.png"],
                    "bad": ["odd47.png","odd15.png","odd35.png","odd3.png","odd9.png","odd7.png"]
                },
                {
                    "instructions": qsTr("Place the EVEN Numbers to the right and ODD Numbers to the left"),
                    "image": imagesPrefix + "even2.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/odd_even/",
                    "good": ["even786.png","even276.png","even192.png","even92.png","even88.png"],
                    "bad": ["odd111.png","odd145.png","odd39.png","odd353.png","odd23.png"]
                }
            ]
        }
    ]
}
