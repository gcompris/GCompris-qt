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
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/householdGoods/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Household goods"),
            "image": imagesPrefix + "utensils.webp",
            "content": [
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "oven.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/bedsheet.webp","householdGoods/blender.webp","householdGoods/breadtoaster.webp", "householdGoods/canOpener.webp","householdGoods/bathtub.webp","householdGoods/bed.webp"],
                    "bad": ["food/eggs.webp","food/milk.webp","food/riceBeans.webp","transport/metro.webp","transport/plane.webp","fruits/apple.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "dressingtable.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": [ "householdGoods/almirah.webp","householdGoods/coffeeMaker.webp","householdGoods/laptop.webp","householdGoods/bookshelf.webp","householdGoods/chair.webp","householdGoods/chest.webp"],
                    "bad": ["transport/ship1.webp","nature/nature5.webp","fruits/papaya.webp","food/hamburger.webp","transport/ship.webp","others/street.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "radio.webp",
                    "maxNumberOfGood": 7,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/curtains.webp","householdGoods/heater.webp","householdGoods/stool.webp","householdGoods/couch.webp","householdGoods/crib.webp","householdGoods/oven.webp","householdGoods/almirah.webp"],
                    "bad": ["others/house.webp","transport/rocket1.webp","transport/train4.webp","insects/insect16.webp","birds/bird14.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "sewingMachine.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/quilt.webp","householdGoods/iron.webp","householdGoods/bed2.webp","householdGoods/couch2.webp","householdGoods/diningtable.webp","householdGoods/coffeeMaker1.webp"],
                    "bad": ["transport/ferry1.webp","vegetables/mushroom.webp","insects/insect22.webp","birds/bird5.webp","food/friedEggs.webp","food/MaozVegetariano.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "bed.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/almirah1.webp","householdGoods/radio.webp","householdGoods/chair2.webp","householdGoods/stool2.webp","householdGoods/electricBlanket.webp","householdGoods/refrigerator1.webp"],
                    "bad": ["birds/bird2.webp","birds/bird5.webp","food/macroni.webp","transport/exchanger.webp","vegetables/potato.webp","others/pepsi.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "heater.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/television.webp","householdGoods/toaster.webp","householdGoods/curtains1.webp","householdGoods/coffeeMaker2.webp","householdGoods/iron1.webp"],
                    "bad": ["nature/nature14.webp","food/pizza1.webp","fruits/mango.webp","vegetables/spinach.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "ac.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/heater1.webp","householdGoods/oven1.webp","householdGoods/radio1.webp","householdGoods/electricBlanket.webp","householdGoods/bathtub.webp"],
                    "bad": ["vegetables/zucchini.webp","others/street.webp","transport/helicopter.webp","plants/tree2.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "breadtoaster.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/ac.webp","householdGoods/iron2.webp","householdGoods/toaster.webp", "householdGoods/sewingMachine1.webp", "householdGoods/vacuumCleaner.webp"],
                    "bad": ["food/hotdog.webp","animals/cow.webp","birds/bird25.webp","insects/insect14.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "bathtub.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/bed1.webp","householdGoods/lamp.webp","householdGoods/chair3.webp",
                            "householdGoods/refrigerator2.webp","householdGoods/towels.webp"],
                    "bad": ["transport/bus.webp","animals/elephant.webp","insects/insect5.webp","others/street.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "stool.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/chest1.webp","householdGoods/diningtable1.webp","householdGoods/laptop.webp","householdGoods/sewingMachine.webp"],
                    "bad": ["animals/kodiak-bear.webp","animals/sealion.webp","transport/plane.webp","food/frenchFries.webp","others/house.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "almirah.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/couch2.webp","householdGoods/refrigerator.webp","householdGoods/ac1.webp"],
                    "bad": ["insects/insect18.webp","transport/car1.webp","animals/dog.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "coffeeMaker2.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/heater2.webp","householdGoods/dressingtable.webp","householdGoods/stool2.webp"],
                    "bad": ["animals/lion.webp","vegetables/aubergine.webp","nature/nature12.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "chest.webp",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/chair5.webp","householdGoods/lamp1.webp"],
                    "bad": ["vegetables/fid.webp","animals/koala.webp","transport/ferry.webp","others/broom1.webp"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "heater1.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["householdGoods/ac2.webp","householdGoods/vacuumCleaner.webp","householdGoods/sewingMachine2.webp"],
                    "bad": ["insects/insect15.webp","vegetables/potato.webp","nature/nature13.webp"]
                }
            ]
        }
    ]
}
