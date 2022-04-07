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
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/transport/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Transport"),
            "image": imagesPrefix + "balloon.webp",
            "content": [
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "tucker.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["transport/autorickshaw.webp","transport/balloon.webp","transport/bicycle2.webp","transport/boat.webp","transport/bulletTrain.webp","transport/bullockcart.webp"],
                    "bad": ["householdGoods/ac.webp","householdGoods/heater.webp","householdGoods/quilt.webp","food/kathiRoll.webp","food/icecream.webp","vegetables/carrots.webp"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "train1.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["transport/bus.webp","transport/camel.webp","transport/car1.webp","transport/exchanger.webp","transport/ferry.webp","transport/flight.webp"],
                    "bad": ["householdGoods/coffeeMaker.webp","householdGoods/curtains.webp","nature/nature6.webp","insects/insect10.webp","householdGoods/lamp.webp","others/fork.webp"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "ship.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["transport/helicopter.webp","transport/metro.webp","transport/plane.webp","transport/train5.webp","transport/rickshaw.webp","transport/rocket.webp"],
                    "bad": ["nature/nature5.webp","nature/nature8.webp","food/biryani.webp","food/skimmedMilk.webp","fruits/grapes.webp","fruits/apple.webp"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "plane.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["transport/bus2.webp","transport/car2.webp","transport/ferry1.webp","transport/ship.webp","transport/rotorShip.webp","transport/cycle.webp"],
                    "bad": ["vegetables/pumpkin.webp","householdGoods/oven.webp","householdGoods/radio1.webp","food/riceBeans.webp","fruits/guava.webp","plants/plant2.webp","nature/nature14.webp"]
                },
                {
                    "tags": ["transport"],
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "train2.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["transport/tram.webp","transport/tucker.webp","transport/bus1.webp","transport/car1.webp", "transport/ferry1.webp"],
                    "bad": ["insects/insect15.webp","birds/bird18.webp","animals/giraffe.webp","others/street.webp"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "roadTrain.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["transport/cycle.webp","transport/helicopter1.webp","transport/plane1.webp","transport/train2.webp","animals/horse.webp"],
                    "bad": ["food/hamburger.webp","householdGoods/electricBlanket.webp","householdGoods/bed.webp","vegetables/spinach.webp"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "car2.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["transport/plane2.webp","transport/roadTrain.webp","transport/rocket1.webp","transport/train4.webp"],
                    "bad": ["food/pizza.webp","householdGoods/toaster.webp","animals/koala.webp","birds/bird21.webp","insects/insect12.webp"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "ferry.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["transport/car3.webp","transport/train3.webp","transport/ship1.webp"],
                    "bad": ["householdGoods/almirah.webp","plants/tree3.webp","nature/nature17.webp"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "rocket1.webp",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["transport/car5.webp","transport/tanker.webp"],
                    "bad": ["food/milk.webp","householdGoods/vacuumCleaner.webp","insects/insect9.webp","birds/bird23.webp"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "cycle.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["transport/plane3.webp","transport/rickshaw2.webp","transport/train1.webp"],
                    "bad": ["insects/insect18.webp","vegetables/cauliflower.webp","nature/nature24.webp"]
                }
            ]
        }
    ]
}
