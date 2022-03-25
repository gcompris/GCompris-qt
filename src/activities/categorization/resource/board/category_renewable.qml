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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/renewable/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Renewable"),
            "image": imagesPrefix + "windmill12.webp",
            "content": [
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "windmill12.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/windmill.webp","renewable/windmill1.webp","renewable/windmill2.webp","renewable/windmill3.webp","renewable/windmill4.webp","renewable/windmill5.webp"],
                    "bad": ["fishes/fish20.webp","others/volleyball.webp","monuments/burj.webp","tools/plier1.webp","others/pillow.webp","fishes/fish10.webp"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "solar8.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/solar1.webp","renewable/solar2.webp","renewable/solar3.webp","renewable/solar4.webp","renewable/solar5.webp","renewable/solar6.webp"],
                    "bad": ["others/plate.webp","fishes/fish25.webp","tools/scissors1.webp","monuments/christTheRedeemer.webp","others/bucket.webp","monuments/jucheTower.webp"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "dam2.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/dam1.webp","renewable/dam2.webp","renewable/dam3.webp","renewable/dam4.webp"],
                    "bad": ["fishes/fish14.webp","tools/wrench.webp","tools/plier3.webp","others/baseball.webp","monuments/arcDeTriomphe.webp"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "dam5.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/windmill2.webp","renewable/windmill13.webp","renewable/solar7.webp","renewable/solar3.webp"],
                    "bad": ["monuments/greatPyramid.webp","others/buffetset.webp","others/weighingMachine.webp","tools/spray.webp","monuments/arcDeTriomphe.webp"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "geothermal.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/dam5.webp","renewable/geothermal.webp","renewable/windmill6.webp","renewable/windmill7.webp","renewable/windmill8.webp"],
                    "bad": ["fishes/fish6.webp","fishes/fish3.webp","others/pan.webp","others/spoons.webp"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "dam3.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/windmill9.webp","renewable/windmill12.webp","renewable/solar7.webp"],
                    "bad": ["others/blackslate.webp","monuments/IndiaGate.webp","tools/multimeter2.webp"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "solar2.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/solar8.webp","renewable/dam5.webp","renewable/windmill11.webp"],
                    "bad": ["others/plate.webp","others/chair.webp","monuments/eiffelTower.webp"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "solar4.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/windmill14.webp","renewable/windmill15.webp","renewable/dam5.webp"],
                    "bad": ["others/plate.webp","fishes/fish18.webp","monuments/leMusee.webp"]
                }
            ]
        }
    ]
}
