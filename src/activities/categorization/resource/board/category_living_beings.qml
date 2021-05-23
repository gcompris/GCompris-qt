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
    property string imagesPrefix: "qrc:/gcompris/data/words/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Living"),
            "image": imagesPrefix + "plants" + "/" + "plant1.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "plants" + "/" + "plant5.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["plants/plant2.jpg","plants/tree1.jpg","animals/donkey.jpg","animals/horse.jpg","birds/bird12.jpg","birds/bird13.jpg"],
                    "bad": ["transport/balloon.jpg","transport/bus.jpg","others/house.jpg","others/clock.jpg","householdGoods/ac.jpg","others/pencil.jpg"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "insects" + "/" + "insect4.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["insects/insect16.jpg","birds/bird17.jpg","insects/insect22.jpg","insects/insect19.jpg","insects/insect23.jpg","birds/bird21.jpg"],
                    "bad": ["transport/plane.jpg","transport/metro.jpg","householdGoods/refrigerator.jpg","householdGoods/chest1.jpg","food/grilledSandwich.jpg","others/mobile.jpg"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "birds" + "/" + "bird5.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good":["plants/plant1.jpg","plants/tree2.jpg","insects/insect3.jpg","insects/insect4.jpg","birds/bird1.jpg"],
                    "bad": ["transport/rickshaw.jpg","householdGoods/bed.jpg","others/pepsi.jpg","householdGoods/canOpener.jpg"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "plants" +"/" + "tree2.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["plants/plant3.jpg","plants/tree3.jpg","animals/snowcat.jpg","animals/pig.jpg"],
                    "bad": ["transport/plane.jpg","food/frenchFries.jpg","food/water.jpg","others/street.jpg","householdGoods/bed.jpg"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "animals" + "/" + "opossum.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["plants/tree4.jpg","animals/giraffe.jpg","insects/insect7.jpg","birds/bird12.jpg","birds/bird15.jpg"],
                    "bad": ["householdGoods/heater.jpg","householdGoods/couch.jpg","transport/ship.jpg","others/fork.jpg","food/eggs.jpg"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "animals" + "/" +  "hare.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["plants/plant4.jpg","animals/lion.jpg","birds/bird24.jpg"],
                    "bad": ["transport/helicopter.jpg","householdGoods/iron.jpg","others/mobile.jpg"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "insects" + "/" +  "insect5.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["plants/plant5.jpg","plants/plant6.jpg","animals/sheep.jpg"],
                    "bad": ["transport/rocket.jpg","others/pepsi.jpg","food/hotdog.jpg"]
                }
            ]
        }
    ]
}
