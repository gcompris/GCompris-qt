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
    property string imagesPrefix: "qrc:/gcompris/data/words/food/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Food"),
            "image": imagesPrefix + "pizza.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "sweetBread.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["food/applepie.jpg","food/bananaNutBread.jpg","food/biryani.jpg","food/cereal.jpg","food/cheese.jpg","food/eggs.jpg"],
                    "bad": ["nature/nature28.jpg","plants/plant2.jpg","nature/nature27.jpg","birds/bird1.jpg","nature/nature17.jpg","insects/insect10.jpg"]
                },
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "pizza1.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["food/fish.jpg","food/frenchFries.jpg","food/friedEggs.jpg","food/grilledSandwich.jpg","food/hamburger.jpg","food/hotdog.jpg"],
                    "bad": ["nature/nature26.jpg","birds/bird25.jpg","transport/cycle.jpg","insects/insect1.jpg","nature/nature24.jpg","others/fork.jpg"]
                },
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "hotdog.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["food/icecream.jpg","food/cereal1.jpg","food/cheese1.jpg","food/kathiRoll.jpg","food/macroni.jpg"],
                    "bad": ["animals/camel.jpg","animals/hare.jpg","insects/insect4.jpg","birds/bird5.jpg"]
                },
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "frenchFries.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["food/MaozVegetariano.jpg","food/milk.jpg","food/bananaNutBread.jpg","food/pitaBread.jpg","food/pizza.jpg"],
                    "bad": ["birds/bird6.jpg","others/street.jpg","householdGoods/iron2.jpg","insects/insect8.jpg"]
                },
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "hamburger.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["food/icecream1.jpg","food/riceBeans.jpg","food/scrambledEggsVeggies.jpg"],
                    "bad": ["nature/nature21.jpg","plants/tree2.jpg","householdGoods/bed.jpg"]
                },
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "milk.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["food/skimmedMilk.jpg","food/steak.jpg","food/sweetBread.jpg"],
                    "bad": ["birds/bird4.jpg","animals/koala.jpg","transport/ferry.jpg"]
                }
            ]
        }
    ]
}
