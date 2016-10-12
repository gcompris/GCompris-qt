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
                    "image": imagesPrefix + "A.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/A.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/p.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/R.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/t.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/d.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/e.svg": ["alphabets"],
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
                    "image": imagesPrefix + "A.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/b.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/V.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/e.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/n.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/M.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/O.svg": ["alphabets"],
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
                    "image": imagesPrefix + "A.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/F.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/k.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/r.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/Q.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/b.svg": ["alphabets"],
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
                    "image": imagesPrefix + "A.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/h.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/L.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/N.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/s.svg": ["alphabets"],
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
                    "image": imagesPrefix + "A.svg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/g.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/t.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/k.svg": ["alphabets"],
                            "lang/resource/words_sample/eight.png": ["numbers"],
                            "lang/resource/words_sample/ten.png": ["numbers"],
                            "lang/resource/words_sample/dog.png": ["animals"]
                        }
                    ]
                },
                {
                    "tags": ["alphabets"],
                    "instructions": qsTr("Place the ALPHABETS to the right and other objects to the left"),
                    "image": imagesPrefix + "A.svg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "levelImages": [
                        {
                            "categorization/resource/images/alphabets/D.svg": ["alphabets"],
                            "categorization/resource/images/alphabets/J.svg": ["alphabets"],
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
