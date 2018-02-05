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

QtObject {
    property bool isEmbedded: true
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/renewable/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Renewable"),
            "image": imagesPrefix + "windmill12.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "windmill12.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/windmill.jpg","renewable/windmill1.jpg","renewable/windmill2.jpg","renewable/windmill3.jpg","renewable/windmill4.jpg","renewable/windmill5.jpg"],
                    "bad": ["fishes/fish20.jpg","others/volleyball.jpg","monuments/burj.jpg","tools/nosePlier.jpg","others/pillow.jpg","fishes/fish10.jpg"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "solar8.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/solar1.jpg","renewable/solar2.jpg","renewable/solar3.jpg","renewable/solar4.jpg","renewable/solar5.jpg","renewable/solar6.jpg"],
                    "bad": ["others/plate.jpg","fishes/fish25.jpg","tools/scissor1.jpg","monuments/christTheRedeemer.jpg","others/bucket.png","monuments/jucheTower.jpg"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "dam2.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/dam1.jpg","renewable/dam2.jpg","renewable/dam3.jpg","renewable/dam4.jpg"],
                    "bad": ["fishes/fish14.jpg","tools/wrench.jpg","tools/plier2.jpg","others/baseball.jpg","monuments/arcDeTriomphe.jpg"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "dam5.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/windmill2.jpg","renewable/windmill13.jpg","renewable/solar7.jpg","renewable/solar3.jpg"],
                    "bad": ["monuments/greatPyramid.jpg","others/buffetset.jpg","others/weighingMachine.jpg","tools/sprinkler.jpg","monuments/arcDeTriomphe.jpg"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "geothermal.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/dam5.jpg","renewable/geothermal.jpg","renewable/windmill6.jpg","renewable/windmill7.jpg","renewable/windmill8.jpg"],
                    "bad": ["fishes/fish6.jpg","fishes/fish3.jpg","others/pan.jpg","others/spoons.jpg"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "dam3.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/windmill9.jpg","renewable/windmill12.jpg","renewable/solar7.jpg"],
                    "bad": ["others/blackslate.jpg","monuments/IndiaGate.jpg","tools/multimeter.jpg"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "solar2.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/solar8.jpg","renewable/dam5.jpg","renewable/windmill11.jpg"],
                    "bad": ["others/plate.jpg","others/chair.jpg","monuments/eiffelTower.jpg"]
                },
                {
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "solar4.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["renewable/windmill14.jpg","renewable/windmill15.jpg","renewable/dam5.jpg"],
                    "bad": ["others/plate.jpg","fishes/fish18.jpg","monuments/leMusee.jpg"]
                }
            ]
        }
    ]
}
