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
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/animals/"
    property var levels:[
        {
            "type": "lesson",
            "name": qsTr("Animals"),
            "image": imagesPrefix + "animalsherd.webp",
            "content": [
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "tiger.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["animals/baboon.webp","animals/bosmutus.webp","animals/camel.webp","animals/cow.webp","animals/dog.webp","birds/bird10.webp"],
                    "bad": ["nature/nature5.webp","householdGoods/chair.webp","food/biryani.webp","others/electricfan.webp","others/clock.webp","nature/nature10.webp"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "tiger.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["animals/lion.webp","birds/bird7.webp","birds/bird8.webp","animals/mouse1.webp","animals/opossum.webp","animals/pig.webp"],
                    "bad": ["nature/nature3.webp","food/milk.webp","food/butter.webp","fruits/apple.webp","transport/rickshaw.webp","transport/bus.webp"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "opossum.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["animals/snowcat.webp","animals/spidermonkey.webp","animals/squirrel.webp","animals/squirrel1.webp","animals/tasmaniandevil.webp","birds/bird22.webp"],
                    "bad": ["transport/helicopter.webp","nature/nature2.webp","others/house.webp","transport/plane2.webp","plants/plant4.webp","nature/nature5.webp"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "tortoise.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["animals/redeyedfrog.webp","animals/scorpian.webp","animals/sealion.webp","animals/sheep.webp","animals/snake.webp"],
                    "bad": ["fruits/grapes.webp","others/broom1.webp","transport/car1.webp","food/icecream.webp"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "koala.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["animals/donkey.webp","animals/elephant.webp","insects/insect20.webp","animals/tiger.webp","animals/zebra.webp"],
                    "bad": ["vegetables/pumpkin.webp","vegetables/carrots.webp","transport/cycle.webp","plants/tree3.webp"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "hedgehog.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["animals/giraffe.webp","birds/bird25.webp","animals/hedgehog.webp","insects/insect7.webp"],
                    "bad": ["vegetables/potato.webp","transport/balloon.webp","food/cheese.webp","others/mobile.webp","transport/bus1.webp"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "lion.webp",
                    "maxNumberOfGood": 3 ,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["animals/koala.webp","animals/kodiak-bear.webp","birds/bird27.webp"],
                    "bad": ["nature/nature6.webp","transport/ferry.webp","food/eggs.webp","food/hamburger.webp"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "pig.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["animals/tiger.webp","animals/tortoise.webp","animals/tortoise1.webp"],
                    "bad": ["transport/car1.webp","fruits/papaya.webp","food/hotdog.webp"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "snowcat.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["animals/porcupine.webp","animals/cow.webp","birds/bird29.webp"],
                    "bad": ["nature/nature8.webp","food/macroni.webp","others/house.webp"]
                }
            ]
        }
    ]
}
