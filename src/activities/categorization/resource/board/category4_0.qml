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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/renewable/"
    property variant levels: [
        {
            "type": "lesson",
            "name": qsTr("Renewable"),
            "image": imagesPrefix + "windmill12.jpg",
            "content": [
                {
                    "tags": ["renewable"],
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "windmill12.jpg",
                    "maxNumberOfGood": 6,
		            "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        { 
                            "renewable/windmill.jpg":["renewable"],
                            "renewable/windmill1.jpg":["renewable"],
                            "renewable/windmill2.jpg":["renewable"],
                            "renewable/windmill3.jpg":["renewable"],
                            "renewable/windmill4.jpg":["renewable"],
                            "renewable/windmill5.jpg":["renewable"],
                            "fishes/fish20.jpg":["nature"],
                            "others/volleyball.jpg":["others"],
                            "monuments/burj.jpg":["nature"],
                            "tools/nosePlier.jpg":["birds"],
                            "others/pillow.jpg":["nature"],
                            "fishes/fish10.jpg":["fishes"]
                        }
                    ]
                },
                {
                    "tags": ["renewable"],
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "solar8.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "renewable/solar1.jpg":["renewable"],
                            "renewable/solar2.jpg":["renewable"],
                            "renewable/solar3.jpg":["renewable"],
                            "renewable/solar4.jpg":["renewable"],
                            "renewable/solar5.jpg":["renewable"],
                            "renewable/solar6.jpg":["renewable"],
                            "others/plate.jpg":["nature"],
                            "fishes/fish25.jpg":["birds"],
                            "tools/scissor1.jpg":["cycle"],
                            "monuments/christTheRedeemer.jpg":["insect"],
                            "others/bucket.png":["nature"],
                            "monuments/jucheTower.jpg":["others"]
                        }
                    ]
                },
                {
                    "tags": ["renewable"],
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "dam2.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "renewable/dam1.jpg":["renewable"],
                            "renewable/dam2.jpg":["renewable"],
                            "renewable/dam3.jpg":["renewable"],
                            "renewable/dam4.jpg":["renewable"],
                            "fishes/fish14.jpg":["animals"],
                            "tools/wrench.jpg":["animals"],
                            "tools/plier2.jpg":["insects"],
                            "others/baseball.jpg":["insects"],
                            "monuments/arcDeTriomphe.jpg":["monuments"]
                        }
                    ]
                },
                {
                    "tags": ["renewable"],
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "dam5.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "renewable/windmill2.jpg":["renewable"],
                            "renewable/windmill13.jpg":["renewable"],
                            "renewable/solar7.jpg":["renewable"],
                            "renewable/solar3.jpg":["renewable"],
                            "monuments/greatPyramid.jpg":["animals"],
                            "others/buffetset.jpg":["animals"],
                            "others/weighingMachine.jpg":["insects"],
                            "tools/sprinkler.jpg":["insects"],
                            "monuments/arcDeTriomphe.jpg":["monuments"]
                        }
                    ]
                },
                {
                    "tags": ["renewable"],
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "geothermal.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "renewable/dam5.jpg":["renewable"],
                            "renewable/geothermal.jpg":["renewable"],
                            "renewable/windmill6.jpg":["renewable"],
                            "renewable/windmill7.jpg":["renewable"],
                            "renewable/windmill8.jpg":["renewable"],
                            "fishes/fish6.jpg":["fish"],
                            "fishes/fish3.jpg":["others"],
                            "others/pan.jpg":["others"],
                            "others/spoons.jpg":["insects"]
                        }
                    ]
                },               
		{
                    "tags": ["renewable"],
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "dam3.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [
                        {
                            "renewable/windmill9.jpg":["renewable"],
                            "renewable/windmill12.jpg":["renewable"],
                            "renewable/solar7.jpg":["renewable"],
                            "others/blackslate.jpg":["nature"],
                            "monuments/IndiaGate.jpg":["monuments"],
                            "tools/multimeter.jpg":["others"]
                        }
                    ]
                },
		{
                    "tags": ["renewable"],
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "solar2.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [ 
                        {  
                            "renewable/solar8.jpg":["renewable"],
                            "renewable/dam5.jpg":["renewable"],
                            "renewable/windmill11.jpg":["renewable"],
                            "others/plate.jpg":["others"],
                            "others/chair.jpg":["animals"],
                            "monuments/eiffelTower.jpg":["monuments"]
                        }
                    ]
                },
		{
                    "tags": ["renewable"],
                    "instructions": qsTr("Place the RENEWABLE energy sources to the right and other objects to the left"),
                    "image": imagesPrefix + "solar4.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "levelImages": [ 
                        {  
                            "renewable/windmill14.jpg":["renewable"],
                            "renewable/windmill15.jpg":["renewable"],
                            "renewable/dam5.jpg":["renewable"],
                            "others/plate.jpg":["others"],
                            "fishes/fish18.jpg":["animals"],
                            "monuments/leMusee.jpg":["monuments"]
                        }
                    ]
                }
            ]
            
        }
    ]
}
