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
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/food/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Food"),
            "image": imagesPrefix + "pizza.webp",
            "content": [
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "sweetBread.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["food/applepie.webp","food/bananaNutBread.webp","food/biryani.webp","food/cereal.webp","food/cheese.webp","food/eggs.webp"],
                    "bad": ["nature/nature28.webp","plants/plant2.webp","nature/nature27.webp","birds/bird1.webp","nature/nature17.webp","insects/insect10.webp"]
                },
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "pizza1.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["food/fish.webp","food/frenchFries.webp","food/friedEggs.webp","food/grilledSandwich.webp","food/hamburger.webp","food/hotdog.webp"],
                    "bad": ["nature/nature26.webp","birds/bird25.webp","transport/cycle.webp","insects/insect1.webp","nature/nature24.webp","others/fork.webp"]
                },
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "hotdog.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["food/icecream.webp","food/cereal1.webp","food/cheese1.webp","food/kathiRoll.webp","food/macroni.webp"],
                    "bad": ["animals/camel.webp","animals/hare.webp","insects/insect4.webp","birds/bird5.webp"]
                },
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "frenchFries.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["food/MaozVegetariano.webp","food/milk.webp","food/bananaNutBread.webp","food/pitaBread.webp","food/pizza.webp"],
                    "bad": ["birds/bird6.webp","others/street.webp","householdGoods/iron2.webp","insects/insect8.webp"]
                },
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "hamburger.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["food/icecream1.webp","food/riceBeans.webp","food/scrambledEggsVeggies.webp"],
                    "bad": ["nature/nature21.webp","plants/tree2.webp","householdGoods/bed.webp"]
                },
                {
                    "instructions": qsTr("Place the FOOD ITEMS to the right and other objects to the left"),
                    "image": imagesPrefix + "milk.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["food/skimmedMilk.webp","food/steak.webp","food/sweetBread.webp"],
                    "bad": ["birds/bird4.webp","animals/koala.webp","transport/ferry.webp"]
                }
            ]
        }
    ]
}
