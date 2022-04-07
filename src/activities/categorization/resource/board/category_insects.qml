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

QtObject{
    property bool isEmbedded: false
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/insects/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Insects"),
            "image": imagesPrefix + "insect6.webp",
            "content": [
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect15.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["insects/insect1.webp","insects/insect2.webp","insects/insect3.webp","insects/insect4.webp","insects/insect5.webp","insects/insect6.webp"],
                    "bad": ["nature/nature4.webp","plants/tree2.webp","birds/bird8.webp","birds/bird5.webp","animals/giraffe.webp","animals/horse.webp"]
                },
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect25.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["insects/insect7.webp","insects/insect8.webp","insects/insect9.webp","insects/insect10.webp","insects/insect11.webp","insects/insect12.webp"],
                    "bad": ["food/eggs.webp","birds/bird2.webp","birds/bird3.webp","animals/lion.webp","animals/mouse.webp","animals/elephant.webp"]
                },
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect6.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["insects/insect13.webp","insects/insect14.webp","insects/insect15.webp","insects/insect16.webp","insects/insect17.webp"],
                    "bad": ["transport/helicopter.webp","householdGoods/oven.webp","birds/bird8.webp","birds/bird9.webp"]
                },
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect8.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["insects/insect18.webp","insects/insect19.webp","insects/insect20.webp","insects/insect21.webp","insects/insect22.webp"],
                    "bad": ["householdGoods/bed.webp","others/mobile.webp","birds/bird17.webp","animals/hare.webp"]
                },
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect19.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["insects/insect23.webp","insects/insect24.webp","insects/insect25.webp"],
                    "bad": ["plants/tree3.webp","birds/bird29.webp","animals/pig.webp"]
                },
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect12.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["insects/insect26.webp","insects/insect27.webp","insects/insect12.webp"],
                    "bad": ["householdGoods/iron.webp","birds/bird33.webp","animals/sheep.webp"]
                }
            ]
        }
    ]
}
