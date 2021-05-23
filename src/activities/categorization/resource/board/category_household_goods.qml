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
    property string imagesPrefix: "qrc:/gcompris/data/words/householdGoods/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Household goods"),
            "image": imagesPrefix + "utensils.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "oven.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/bedsheet.jpg","householdGoods/blender.png","householdGoods/breadtoaster.jpg", "householdGoods/canOpener.jpg","householdGoods/bathtub.jpg","householdGoods/bed.jpg"],
                    "bad": ["food/eggs.jpg","food/milk.jpg","food/riceBeans.jpg","transport/metro.jpg","transport/plane.jpg","fruits/apple.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "dressingtable.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": [ "householdGoods/almirah.jpg","householdGoods/coffeeMaker.jpg","householdGoods/laptop.jpg","householdGoods/bookshelf.jpg","householdGoods/chair.jpg","householdGoods/chest.jpg"],
                    "bad": ["transport/ship1.jpg","nature/nature5.jpg","fruits/papaya.jpg","food/hamburger.jpg","transport/ship.jpg","others/street.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "radio.jpg",
                    "maxNumberOfGood": 7,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/curtains.jpg","householdGoods/heater.jpg","householdGoods/stool.jpg","householdGoods/couch.jpg","householdGoods/crib.jpg","householdGoods/oven.jpg","householdGoods/almirah.jpg"],
                    "bad": ["others/house.jpg","transport/rocket1.jpg","transport/train4.jpg","insects/insect16.jpg","birds/bird14.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "sewingMachine.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/quilt.jpg","householdGoods/iron.jpg","householdGoods/bed2.jpg","householdGoods/couch2.jpg","householdGoods/diningtable.jpg","householdGoods/coffeeMaker1.jpg"],
                    "bad": ["transport/ferry1.jpg","vegetables/mushroom.jpg","insects/insect22.jpg","birds/bird5.jpg","food/friedEggs.jpg","food/MaozVegetariano.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "bed.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/almirah1.jpg","householdGoods/radio.jpg","householdGoods/chair2.jpg","householdGoods/stool2.jpg","householdGoods/electricBlanket.jpg","householdGoods/refrigerator1.jpg"],
                    "bad": ["birds/bird2.jpg","birds/bird5.jpg","food/macroni.jpg","transport/exchanger.jpg","vegetables/potato.jpg","others/pepsi.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "heater.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/television.jpg","householdGoods/toaster.jpg","householdGoods/curtains1.jpg","householdGoods/coffeeMaker2.jpg","householdGoods/iron1.jpg"],
                    "bad": ["nature/nature14.jpg","food/pizza1.jpg","fruits/mango.jpg","vegetables/spinach.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "ac.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/heater1.jpg","householdGoods/oven1.jpg","householdGoods/radio1.jpg","householdGoods/electricBlanket.jpg","householdGoods/bathtub.jpg"],
                    "bad": ["vegetables/zucchini.jpg","others/street.jpg","transport/helicopter.jpg","plants/tree2.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "breadtoaster.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/ac.jpg","householdGoods/iron2.jpg","householdGoods/toaster.jpg", "householdGoods/sewingMachine1.jpg", "householdGoods/vacuumCleaner.jpg"],
                    "bad": ["food/hotdog.jpg","animals/cow.jpg","birds/bird25.jpg","insects/insect14.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "bathtub.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/bed1.jpg","householdGoods/lamp.jpg","householdGoods/chair3.jpg",
                            "householdGoods/refrigerator2.jpg","householdGoods/towels.jpg"],
                    "bad": ["transport/bus.jpg","animals/elephant.jpg","insects/insect5.jpg","others/street.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "stool.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/chest1.jpg","householdGoods/diningtable1.jpg","householdGoods/laptop.jpg","householdGoods/sewingMachine.jpg"],
                    "bad": ["animals/kodiak-bear.jpg","animals/sealion.jpg","transport/plane.jpg","food/frenchFries.jpg","others/house.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "almirah.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/couch2.jpg","householdGoods/refrigerator.jpg","householdGoods/ac1.jpg"],
                    "bad": ["insects/insect18.jpg","transport/car1.jpg","animals/dog.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "coffeeMaker2.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/heater2.jpg","householdGoods/dressingtable.jpg","householdGoods/stool2.jpg"],
                    "bad": ["animals/lion.jpg","vegetables/aubergine.jpg","nature/nature12.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                     "image": imagesPrefix + "chest.jpg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/chair5.jpg","householdGoods/lamp1.JPG"],
                    "bad": ["vegetables/fid.jpg","animals/koala.jpg","transport/ferry.jpg","others/broom1.jpg"]
                },
                {
                    "instructions": qsTr("Place the HOUSEHOLD GOODS to the right and other objects to the left"),
                    "image":imagesPrefix + "heater1.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["householdGoods/ac2.JPG","householdGoods/vacuumCleaner.jpg","householdGoods/sewingMachine2.jpg"],
                    "bad": ["insects/insect15.jpg","vegetables/potato.jpg","nature/nature13.jpg"]
                }
            ]
        }
    ]
}
