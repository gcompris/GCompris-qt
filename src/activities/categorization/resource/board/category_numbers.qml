/* GCompris
 *
 * SPDX-FileCopyrightText: 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
    property bool isEmbedded: true
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/numbers/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Numbers"),
            "image": "qrc:/gcompris/src/activities/categorization/resource/images/numbers/numbers.webp",
            "content": [
                {
                    "instructions": qsTr("Place the NUMBERS to the right and other objects to the left"),
                    "image": imagesPrefix + "00.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/numbers/12.svg","categorization/resource/images/numbers/02.svg","categorization/resource/images/numbers/00.svg","categorization/resource/images/numbers/08.svg","categorization/resource/images/numbers/10.svg","categorization/resource/images/numbers/04.svg"],
                    "bad": ["categorization/resource/images/alphabets/upperA.svg","categorization/resource/images/alphabets/upperM.svg","categorization/resource/images/alphabets/lowerB.svg","categorization/resource/images/alphabets/upperS.svg","lang/resource/words_sample/fish.webp","lang/resource/words_sample/color.webp"]
                },
                {
                    "instructions": qsTr("Place the NUMBERS to the right and other objects to the left"),
                    "image": imagesPrefix + "00.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/numbers/05.svg","categorization/resource/images/numbers/11.svg","categorization/resource/images/numbers/09.svg","categorization/resource/images/numbers/03.svg","categorization/resource/images/numbers/07.svg"],
                    "bad": ["categorization/resource/images/alphabets/upperZ.svg","categorization/resource/images/alphabets/lowerH.svg","lang/resource/words_sample/mosquito.webp","lang/resource/words_sample/fruit.webp"]
                },
                {
                    "instructions": qsTr("Place the NUMBERS to the right and other objects to the left"),
                    "image": imagesPrefix + "00.svg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/numbers/01.svg","categorization/resource/images/numbers/06.svg","categorization/resource/images/numbers/16.svg"],
                    "bad": ["categorization/resource/images/alphabets/upperR.svg","categorization/resource/images/alphabets/lowerQ.svg", "lang/resource/words_sample/strawberry.webp"]
                }
            ]
        }
    ]
}
