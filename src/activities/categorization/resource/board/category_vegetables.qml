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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject{
    property bool isEmbedded: false
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/data/words/vegetables/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Vegetables"),
            "image": imagesPrefix + "vegetablesmix.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["vegetables/batatadoce.jpg","vegetables/bittergourd.jpg","vegetables/blackchillies.jpg", "vegetables/aubergine.jpg","vegetables/peas.JPG","vegetables/carrots.jpg"],
                    "bad": ["fruits/cranberries.jpg","fruits/feiji.jpg","fruits/strwaberry.jpg","fruits/pear.jpg","food/applepie.jpg","food/biryani.jpg","transport/bus.jpg","transport/truck.jpg"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["vegetables/cauliflower.jpg","vegetables/chillies.jpg","vegetables/chineseradish.jpg","vegetables/cucumber.jpg","vegetables/dahuisi.jpg","vegetables/garlic.jpg"],
                    "bad": ["fruits/apple.jpg","fruits/apricot.jpg","fruits/banana.jpg","fruits/berries.jpg","transport/boat.jpg","plants/plant2.jpg","nature/nature6.jpg","householdGoods/quilt.jpg"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["vegetables/potato.jpg","vegetables/radish.jpg","vegetables/redchillies.jpg","vegetables/spinach.jpg"],
                    "bad": ["fruits/billberries.jpg","fruits/cherries.jpg","food/cheese.jpg","birds/bird7.jpg","insects/insect2.jpg"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["vegetables/spinaches.jpg","vegetables/taroroot.jpg","vegetables/cauliflower.jpg","vegetables/batatadoce.jpg"],
                    "bad": ["fruits/kiwi.jpg","householdGoods/vacuumCleaner.jpg","householdGoods/utensils.jpg","food/pizza.jpg","transport/tanker.jpg"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["vegetables/mushroom.jpg","vegetables/pumpkin.jpg","vegetables/sweetpotato.jpg"],
                    "bad": ["fruits/mango.jpg","plants/plant6.jpg","others/electricfan.jpg"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and other objects to the left"),
                    "image": imagesPrefix + "vegetablesmix.jpg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["vegetables/zucchini.jpg","vegetables/vegetablesmix.jpg"],
                    "bad": ["fruits/papaya.jpg","food/sweetBread.jpg","others/clock.jpg","others/pepsi.jpg"]
                }
            ]
        }
    ]
}
