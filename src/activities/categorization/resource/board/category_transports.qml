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
    property string imagesPrefix: "qrc:/gcompris/data/words/transport/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Transport"),
            "image": imagesPrefix + "balloon.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "tucker.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["transport/autorickshaw.jpg","transport/balloon.jpg","transport/bicycle2.jpg","transport/boat.jpg","transport/bulletTrain.jpg","transport/bullockcart.jpg"],
                    "bad": ["householdGoods/ac.jpg","householdGoods/heater.jpg","householdGoods/quilt.jpg","food/kathiRoll.jpg","food/icecream.jpg","vegetables/carrots.jpg"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "train1.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["transport/bus.jpg","transport/camel.jpg","transport/car1.jpg","transport/exchanger.jpg","transport/ferry.jpg","transport/flight.jpg"],
                    "bad": ["householdGoods/coffeeMaker.jpg","householdGoods/curtains.jpg","nature/nature6.jpg","insects/insect10.jpg","householdGoods/lamp.jpg","others/fork.jpg"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "ship.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["transport/helicopter.jpg","transport/metro.jpg","transport/plane.jpg","transport/train5.jpg","transport/rickshaw.jpg","transport/rocket.jpg"],
                    "bad": ["nature/nature5.jpg","nature/nature8.jpg","food/biryani.jpg","food/skimmedMilk.jpg","fruits/grapes.jpg","fruits/apple.jpg"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "plane.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["transport/bus2.jpg","transport/car2.jpg","transport/ferry1.jpg","transport/ship.jpg","transport/rotorShip.jpg","transport/cycle.jpg"],
                    "bad": ["vegetables/pumpkin.jpg","householdGoods/oven.jpg","householdGoods/radio1.jpg","food/riceBeans.jpg","fruits/guava.jpg","plants/plant2.jpg","nature/nature14.jpg"]
                },
                {
                    "tags": ["transport"],
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "train2.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["transport/tram.jpg","transport/tucker.jpg","transport/bus1.jpg","transport/car1.jpg", "transport/ferry1.jpg"],
                    "bad": ["insects/insect15.jpg","birds/bird18.jpg","animals/giraffe.jpg","others/street.jpg"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "roadTrain.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["transport/cycle.jpg","transport/helicopter1.jpg","transport/plane1.jpg","transport/train2.jpg","animals/horse.jpg"],
                    "bad": ["food/hamburger.jpg","householdGoods/electricBlanket.jpg","householdGoods/bed.jpg","vegetables/spinach.jpg"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "car2.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["transport/plane2.jpg","transport/roadTrain.jpg","transport/rocket1.jpg","transport/train4.jpg"],
                    "bad": ["food/pizza.jpg","householdGoods/toaster.jpg","animals/koala.jpg","birds/bird21.jpg","insects/insect12.jpg"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "ferry.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["transport/car3.jpg","transport/train3.jpg","transport/ship1.jpg"],
                    "bad": ["householdGoods/almirah.jpg","plants/tree3.jpg","nature/nature17.jpg"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "rocket1.jpg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["transport/car5.jpg","transport/tanker.jpg"],
                    "bad": ["food/milk.jpg","householdGoods/vacuumCleaner.jpg","insects/insect9.jpg","birds/bird23.jpg"]
                },
                {
                    "instructions": qsTr("Place the MEANS OF TRANSPORTATION to the right and other objects to the left"),
                    "image":imagesPrefix + "cycle.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["transport/plane3.jpg","transport/rickshaw2.jpg","transport/train1.jpg"],
                    "bad": ["insects/insect18.jpg","vegetables/cauliflower.jpg","nature/nature24.jpg"]
                }
            ]
        }
    ]
}
