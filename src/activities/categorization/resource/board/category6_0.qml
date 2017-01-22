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

QtObject {
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/fishes/"
    property variant levels: [
        {
            "type": "lesson",
            "name": qsTr("fishes"),
            "image": imagesPrefix + "fish20.jpg",
            "content": [
                {
                    "tags": ["fish"],
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish10.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        { 
                            "fishes/fish1.jpg": ["fish"],
                            "fishes/fish2.png": ["fish"],
                            "fishes/fish3.jpg": ["fish"],
                            "fishes/fish4.jpg": ["fish"],
                            "fishes/fish5.jpg": ["fish"],
                            "fishes/fish6.jpg": ["fish"],
                            "monuments/beandenburgGate.jpg": ["monuments"],
                            "monuments/burj.jpg": ["monuments"],
                            "others/bulb.jpg": ["others"],
                            "tools/cutingTool.jpg": ["tools"],
                            "others/knife.jpg": ["tools"],
                            "tools/multimeter.jpg": ["tools"]
                        }
                    ]
                },
                {
                    "tags": ["fish"],
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish13.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "fishes/fish7.jpg": ["fish"],
                            "fishes/fish8.jpg": ["fish"],
                            "fishes/fish9.jpg": ["fish"],
                            "fishes/fish10.jpg": ["fish"],
                            "fishes/fish11.jpg": ["fish"],
                            "fishes/fish12.jpg": ["fish"],
                            "renewable/dam2.jpg": ["renewable"],
                            "renewable/solar5.jpg": ["renewable"],
                            "others/pillow.jpg": ["others"],
                            "tools/plier2.jpg": ["tools"],
                            "tools/nailCutter.jpg": ["tools"],
                            "monuments/colosseum.jpg": ["monuments"]
                        }
                    ]
                },
                {
                    "tags": ["fish"],
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish3.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "fishes/fish13.jpg": ["fish"],
                            "fishes/fish14.jpg": ["fish"],
                            "fishes/fish15.jpg": ["fish"],
                            "fishes/fish16.jpg": ["fish"],
                            "fishes/fish17.jpg": ["fish"],
                            "others/bulb.jpg": ["birds"],
                            "others/chair.jpg": ["birds"],
                            "renewable/windmill.jpg": ["renewable"],
                            "monuments/monument2.jpg": ["renewable"]
                        }
                    ]
                },
                {
                    "tags": ["fish"],
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish16.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "fishes/fish18.jpg": ["fish"],
                            "fishes/fish19.jpg": ["fish"],
                            "fishes/fish20.jpg": ["fish"],
                            "fishes/fish21.jpg": ["fish"],
                            "fishes/fish22.jpg": ["fish"],
                            "others/plate.jpg": ["birds"],
                            "monuments/operaHouse.jpg":["monuments"],
                            "monuments/zimniPalace.jpg":["monuments"],
                            "renewable/geothermal.jpg":["renewable"]
                        }
                    ]
                },
                {
                    "tags": ["fish"],
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish20.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [ 
                        { 
                            "fishes/fish23.jpg": ["fish"],
                            "fishes/fish24.jpg": ["fish"],
                            "fishes/fish25.jpg": ["fish"],
                            "monuments/monument3.jpg": ["monuments"],
                            "others/pan.jpg": ["others"],
                            "others/pencil.jpg": ["others"]
                        }
                    ]
                },
                {
                    "tags": ["fish"],
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish25.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [ 
                        { 
                            "fishes/fish26.jpg": ["fish"],
                            "fishes/fish27.jpg": ["fish"],
                            "fishes/fish28.jpg": ["fish"],
                            "renewable/windmill13.jpg": ["renewable"],
                            "renewable/geothermal.jpg": ["renewable"],
                            "tools/scissors.jpg": ["tools"]
                        }
                    ]
                }
            ]
            
        }
    ]
}
