/* GCompris
 *
 * Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject{
    property bool isEmbedded: false
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/data/words/nature/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Nature"),
            "image": imagesPrefix + "nature7.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature25.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["nature/nature1.jpg","nature/nature2.jpg","nature/nature3.jpg","nature/nature4.jpg","nature/nature5.jpg","nature/nature6.jpg"],
                    "bad": ["transport/train3.jpg","others/spoon.jpg","transport/bus.jpg","others/clock.jpg","food/hamburger.jpg","food/macroni.jpg"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature28.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["nature/nature7.jpg","nature/nature8.jpg","nature/nature9.jpg","nature/nature10.jpg", "nature/nature11.jpg","nature/nature12.jpg"],
                    "bad": ["fruits/mango.jpg","vegetables/onion.jpg","transport/cycle.jpg","others/fork.jpg","food/riceBeans.jpg","others/pepsi.jpg"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature22.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["nature/nature13.jpg","nature/nature14.jpg","nature/nature15.jpg","nature/nature16.jpg","nature/nature17.jpg"],
                    "bad": ["transport/autorickshaw.jpg","transport/bulletTrain.jpg","householdGoods/chest.jpg","others/broom1.jpg"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature2.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["nature/nature18.jpg","nature/nature19.jpg","nature/nature20.jpg","nature/nature21.jpg","nature/nature22.jpg"],
                    "bad": ["transport/train5.jpg","transport/tram1.jpg","others/mobile.jpg","others/electricfan.jpg"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature2.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["nature/nature29.jpg","nature/nature30.jpg","nature/nature31.jpg","nature/nature32.jpg","nature/nature33.jpg"],
                    "bad": ["fruits/pineapple.jpg","food/pitaBread.jpg","householdGoods/bed.jpg","others/house.jpg"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature6.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["nature/nature23.jpg","nature/nature24.jpg","nature/nature25.jpg"],
                    "bad": ["vegetables/zucchini.jpg","others/street.jpg","householdGoods/couch.jpg"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature14.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["nature/nature26.jpg","nature/nature27.jpg","nature/nature28.jpg"],
                    "bad": ["food/MaozVegetariano.jpg","transport/rickshaw2.jpg","others/electricfan.jpg"]
                },
                {
                    "instructions": qsTr("Place the NATURE images to the right and other objects to the left"),
                    "image": imagesPrefix + "nature14.jpg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["nature/nature34.jpg","nature/nature35.jpg"],
                    "bad": ["householdGoods/chair2.jpg","food/milk.jpg","others/weighingmachine.jpg","others/pencil.jpg"]
                }
            ]
        }
    ]
}
