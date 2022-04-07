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
    property string imagesPrefix: "qrc:/gcompris/src/activities/lang/resource/words_sample/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Fruits"),
            "image": "qrc:/gcompris/data/words-webp/fruits/fruitsalad.webp",
            "content": [
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["fruits/apple.webp","fruits/apricot.webp","fruits/banana.webp","fruits/berries.webp","fruits/billberries.webp","fruits/cherries.webp"],
                    "bad": ["vegetables/batatadoce.webp","vegetables/bittergourd.webp","vegetables/blackchillies.webp","vegetables/aubergine.webp","others/house.webp","others/street.webp"],
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["fruits/cranberries.webp","fruits/feiji.webp","fruits/kiwi.webp","fruits/lemon.webp","fruits/litchi.webp","fruits/mango.webp"],
                    "bad": ["vegetables/garlic.webp","vegetables/carrots.webp","vegetables/cauliflower.webp","vegetables/chillies.webp","others/spoon.webp","others/fork.webp"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 7,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["fruits/mirabellen.webp","fruits/nectarine.webp","fruits/papaya.webp","fruits/peach.webp","fruits/pineapple.webp"],
                    "bad": ["vegetables/chineseradish.webp","vegetables/cucumber.webp","food/cereal.webp","food/macroni.webp","food/hamburger.webp","transport/cycle.webp","transport/car1.webp"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["fruits/plum.webp","fruits/stackelberry.webp","fruits/tyttberries.webp","fruits/strwaberry.webp"],
                    "bad": ["vegetables/dahuisi.webp","others/mobile.webp","vegetables/fid.webp","food/eggs.webp","food/icecream.webp"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["fruits/fruitsalad.webp","fruits/guava.webp","fruits/grapes.webp","fruits/litchi.webp"],
                    "bad": ["vegetables/pumpkin.webp","transport/bus.webp","food/milk.webp","food/cheese.webp","food/butter.webp"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["fruits/pear.webp","fruits/pyrusmalus.webp","fruits/pineapple.webp"],
                    "bad": ["vegetables/radish.webp","food/popcorn.webp","others/street.webp"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.webp",
                    "maxNumberOfGood": 3 ,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["fruits/peach.webp","fruits/tyttberries.webp","fruits/papaya.webp"],
                    "bad": ["vegetables/spinach.webp","food/hotdog.webp", "food/milk.webp"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.webp",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["fruits/mango.webp","fruits/strwaberry.webp"],
                    "bad": ["others/pencil.webp","vegetables/onion.webp","food/cheese.webp","food/water.webp"]
                }
            ]
        }
    ]
}
