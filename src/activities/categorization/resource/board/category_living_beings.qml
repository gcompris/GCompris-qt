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
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Living"),
            "image": imagesPrefix + "plants" + "/" + "plant1.webp",
            "content": [
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "plants" + "/" + "plant5.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["plants/plant2.webp","plants/tree1.webp","animals/donkey.webp","animals/horse.webp","birds/bird12.webp","birds/bird13.webp"],
                    "bad": ["transport/balloon.webp","transport/bus.webp","others/house.webp","others/clock.webp","householdGoods/ac.webp","others/pencil.webp"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "insects" + "/" + "insect4.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["insects/insect16.webp","birds/bird17.webp","insects/insect22.webp","insects/insect19.webp","insects/insect23.webp","birds/bird21.webp"],
                    "bad": ["transport/plane.webp","transport/metro.webp","householdGoods/refrigerator.webp","householdGoods/chest1.webp","food/grilledSandwich.webp","others/mobile.webp"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "birds" + "/" + "bird5.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good":["plants/plant1.webp","plants/tree2.webp","insects/insect3.webp","insects/insect4.webp","birds/bird1.webp"],
                    "bad": ["transport/rickshaw.webp","householdGoods/bed.webp","others/pepsi.webp","householdGoods/canOpener.webp"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "plants" +"/" + "tree2.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["plants/plant3.webp","plants/tree3.webp","animals/snowcat.webp","animals/pig.webp"],
                    "bad": ["transport/plane.webp","food/frenchFries.webp","food/water.webp","others/street.webp","householdGoods/bed.webp"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "animals" + "/" + "opossum.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["plants/tree4.webp","animals/giraffe.webp","insects/insect7.webp","birds/bird12.webp","birds/bird15.webp"],
                    "bad": ["householdGoods/heater.webp","householdGoods/couch.webp","transport/ship.webp","others/fork.webp","food/eggs.webp"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "animals" + "/" +  "hare.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["plants/plant4.webp","animals/lion.webp","birds/bird24.webp"],
                    "bad": ["transport/helicopter.webp","householdGoods/iron.webp","others/mobile.webp"]
                },
                {
                    "instructions": qsTr("Place the living beings to the right and other objects to the left"),
                    "image":imagesPrefix + "insects" + "/" +  "insect5.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["plants/plant5.webp","plants/plant6.webp","animals/sheep.webp"],
                    "bad": ["transport/rocket.webp","others/pepsi.webp","food/hotdog.webp"]
                }
            ]
        }
    ]
}
