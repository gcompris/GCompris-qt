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
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/nature/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Nature"),
            "image": imagesPrefix + "nature7.webp",
            "content": [
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature25.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["nature/nature1.webp","nature/nature2.webp","nature/nature3.webp","nature/nature4.webp","nature/nature5.webp","nature/nature6.webp"],
                    "bad": ["transport/train3.webp","others/spoon.webp","transport/bus.webp","others/clock.webp","food/hamburger.webp","food/macroni.webp"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature28.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["nature/nature7.webp","nature/nature8.webp","nature/nature9.webp","nature/nature10.webp", "nature/nature11.webp","nature/nature12.webp"],
                    "bad": ["fruits/mango.webp","vegetables/onion.webp","transport/cycle.webp","others/fork.webp","food/riceBeans.webp","others/pepsi.webp"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature22.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["nature/nature13.webp","nature/nature14.webp","nature/nature15.webp","nature/nature16.webp","nature/nature17.webp"],
                    "bad": ["transport/autorickshaw.webp","transport/bulletTrain.webp","householdGoods/chest.webp","others/broom1.webp"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature2.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["nature/nature18.webp","nature/nature19.webp","nature/nature20.webp","nature/nature21.webp","nature/nature22.webp"],
                    "bad": ["transport/train5.webp","transport/tram1.webp","others/mobile.webp","others/electricfan.webp"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature2.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["nature/nature29.webp","nature/nature30.webp","nature/nature31.webp","nature/nature32.webp","nature/nature33.webp"],
                    "bad": ["fruits/pineapple.webp","food/pitaBread.webp","householdGoods/bed.webp","others/house.webp"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature6.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["nature/nature23.webp","nature/nature24.webp","nature/nature25.webp"],
                    "bad": ["vegetables/zucchini.webp","others/street.webp","householdGoods/couch.webp"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature14.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["nature/nature26.webp","nature/nature27.webp","nature/nature28.webp"],
                    "bad": ["food/MaozVegetariano.webp","transport/rickshaw2.webp","others/electricfan.webp"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature14.webp",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["nature/nature34.webp","nature/nature35.webp"],
                    "bad": ["householdGoods/chair2.webp","food/milk.webp","others/weighingmachine.webp","others/pencil.webp"]
                }
            ]
        }
    ]
}
