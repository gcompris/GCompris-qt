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
    property string imagesPrefix: "qrc:/gcompris/data/words/insects/"
    property variant levels: [
        {
            "type": "lesson",
            "name": qsTr("Insects"),
            "image": imagesPrefix + "insect6.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect15.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["insects/insect1.jpg","insects/insect2.jpg","insects/insect3.jpg","insects/insect4.jpg","insects/insect5.jpg","insects/insect6.jpg"],
                    "bad": ["nature/nature4.jpg","plants/tree2.jpg","birds/bird8.jpg","birds/bird5.jpg","animals/giraffe.jpg","animals/horse.jpg"]
                },
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect25.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["insects/insect7.jpg","insects/insect8.jpg","insects/insect9.jpg","insects/insect10.jpg","insects/insect11.jpg","insects/insect12.jpg"],
                    "bad": ["food/eggs.jpg","birds/bird2.jpg","birds/bird3.jpg","animals/lion.jpg","animals/mouse.jpg","animals/elephant.jpg"]
                },
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect6.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["insects/insect13.jpg","insects/insect14.jpg","insects/insect15.jpg","insects/insect16.jpg","insects/insect17.jpg"],
                    "bad": ["transport/helicopter.jpg","householdGoods/oven.jpg","birds/bird8.jpg","birds/bird9.jpg"]
                },
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect8.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["insects/insect18.jpg","insects/insect19.jpg","insects/insect20.jpg","insects/insect21.jpg","insects/insect22.jpg"],
                    "bad": ["householdGoods/bed.jpg","others/mobile.jpg","birds/bird17.jpg","animals/hare.jpg"]
                },
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect19.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["insects/insect23.jpg","insects/insect24.jpg","insects/insect25.jpg"],
                    "bad": ["plants/tree3.jpg","birds/bird29.jpg","animals/pig.jpg"]
                },
                {
                    "instructions": qsTr("Place the INSECTS to the right and other objects to the left"),
                    "image": imagesPrefix + "insect12.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["insects/insect26.jpg","insects/insect27.jpg","insects/insect12.jpg"],
                    "bad": ["householdGoods/iron.jpg","birds/bird33.jpg","animals/sheep.jpg"]
                }
            ]
        }
    ]
}
