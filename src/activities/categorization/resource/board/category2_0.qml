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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/tools/"
    property variant levels: [
        {
            "type": "lesson",
            "name": qsTr("Tools"),
            "image": imagesPrefix + "measuringTape.jpg",
            "content": [
                {
                    "tags": ["tools"],
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "wrench.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "tools/clawHammer.jpg": ["tools"],
                            "tools/clawHammer1.jpg": ["tools"],
                            "tools/estwingHammer.jpg": ["tools"],
                            "tools/framingHammer.jpg": ["tools"],
                            "tools/hammer1.jpg": ["tools"],
                            "tools/hammer2.jpg": ["tools"],
                            "monuments/arcDeTriomphe.jpg": ["monuments"],
                            "others/buffetset.jpg": ["others"],
                            "monuments/cathedral.jpg": ["monuments"],
                            "others/pillow.jpg": ["others"],
                            "renewable/windmill1.jpg": ["renewable"],
                            "renewable/geothermal.jpg": ["renewable"]
                        }
                    ]
                },   
                {
                    "tags": ["tools"],
                    "instructions": qsTr("Place the TOOLS to the right and others to the left"),
                    "image": imagesPrefix + "sideCutter1.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "tools/measuringTape.jpeg": ["tools"],
                            "tools/measuringTape.jpg": ["tools"],
                            "tools/measuringTape1.jpg": ["tools"],
                            "tools/nosePlier.jpg": ["tools"],
                            "tools/nosePlier1.jpg": ["tools"],
                            "tools/measuringTape3.jpg": ["tools"],
                            "others/pan.jpg": ["others"],
                            "others/blackslate.jpg": ["others"],
                            "monuments/colosseum.jpg": ["monuments"],
                            "fishes/fish10.jpg": ["fishes"],
                            "renewable/dam1.jpg": ["renewable"],
                            "renewable/solar1.jpg": ["renewable"]
                        }
                    ]
                }, 
                {
                    "tags": ["tools"],
                    "instructions": qsTr("Place the TOOLS to the right and others to the left"),
                    "image": imagesPrefix + "scissors.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "tools/scissor1.jpg": ["tools"],
                            "tools/scissor2.jpg": ["tools"],
                            "tools/scissors.jpg": ["tools"],
                            "tools/scissors2.jpg": ["tools"],
                            "tools/tweezer.jpg": ["tools"],
                            "tools/wrench1.jpg": ["tools"],
                            "others/buffetset.jpg": ["others"],
                            "monuments/beandenburgGate.jpg": ["monuments"],
                            "monuments/parthenon.jpg": ["monuments"],
                            "fishes/fish12.jpg": ["fishes"],
                            "fishes/fish16.jpg": ["fishes"],
                            "others/plate.jpg": ["others"]
                        }
                    ]
                }, 
                {
                    "tags": ["tools"],
                    "instructions": qsTr("Place the TOOLS to the right and others to the left"),
                    "image": imagesPrefix + "sprinkler.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "tools/sprinkler.jpg": ["tools"],
                            "tools/screwDriver.jpg": ["tools"],
                            "tools/screwDriver1.jpg": ["tools"],
                            "tools/screwDriver2.jpg": ["tools"],
                            "tools/screwDriver3.jpg": ["tools"],
                            "tools/plier.jpg": ["tools"],
                            "others/baseball.jpg": ["others"],
                            "others/igloo.jpg": ["others"],
                            "monuments/mountRushmore.jpg": ["monuments"],
                            "renewable/dam3.jpg": ["renewable"],
                            "monuments/greatWall.jpg": ["monuments"],
                            "renewable/windmill7.jpg": ["renewable"]
                        }
                    ]
                }, 
		{
                    "tags": ["tools"],
                    "instructions": qsTr("Place the TOOLS to the right and others to the left"),
                    "image": imagesPrefix + "plier.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "tools/multimeter.jpg": ["tools"],
                            "tools/screwDriver.jpg": ["tools"],
                            "tools/hammer3.jpg": ["tools"],
                            "tools/measuringTape.jpg": ["tools"],
                            "tools/nosePlier.jpg": ["tools"],
                            "fishes/fish25.jpg": ["insects"],
                            "fishes/fish18.jpg": ["fishes"],
                            "monuments/monument1.jpg": ["monuments"],
                            "monuments/monument2.jpg": ["monuments"]
                        }
                    ]
                }, 
                {
                    "tags": ["tools"],
                    "instructions": qsTr("Place the TOOLS to the right and others to the left"),
                    "image": imagesPrefix + "nosePlier2.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "tools/wrench.jpg": ["tools"],
                            "tools/tweezer1.jpg": ["tools"],
                            "tools/sickle.jpg": ["tools"],
                            "tools/plier.jpg": ["tools"],
                            "tools/sideCutter1.jpg": ["tools"],
                            "renewable/solar5.jpg": ["renewable"],
                            "others/bulb.jpg": ["others"],
                            "renewable/dam3.jpg": ["renewable"],
                            "monuments/leninMuseum.jpg": ["monuments"]
                        }
                    ]
                    
                },
                {
                    "tags": ["tools"],
                    "instructions": qsTr("Place the TOOLS to the right and others to the left"),
                    "image": imagesPrefix + "multimeter.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "tools/nosePlier3.jpg": ["tools"],
                            "tools/scissor.jpg": ["tools"],
                            "tools/plier2.jpg": ["tools"],
                            "tools/sideCutter1.jpg": ["tools"],
                            "fishes/fish3.jpg": ["fishes"],
                            "others/chair.jpg": ["others"],
                            "monuments/operaHouse.jpg": ["monuments"],
                            "renewable/windmill12.jpg": ["renewable"],
                            "monuments/IndiaGate.jpg": ["monuments"]
                        }
                    ]
                },
                {
                    "tags": ["tools"],
                    "instructions": qsTr("Place the TOOLS to the right and others to the left"),
                    "image": imagesPrefix + "nailCutter.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "tools/measuringTape2.jpg": ["tools"],
                            "tools/hammer5.jpg": ["tools"],
                            "tools/plier1.jpg": ["tools"],
                            "fishes/fish6.jpg": ["fishes"],
                            "monuments/tajMahal.jpg": ["monuments"],
                            "renewable/solar3.jpg": ["renewable"]
                        }
                    ]
                },
                {
                    "tags": ["tools"],
                    "instructions": qsTr("Place the TOOLS to the right and others to the left"),
                    "image": imagesPrefix + "screwDriver.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "tools/nosePlier2.jpg": ["tools"],
                            "tools/multimeter2.jpg": ["tools"],
                            "tools/nailCutter.jpg": ["tools"],
                            "fishes/fish10.jpg": ["fishes"],
                            "others/pan.jpg": ["others"],
                            "others/igloo.jpg": ["others"]
                        }
                    ]
                },
                {
                    "tags": ["tools"],
                    "instructions": qsTr("Place the TOOLS to the right and others to the left"),
                    "image": imagesPrefix + "scissor.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "tools/hammer4.jpg": ["tools"],
                            "tools/screwDriver.jpg": ["tools"],
                            "tools/multimeter1.jpg": ["tools"],
                            "renewable/dam2.jpg": ["renewable"],
                            "monuments/leaningTowerOfPisa.jpg": ["monuments"],
                            "others/pillow.jpg": ["others"]
                        }
                    ]
                }
            ]
        }
    ]
}
