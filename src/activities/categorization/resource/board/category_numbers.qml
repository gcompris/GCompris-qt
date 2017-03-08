/* GCompris
 *
 * Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
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
    property string imagesPrefix: "qrc:/gcompris/src/activities/lang/resource/words_sample/"
    property variant levels: [
        {
            "type": "lesson",
            "name": qsTr("Numbers"),
            "image": "qrc:/gcompris/src/activities/categorization/resource/images/alphabets/numbers.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the NUMBERS to the right and other objects to the left"),
                    "image": imagesPrefix + "zero.png",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["lang/resource/words_sample/twelve.png","lang/resource/words_sample/two.png","lang/resource/words_sample/zero.png","lang/resource/words_sample/eight.png","lang/resource/words_sample/ten.png","lang/resource/words_sample/four.png"],
                    "bad": ["categorization/resource/images/alphabets/upperA.svg","categorization/resource/images/alphabets/upperM.svg","categorization/resource/images/alphabets/lowerB.svg","categorization/resource/images/alphabets/upperS.svg","lang/resource/words_sample/fish.png","lang/resource/words_sample/color.png"]
                },
                {
                    "instructions": qsTr("Place the NUMBERS to the right and other objects to the left"),
                    "image": imagesPrefix + "zero.png",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["lang/resource/words_sample/five.png","lang/resource/words_sample/eleven.png","lang/resource/words_sample/nine.png","lang/resource/words_sample/three.png","lang/resource/words_sample/seven.png"],
                    "bad": ["categorization/resource/images/alphabets/upperZ.svg","categorization/resource/images/alphabets/lowerH.svg","lang/resource/words_sample/mosquito.png","lang/resource/words_sample/fruit.png"]
                },
                {
                    "instructions": qsTr("Place the NUMBERS to the right and other objects to the left"),
                    "image": imagesPrefix + "zero.png",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["lang/resource/words_sample/one.png","lang/resource/words_sample/six.png","lang/resource/words_sample/sixteen.png"],
                    "bad": ["categorization/resource/images/alphabets/upperR.svg","categorization/resource/images/alphabets/lowerQ.svg", "lang/resource/words_sample/strawberry.png"]
                }
            ]
        }
    ]
}
