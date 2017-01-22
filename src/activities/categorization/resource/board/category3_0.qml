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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/monuments/"
    property variant levels: [
        {
            "type": "lesson",
            "name": qsTr("Monuments"),
            "image": imagesPrefix + "colosseum.jpg",
            "content": [
                {
                    "tags": ["monuments"],
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "victoriaMemorial.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        { 
                            "monuments/bayterek.jpg": ["monuments"],
                            "monuments/burj.jpg": ["monuments"],
                            "monuments/cathedral.jpg": ["monuments"],
                            "monuments/colosseum.jpg": ["monuments"],
                            "monuments/beandenburgGate.jpg": ["monuments"],
                            "monuments/arcDeTriomphe.jpg": ["monuments"],
                            "renewable/windmill5.jpg": ["nature"],
                            "renewable/dam2.jpg": ["renewable"],
                            "tools/tweezer.jpg": ["tools"],
                            "others/bulb.jpg": ["others"],
                            "others/pan.jpg": ["others"],
                            "others/knife.jpg": ["others"]
                        }
                    ]
                },
                {
                    "tags": ["monuments"],
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "parthenon.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "monuments/christTheRedeemer.jpg": ["monuments"],
                            "monuments/eiffelTower.jpg": ["monuments"],
                            "monuments/empireState.jpg": ["monuments"],
                            "monuments/greatPyramid.jpg": ["monuments"],
                            "monuments/greatWall.jpg": ["monuments"],
                            "monuments/IndiaGate.jpg": ["monuments"],
                            "fishes/fish3.jpg": ["fishes"],
                            "fishes/fish5.jpg": ["fishes"],
                            "renewable/dam2.jpg": ["renewable"],
                            "others/spoons.jpg": ["others"],
                            "others/igloo.jpg": ["others"],
                            "tools/measuringTape.jpg": ["tools"]
                        }
                    ]
                },
                {
                    "tags": ["monuments"],
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "monument2.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "monuments/jucheTower.jpg": ["monuments"],
                            "monuments/kutubMinar.jpg": ["monuments"],
                            "monuments/leaningTowerOfPisa.jpg": ["monuments"],
                            "monuments/leninMuseum.jpg": ["monuments"],
                            "monuments/monument1.jpg": ["monuments"],
                            "fishes/fish7.jpg": ["fishes"],
                            "fishes/fish16.jpg": ["fishes"],
                            "tools/hammer4.jpg": ["tools"],
                            "tools/sprinkler.jpg": ["tools"]
                        }
                    ]
                },
                {
                    "tags": ["monuments"],
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "greatPyramid.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "monuments/mountRushmore.jpg": ["monuments"],
                            "monuments/operaHouse.jpg": ["monuments"],
                            "monuments/parthenon.jpg": ["monuments"],
                            "monuments/statueOfLiberty.jpg": ["monuments"],
                            "monuments/tajMahal.jpg": ["monuments"],
                            "renewable/solar2.jpg": ["renewable"],
                            "renewable/geothermal.jpg": ["renewable"],
                            "tools/scissor.jpg": ["tools"],
                            "tools/stripper1.png": ["tools"]
                        }
                    ]
                },               
		{
                    "tags": ["monuments"],
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "beandenburgGate.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "monuments/usCapitol.jpg": ["monuments"],
                            "monuments/victoriaMemorial.jpg": ["monuments"],
                            "monuments/zimniPalace.jpg": ["monuments"],
                            "tools/plier2.jpg": ["tools"],
                            "others/pillow.jpg": ["others"],
                            "renewable/solar5.jpg": ["renewable"]
                        }
                    ]
                },
		{
                    "tags": ["monuments"],
                    "instructions": qsTr("Place the MONUMENTS to the right and other objects to the left"),
                    "image": imagesPrefix + "IndiaGate.jpg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [ 
                        {  
                            "monuments/monument2.jpg": ["monuments"],
                            "monuments/monument3.jpg": ["monuments"],
                            "others/volleyball.jpg": ["others"],
                            "tools/sickle.jpg": ["tools"],
                            "others/chair.jpg": ["tools"],
                            "renewable/dam4.jpg": ["renewable"]
                        }
                    ]
                }
            ]
            
        }
    ]
}
