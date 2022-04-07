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
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/birds/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Birds"),
            "image": imagesPrefix + "bird.webp",
            "content": [
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["birds/parrot.webp","birds/bird34.webp","birds/bird23.webp","birds/peacock.webp","birds/rooster.webp","birds/bird1.webp"],
                    "bad": ["animals/baboon.webp","animals/bosmutus.webp","animals/camel.webp","animals/cow.webp","others/sharpnerandpencil.webp","transport/cycle.webp"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["birds/bird2.webp","birds/bird3.webp","birds/bird4.webp","birds/bird5.webp","birds/bird6.webp","birds/bird7.webp"],
                    "bad": ["animals/dog.webp","animals/dolphin.webp","animals/donkey.webp","animals/elephant.webp","others/mobile.webp","transport/helicopter1.webp"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 7,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["birds/bird8.webp","birds/bird9.webp","birds/bird10.webp","birds/bird11.webp","birds/bird12.webp"],
                    "bad": ["plants/tree1.webp","transport/train2.webp","animals/giraffe.webp","vegetables/spinaches.webp","fruits/kiwi.webp","insects/insect12.webp","food/cereal.webp"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["birds/bird13.webp","birds/bird14.webp","birds/bird15.webp","birds/bird16.webp","birds/bird17.webp"],
                    "bad": ["animals/hare.webp","animals/hedgehog.webp","food/cheese.webp","food/pizza.webp"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["birds/bird18.webp","birds/bird19.webp","birds/bird20.webp","birds/bird21.webp","birds/bird22.webp"],
                    "bad": ["animals/horse.webp","animals/koala.webp","food/milk.webp","insects/insect5.webp"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["birds/bird23.webp","birds/bird24.webp","birds/bird25.webp","birds/bird26.webp"],
                    "bad": ["animals/marsupialis.webp","animals/mouse.webp","others/pepsi.webp","insects/insect16.webp","food/milk.webp"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["birds/bird27.webp","birds/bird28.webp","birds/bird29.webp"],
                    "bad": ["animals/kodiak-bear.webp","animals/krotiki.webp","others/clock.webp"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["birds/bird30.webp","birds/bird31.webp","birds/bird32.webp"],
                    "bad": ["animals/mouse1.webp","animals/pig.webp","nature/nature5.webp"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.webp",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["birds/bird33.webp","birds/bird34.webp"],
                    "bad": ["animals/lion.webp","plants/tree3.webp","transport/balloon.webp","householdGoods/refrigerator.webp"]
                }
            ]
        }
    ]
}
