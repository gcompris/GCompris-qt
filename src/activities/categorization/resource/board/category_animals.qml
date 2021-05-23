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
    property string imagesPrefix: "qrc:/gcompris/data/words/animals/"
    property var levels:[
        {
            "type": "lesson",
            "name": qsTr("Animals"),
            "image": imagesPrefix + "animalsherd.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "tiger.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/baboon.jpg","animals/bosmutus.jpg","animals/camel.jpg","animals/cow.jpg","animals/dog.jpg","birds/bird10.jpg"],
                    "bad": ["nature/nature5.jpg","householdGoods/chair.jpg","food/biryani.jpg","others/electricfan.jpg","others/clock.jpg","nature/nature10.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "tiger.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/lion.jpg","birds/bird7.jpg","birds/bird8.jpg","animals/mouse1.jpg","animals/opossum.jpg","animals/pig.jpg"],
                    "bad": ["nature/nature3.jpg","food/milk.jpg","food/butter.jpg","fruits/apple.jpg","transport/rickshaw.jpg","transport/bus.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "opossum.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/snowcat.jpg","animals/spidermonkey.jpg","animals/squirrel.jpg","animals/squirrel1.jpg","animals/tasmaniandevil.jpg","birds/bird22.jpg"],
                    "bad": ["transport/helicopter.jpg","nature/nature2.jpg","others/house.jpg","transport/plane2.jpg","plants/plant4.jpg","nature/nature5.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "tortoise.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/redeyedfrog.jpg","animals/scorpian.jpg","animals/sealion.jpg","animals/sheep.jpg","animals/snake.jpg"],
                    "bad": ["fruits/grapes.jpg","others/broom1.jpg","transport/car1.jpg","food/icecream.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "koala.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/donkey.jpg","animals/elephant.jpg","insects/insect20.jpg","animals/tiger.jpg","animals/zebra.jpg"],
                    "bad": ["vegetables/pumpkin.jpg","vegetables/carrots.jpg","transport/cycle.jpg","plants/tree3.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "hedgehog.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/giraffe.jpg","birds/bird25.jpg","animals/hedgehog.jpg","insects/insect7.jpg"],
                    "bad": ["vegetables/potato.jpg","transport/balloon.jpg","food/cheese.jpg","others/mobile.jpg","transport/bus1.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "lion.jpg",
                    "maxNumberOfGood": 3 ,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/koala.jpg","animals/kodiak-bear.jpg","birds/bird27.jpg"],
                    "bad": ["nature/nature6.jpg","transport/ferry.jpg","food/eggs.jpg","food/hamburger.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "pig.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/tiger.jpg","animals/tortoise.jpg","animals/tortoise1.jpg"],
                    "bad": ["transport/car1.jpg","fruits/papaya.jpg","food/hotdog.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "snowcat.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/porcupine.jpg","animals/cow.jpg","birds/bird29.jpg"],
                    "bad": ["nature/nature8.jpg","food/macroni.jpg","others/house.jpg"]
                }
            ]
        }
    ]
}
