/* GCompris
 *
 * SPDX-FileCopyrightText: 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
    property bool isEmbedded: true
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/alphabets/"
    property var levels: [
        {
            "name": qsTr("Alphabets"),
            "image": imagesPrefix + "alphabets.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the LETTERS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/alphabets/upperA.svg","categorization/resource/images/alphabets/lowerP.svg","categorization/resource/images/alphabets/upperR.svg", "categorization/resource/images/alphabets/lowerT.svg","categorization/resource/images/alphabets/lowerD.svg", "categorization/resource/images/alphabets/lowerE.svg"],
                    "bad": ["categorization/resource/images/numbers/01.svg","categorization/resource/images/numbers/06.svg","categorization/resource/images/numbers/12.svg","lang/resource/words_sample/coconut.png", "lang/resource/words_sample/dolphin.png","lang/resource/words_sample/kiwi.png"]
                },
                {
                    "instructions": qsTr("Place the LETTERS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/alphabets/lowerB.svg","categorization/resource/images/alphabets/upperV.svg","categorization/resource/images/alphabets/lowerE.svg","categorization/resource/images/alphabets/lowerN.svg","categorization/resource/images/alphabets/upperM.svg", "categorization/resource/images/alphabets/upperO.svg"],
                    "bad": ["categorization/resource/images/numbers/06.svg","categorization/resource/images/numbers/16.svg","lang/resource/words_sample/mouse.png","lang/resource/words_sample/orange.png","lang/resource/words_sample/raspberry.png","lang/resource/words_sample/tongue.png"]
                },
                {
                    "instructions": qsTr("Place the LETTERS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": [ "categorization/resource/images/alphabets/upperF.svg","categorization/resource/images/alphabets/lowerK.svg","categorization/resource/images/alphabets/lowerR.svg","categorization/resource/images/alphabets/upperQ.svg","categorization/resource/images/alphabets/lowerB.svg"],
                    bad: ["categorization/resource/images/numbers/07.svg","categorization/resource/images/numbers/00.svg","lang/resource/words_sample/turtle.png","lang/resource/words_sample/melon.png"]
                },
                {
                    "instructions": qsTr("Place the LETTERS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/alphabets/lowerH.svg","categorization/resource/images/alphabets/upperL.svg","categorization/resource/images/alphabets/upperN.svg","categorization/resource/images/alphabets/upperS.svg"],
                    "bad": ["lang/resource/words_sample/pear.png","lang/resource/words_sample/butterfly.png","categorization/resource/images/numbers/08.svg", "categorization/resource/images/numbers/11.svg","categorization/resource/images/numbers/01.svg"]
                },
                {
                    "instructions": qsTr("Place the LETTERS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/alphabets/lowerG.svg","categorization/resource/images/alphabets/lowerT.svg","categorization/resource/images/alphabets/lowerK.svg"],
                    "bad": ["categorization/resource/images/numbers/08.svg","categorization/resource/images/numbers/10.svg", "lang/resource/words_sample/dog.png"]
                },
                {
                    "instructions": qsTr("Place the LETTERS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/alphabets/upperD.svg","categorization/resource/images/alphabets/upperJ.svg"],
                    "bad": ["lang/resource/words_sample/green.png","lang/resource/words_sample/plum.png","categorization/resource/images/numbers/09.svg","lang/resource/words_sample/cat.png"]
                }
            ]
        }
    ]
}
