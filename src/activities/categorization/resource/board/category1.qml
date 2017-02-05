
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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/alphabets/"
    property variant levels: [
        {
            "name": qsTr("Alphabets"),
            "image": imagesPrefix + "alphabets.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/alphabets/upperA.svg","categorization/resource/images/alphabets/lowerP.svg","categorization/resource/images/alphabets/upperR.svg", "categorization/resource/images/alphabets/lowerT.svg","categorization/resource/images/alphabets/lowerD.svg", "categorization/resource/images/alphabets/lowerE.svg"],
                    "bad": ["lang/resource/words_sample/one.png","lang/resource/words_sample/six.png","lang/resource/words_sample/twelve.png","lang/resource/words_sample/coconut.png", "lang/resource/words_sample/dolphin.png","lang/resource/words_sample/kiwi.png"]
                },
                {
                    "instructions": qsTr("Place the ALPHABETS to the right and others objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/alphabets/lowerB.svg","categorization/resource/images/alphabets/upperV.svg","categorization/resource/images/alphabets/lowerE.svg","categorization/resource/images/alphabets/lowerN.svg","categorization/resource/images/alphabets/upperM.svg", "categorization/resource/images/alphabets/upperO.svg"],
                    "bad": ["lang/resource/words_sample/six.png","lang/resource/words_sample/sixteen.png","lang/resource/words_sample/mouse.png","lang/resource/words_sample/orange.png","lang/resource/words_sample/raspberry.png","lang/resource/words_sample/tongue.png"]
                },
                {
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": [ "categorization/resource/images/alphabets/upperF.svg","categorization/resource/images/alphabets/lowerK.svg","categorization/resource/images/alphabets/lowerR.svg","categorization/resource/images/alphabets/upperQ.svg","categorization/resource/images/alphabets/lowerB.svg"],
                    bad: ["lang/resource/words_sample/seven.png","lang/resource/words_sample/three.png","lang/resource/words_sample/turtle.png","lang/resource/words_sample/melon.png"]
                },
                {
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/alphabets/lowerH.svg","categorization/resource/images/alphabets/upperL.svg","categorization/resource/images/alphabets/upperN.svg","categorization/resource/images/alphabets/upperS.svg"],
                    "bad": ["lang/resource/words_sample/pear.png","lang/resource/words_sample/butterfly.png","lang/resource/words_sample/eight.png", "lang/resource/words_sample/eleven.png","lang/resource/words_sample/one.png"]
                },
                {
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/alphabets/lowerG.svg","categorization/resource/images/alphabets/lowerT.svg","categorization/resource/images/alphabets/lowerK.svg"],
                    "bad": ["lang/resource/words_sample/eight.png","lang/resource/words_sample/ten.png", "lang/resource/words_sample/dog.png"]
                },
                {
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/alphabets/upperD.svg","categorization/resource/images/alphabets/upperJ.svg"],
                    "bad": ["lang/resource/words_sample/green.png","lang/resource/words_sample/plum.png","lang/resource/words_sample/nine.png","lang/resource/words_sample/cat.png"]
                }
            ]
        }
    ]
}
