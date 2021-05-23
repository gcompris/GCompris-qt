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
    property string imagesPrefix: "qrc:/gcompris/src/activities/lang/resource/words_sample/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Fruits"),
            "image": "qrc:/gcompris/data/words/fruits/fruitsalad.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.png",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["fruits/apple.jpg","fruits/apricot.jpg","fruits/banana.jpg","fruits/berries.jpg","fruits/billberries.jpg","fruits/cherries.jpg"],
                    "bad": ["vegetables/batatadoce.jpg","vegetables/bittergourd.jpg","vegetables/blackchillies.jpg","vegetables/aubergine.jpg","others/house.jpg","others/street.jpg"],
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.png",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["fruits/cranberries.jpg","fruits/feiji.jpg","fruits/kiwi.jpg","fruits/lemon.jpg","fruits/litchi.jpg","fruits/mango.jpg"],
                    "bad": ["vegetables/garlic.jpg","vegetables/carrots.jpg","vegetables/cauliflower.jpg","vegetables/chillies.jpg","others/spoon.jpg","others/fork.jpg"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.png",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 7,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["fruits/mirabellen.jpg","fruits/nectarine.jpg","fruits/papaya.jpg","fruits/peach.jpg","fruits/pineapple.jpg"],
                    "bad": ["vegetables/chineseradish.jpg","vegetables/cucumber.jpg","food/cereal.jpg","food/macroni.jpg","food/hamburger.jpg","transport/cycle.jpg","transport/car1.jpg"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.png",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["fruits/plum.jpg","fruits/stackelberry.jpg","fruits/tyttberries.jpg","fruits/strwaberry.jpg"],
                    "bad": ["vegetables/dahuisi.jpg","others/mobile.jpg","vegetables/fid.jpg","food/eggs.jpg","food/icecream.jpg"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.png",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["fruits/fruitsalad.jpg","fruits/guava.jpg","fruits/grapes.jpg","fruits/litchi.jpg"],
                    "bad": ["vegetables/pumpkin.jpg","transport/bus.jpg","food/milk.jpg","food/cheese.jpg","food/butter.jpg"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.png",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["fruits/pear.jpg","fruits/pyrusmalus.jpg","fruits/pineapple.jpg"],
                    "bad": ["vegetables/radish.jpg","food/popcorn.jpg","others/street.jpg"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.png",
                    "maxNumberOfGood": 3 ,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["fruits/peach.jpg","fruits/tyttberries.jpg","fruits/papaya.jpg"],
                    "bad": ["vegetables/spinach.jpg","food/hotdog.jpg", "food/milk.jpg"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and other objects to the left"),
                    "image": imagesPrefix + "fruit.png",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["fruits/mango.jpg","fruits/strwaberry.jpg"],
                    "bad": ["others/pencil.jpg","vegetables/onion.jpg","food/cheese.jpg","food/water.jpg"]
                }
            ]
        }
    ]
}
