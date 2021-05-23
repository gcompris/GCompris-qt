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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/monuments/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Monuments"),
            "image": imagesPrefix + "colosseum.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "victoriaMemorial.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/bayterek.jpg","monuments/burj.jpg","monuments/cathedral.jpg","monuments/colosseum.jpg","monuments/beandenburgGate.jpg","monuments/arcDeTriomphe.jpg"],
                    "bad": ["renewable/windmill5.jpg","renewable/dam2.jpg","tools/tweezer.jpg","others/bulb.jpg","others/pan.jpg","others/knife.jpg"]
                },
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "parthenon.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/christTheRedeemer.jpg","monuments/eiffelTower.jpg","monuments/empireState.jpg" ,"monuments/greatPyramid.jpg","monuments/greatWall.jpg","monuments/IndiaGate.jpg"],
                    "bad": ["fishes/fish3.jpg","fishes/fish5.jpg","renewable/dam2.jpg","others/spoons.jpg","others/igloo.jpg","tools/measuringTape.jpg"]
                },
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "monument2.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/jucheTower.jpg","monuments/kutubMinar.jpg","monuments/leaningTowerOfPisa.jpg" ,"monuments/leninMuseum.jpg","monuments/monument1.jpg"],
                    "bad": ["fishes/fish7.jpg","fishes/fish16.jpg","tools/hammer4.jpg","tools/sprinkler.jpg"]
                },
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "greatPyramid.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/mountRushmore.jpg","monuments/operaHouse.jpg","monuments/parthenon.jpg","monuments/statueOfLiberty.jpg","monuments/tajMahal.jpg"],
                    "bad": ["renewable/solar2.jpg","renewable/geothermal.jpg","tools/scissor.jpg","tools/stripper1.png"]
                },
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "beandenburgGate.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/usCapitol.jpg","monuments/victoriaMemorial.jpg","monuments/zimniPalace.jpg"],
                    "bad": ["tools/plier2.jpg","others/pillow.jpg","renewable/solar5.jpg"]
                },
                {
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "IndiaGate.jpg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["monuments/monument2.jpg","monuments/monument3.jpg"],
                    "bad": ["others/volleyball.jpg","tools/sickle.jpg","others/chair.jpg","renewable/dam4.jpg"]
                }
            ]
        }
    ]
}
