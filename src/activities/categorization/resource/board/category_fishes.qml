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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/fishes/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("fishes"),
            "image": imagesPrefix + "fish20.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish10.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish1.jpg","fishes/fish2.png","fishes/fish3.jpg","fishes/fish4.jpg","fishes/fish5.jpg","fishes/fish6.jpg"],
                    "bad": ["monuments/beandenburgGate.jpg","monuments/burj.jpg","others/bulb.jpg","tools/cutingTool.jpg","others/knife.jpg","tools/multimeter.jpg"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish13.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish7.jpg","fishes/fish8.jpg","fishes/fish9.jpg","fishes/fish10.jpg","fishes/fish11.jpg","fishes/fish12.jpg"],
                    "bad": ["renewable/dam2.jpg","renewable/solar5.jpg","others/pillow.jpg","tools/plier2.jpg","tools/nailCutter.jpg","monuments/colosseum.jpg"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish3.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish13.jpg","fishes/fish14.jpg","fishes/fish15.jpg","fishes/fish16.jpg","fishes/fish17.jpg"],
                    "bad": ["others/bulb.jpg","others/chair.jpg","renewable/windmill.jpg","monuments/monument2.jpg"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish16.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish18.jpg","fishes/fish19.jpg","fishes/fish20.jpg","fishes/fish21.jpg",
                            "fishes/fish22.jpg"],
                    "bad": ["others/plate.jpg","monuments/operaHouse.jpg","monuments/zimniPalace.jpg","renewable/geothermal.jpg"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish20.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish23.jpg","fishes/fish24.jpg", "fishes/fish25.jpg"],
                    "bad": ["monuments/monument3.jpg","others/pan.jpg","others/pencil.jpg"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish25.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish26.jpg","fishes/fish27.jpg","fishes/fish28.jpg"],
                    "bad": ["renewable/windmill13.jpg","renewable/geothermal.jpg","tools/scissors.jpg"]
                }
            ]
        }
    ]
}
