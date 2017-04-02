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
import QtQuick 2.0

QtObject{
    property bool isEmbedded: false
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/data/words/animals/"
    property variant levels:[
        {
            "type": "lesson",
            "name": qsTr("Animals"),
            "image": imagesPrefix + "animalsherd.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "tiger.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/baboon.jpg","animals/bosmutus.jpg","animals/camel.jpg","animals/cow.jpg","animals/dog.jpg","animals/sealion.jpg"],
                    "bad": ["birds/bird10.jpg","birds/bird12.jpg","birds/bird13.jpg","others/electricfan.jpg","others/clock.jpg","nature/nature10.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "tiger.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/lion.jpg","animals/marsupialis.jpg","animals/mouse.jpg","animals/mouse1.jpg","animals/opossum.jpg","animals/pig.jpg"],
                    "bad": ["birds/bird6.jpg","birds/bird7.jpg","birds/bird8.jpg","birds/bird9.jpg","transport/rickshaw.jpg","transport/bus.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "opossum.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/snowcat.jpg","animals/spidermonkey.jpg","animals/squirrel.jpg","animals/squirrel1.jpg","animals/tasmaniandevil.jpg","animals/pelonquintana.jpg"],
                    "bad": ["birds/bird22.jpg","birds/bird23.jpg","others/house.jpg","transport/plane2.jpg","plants/plant4.jpg","nature/nature5.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "tortoise.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/redeyedfrog.jpg","animals/scorpian.jpg","animals/sealion.jpg","animals/sheep.jpg","animals/snake.jpg"],
                    "bad": ["birds/bird18.jpg","birds/bird19.jpg","food/fish.jpg","food/icecream.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "koala.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/donkey.jpg","animals/elephant.jpg","animals/hare.jpg","animals/tiger.jpg","animals/zebra.jpg"],
                    "bad": ["birds/parrot.jpg","insects/insect20.jpg","transport/cycle.jpg","plants/tree3.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "hedgehog.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/giraffe.jpg","animals/hare.jpg","animals/hedgehog.jpg","animals/horse.jpg"],
                    "bad": ["birds/bird21.jpg","birds/bird25.jpg","food/cheese.jpg","others/mobile.jpg","insects/insect7.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "lion.jpg",
                    "maxNumberOfGood": 3 ,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/koala.jpg","animals/kodiak-bear.jpg","animals/krotiki.jpg"],
                    "bad": ["birds/bird26.jpg","birds/bird27.jpg","food/eggs.jpg","food/hamburger.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "pig.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/tiger.jpg","animals/tortoise.jpg","animals/tortoise1.jpg"],
                    "bad": ["birds/bird28.jpg","birds/bird29.jpg","fruits/papaya.jpg","food/hotdog.jpg"]
                },
                {
                    "instructions": qsTr("Place the ANIMALS to the right and other objects to the left"),
                    "image": imagesPrefix + "snowcat.jpg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["animals/porcupine.jpg","animals/cow.jpg"],
                    "bad": ["birds/bird32.jpg","birds/bird33.jpg","food/macroni.jpg","others/house.jpg"]
                }
            ]
        }
    ]
}
