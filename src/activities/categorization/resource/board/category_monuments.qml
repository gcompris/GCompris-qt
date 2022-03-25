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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/monuments/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Monuments"),
            "image": imagesPrefix + "colosseum.webp",
            "content": [
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "victoriaMemorial.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/bayterek.webp","monuments/burj.webp","monuments/cathedral.webp","monuments/colosseum.webp","monuments/brandenburgGate.webp","monuments/arcDeTriomphe.webp"],
                    "bad": ["renewable/windmill5.webp","renewable/dam2.webp","tools/tweezer.webp","others/bulb.webp","others/pan.webp","others/knife.webp"]
                },
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "parthenon.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/christTheRedeemer.webp","monuments/eiffelTower.webp","monuments/empireState.webp" ,"monuments/greatPyramid.webp","monuments/greatWall.webp","monuments/IndiaGate.webp"],
                    "bad": ["fishes/fish3.webp","fishes/fish5.webp","renewable/dam2.webp","others/spoons.webp","others/igloo.webp","tools/measuringTape5.webp"]
                },
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "monument2.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/jucheTower.webp","monuments/kutubMinar.webp","monuments/leaningTowerOfPisa.webp" ,"monuments/operaHouse.webp","monuments/monument1.webp"],
                    "bad": ["fishes/fish7.webp","fishes/fish16.webp","tools/hammer4.webp","tools/spray.webp"]
                },
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "greatPyramid.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/mountRushmore.webp","monuments/operaHouse.webp","monuments/parthenon.webp","monuments/statueOfLiberty.webp","monuments/tajMahal.webp"],
                    "bad": ["renewable/solar2.webp","renewable/geothermal.webp","tools/scissors2.webp","tools/plier4.webp"]
                },
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "brandenburgGate.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/usCapitol.webp","monuments/victoriaMemorial.webp","monuments/zimniPalace.webp"],
                    "bad": ["tools/plier1.webp","others/pillow.webp","renewable/solar5.webp"]
                },
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "IndiaGate.webp",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/monument2.webp","monuments/monument3.webp"],
                    "bad": ["others/volleyball.webp","tools/sickle.webp","others/chair.webp","renewable/dam4.webp"]
                }
            ]
        }
    ]
}
