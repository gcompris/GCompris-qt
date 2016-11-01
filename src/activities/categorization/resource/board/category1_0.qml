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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/alphabets/"
    property variant levels: [
        {
            "type": "lesson",
            "name": qsTr("Alphabets"),
            "image": imagesPrefix + "alphabets.jpg",
            "content": [
                {
                    "tags": ["alphabets"],
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/upperA.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerP.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/upperR.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerT.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerD.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerE.svg": ["alphabets"],
                            "lang/resource/words_sample/one.png": ["numbers"],
                            "lang/resource/words_sample/six.png": ["numbers"],
                            "lang/resource/words_sample/twelve.png": ["numbers"],
                            "lang/resource/words_sample/coconut.png": ["fruits"],
                            "lang/resource/words_sample/dolphin.png": ["mammals"],
                            "lang/resource/words_sample/kiwi.png": ["fruits"]
                        }
                    ]
                },   
                {
                    "tags": ["alphabets"],
                    "instructions": qsTr("Place the ALPHABETS to the right and others objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/lowerB.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/upperV.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerE.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerN.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/upperM.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/upperO.svg": ["alphabets"],
                            "lang/resource/words_sample/six.png": ["numbers"],
                            "lang/resource/words_sample/sixteen.png": ["numbers"],
                            "lang/resource/words_sample/mouse.png": ["animals"],
                            "lang/resource/words_sample/orange.png": ["fruits"],
                            "lang/resource/words_sample/raspberry.png": ["fruits"],
                            "lang/resource/words_sample/tongue.png": ["bodyParts"]
                        }
                    ]
                }, 
                {
                    "tags": ["alphabets"],
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/upperF.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerK.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerR.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/upperQ.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerB.svg": ["alphabets"],
                            "lang/resource/words_sample/seven.png": ["numbers"],
                            "lang/resource/words_sample/three.png": ["numbers"],
                            "lang/resource/words_sample/turtle.png": ["animals"],
                            "lang/resource/words_sample/melon.png": ["fruits"]
                        }
                    ]
                    
                },
                {
                    "tags": ["alphabets"],
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/lowerH.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/upperL.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/upperN.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/upperS.svg": ["alphabets"],
                            "lang/resource/words_sample/pear.png": ["fruits"],
                            "lang/resource/words_sample/butterfly.png": ["shapes"],
                            "lang/resource/words_sample/eight.png": ["numbers"],
                            "lang/resource/words_sample/eleven.png": ["numbers"],
                            "lang/resource/words_sample/one.png": ["numbers"]
                        }
                    ]
                },
                {
                    "tags": ["alphabets"],
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/lowerG.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerT.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/lowerK.svg": ["alphabets"],
                            "lang/resource/words_sample/eight.png": ["numbers"],
                            "lang/resource/words_sample/ten.png": ["numbers"],
                            "lang/resource/words_sample/dog.png": ["animals"]
                        }
                    ]
                },
                {
                    "tags": ["alphabets"],
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "upperA.svg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/upperD.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/upperJ.svg": ["alphabets"],
                            "lang/resource/words_sample/green.png": ["color"],
                            "lang/resource/words_sample/plum.png": ["animals"],
                            "lang/resource/words_sample/nine.png": ["numbers"],
                            "lang/resource/words_sample/cat.png": ["animals"]
                        }
                    ]
                }
            ]
        }
    ]
}
