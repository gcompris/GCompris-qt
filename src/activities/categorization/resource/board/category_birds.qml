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

QtObject{
    property bool isEmbedded: false
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/data/words/birds/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Birds"),
            "image": imagesPrefix + "bird.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.png",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["birds/parrot.jpg","birds/bird34.jpg","birds/bird23.jpg","birds/peacock.jpg","birds/rooster.jpg","birds/bird1.jpg"],
                    "bad": ["animals/baboon.jpg","animals/bosmutus.jpg","animals/camel.jpg","animals/cow.jpg","others/sharpnerandpencil.jpg","transport/cycle.jpg"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.png",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["birds/bird2.jpg","birds/bird3.jpg","birds/bird4.jpg","birds/bird5.jpg","birds/bird6.jpg","birds/bird7.jpg"],
                    "bad": ["animals/dog.jpg","animals/dolphin.jpg","animals/donkey.jpg","animals/elephant.jpg","others/mobile.jpg","transport/helicopter1.jpg"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.png",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 7,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["birds/bird8.jpg","birds/bird9.jpg","birds/bird10.jpg","birds/bird11.jpg","birds/bird12.jpg"],
                    "bad": ["plants/tree1.jpg","transport/train2.jpg","animals/giraffe.jpg","vegetables/spinaches.jpg","fruits/kiwi.jpg","insects/insect12.jpg","food/cereal.jpg"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.png",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["birds/bird13.jpg","birds/bird14.jpg","birds/bird15.jpg","birds/bird16.jpg","birds/bird17.jpg"],
                    "bad": ["animals/hare.jpg","animals/hedgehog.jpg","food/cheese.jpg","food/pizza.jpg"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.png",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["birds/bird18.jpg","birds/bird19.jpg","birds/bird20.jpg","birds/bird21.jpg","birds/bird22.jpg"],
                    "bad": ["animals/horse.jpg","animals/koala.jpg","food/milk.jpg","insects/insect5.jpg"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.png",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["birds/bird23.jpg","birds/bird24.jpg","birds/bird25.jpg","birds/bird26.jpg"],
                    "bad": ["animals/marsupialis.jpg","animals/mouse.jpg","others/pepsi.jpg","insects/insect16.jpg","food/milk.jpg"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.png",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["birds/bird27.jpg","birds/bird28.jpg","birds/bird29.jpg"],
                    "bad": ["animals/kodiak-bear.jpg","animals/krotiki.jpg","others/clock.jpg"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.png",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["birds/bird30.jpg","birds/bird31.jpg","birds/bird32.jpg"],
                    "bad": ["animals/mouse1.jpg","animals/pig.jpg","nature/nature5.jpg"]
                },
                {
                    "instructions": qsTr("Place the BIRDS to the right and other objects to the left"),
                    "image": imagesPrefix + "bird.png",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["birds/bird33.jpg","birds/bird34.jpg"],
                    "bad": ["animals/lion.jpg","plants/tree3.jpg","transport/balloon.jpg","householdGoods/refrigerator.jpg"]
                }
            ]
        }
    ]
}
