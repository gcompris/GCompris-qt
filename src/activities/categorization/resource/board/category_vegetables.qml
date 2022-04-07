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
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/vegetables/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Vegetables"),
            "image": imagesPrefix + "vegetablesmix.webp",
            "content": [
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["vegetables/batatadoce.webp","vegetables/bittergourd.webp","vegetables/blackchillies.webp", "vegetables/aubergine.webp","vegetables/peas.webp","vegetables/carrots.webp"],
                    "bad": ["fruits/cranberries.webp","fruits/feiji.webp","fruits/strwaberry.webp","fruits/pear.webp","food/applepie.webp","food/biryani.webp","transport/bus.webp","transport/truck.webp"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["vegetables/cauliflower.webp","vegetables/chillies.webp","vegetables/chineseradish.webp","vegetables/cucumber.webp","vegetables/dahuisi.webp","vegetables/garlic.webp"],
                    "bad": ["fruits/apple.webp","fruits/apricot.webp","fruits/banana.webp","fruits/berries.webp","transport/boat.webp","plants/plant2.webp","nature/nature6.webp","householdGoods/quilt.webp"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["vegetables/potato.webp","vegetables/radish.webp","vegetables/redchillies.webp","vegetables/spinach.webp"],
                    "bad": ["fruits/billberries.webp","fruits/cherries.webp","food/cheese.webp","birds/bird7.webp","insects/insect2.webp"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["vegetables/spinaches.webp","vegetables/taroroot.webp","vegetables/cauliflower.webp","vegetables/batatadoce.webp"],
                    "bad": ["fruits/kiwi.webp","householdGoods/vacuumCleaner.webp","householdGoods/utensils.webp","food/pizza.webp","transport/tanker.webp"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["vegetables/mushroom.webp","vegetables/pumpkin.webp","vegetables/sweetpotato.webp"],
                    "bad": ["fruits/mango.webp","plants/plant6.webp","others/electricfan.webp"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.webp",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["vegetables/zucchini.webp","vegetables/vegetablesmix.webp"],
                    "bad": ["fruits/papaya.webp","food/sweetBread.webp","others/clock.webp","others/pepsi.webp"]
                }
            ]
        }
    ]
}
