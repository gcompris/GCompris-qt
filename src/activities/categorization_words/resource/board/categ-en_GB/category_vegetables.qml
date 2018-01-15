
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
    property bool isEmbedded: true
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/alphabets/"
    property variant levels: [
        {
            "name": qsTr("Vegetables"),
            "image": imagesPrefix + "alphabets.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and others to the left"),
                    "image": "Vegetables",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["Tomato","Onion","Potato","Carrot","Eggplant","Cabbage"],
                    "bad": ["apple","mango","orange","guava","cheese","wood"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and others to the left"),
                    "image": "Vegetables",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["Cucumber","Pea","Cauliflower","Radish","Spinach","Garlic"],
                    "bad": ["muskmellon","peach","fig","cranberry","mobile","study"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and others to the left"),
                    "image": "Vegetables",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["Turnip","Maize","Celery","Broccoli","Beans"],
                    "bad": ["color","jacket","food","kiwi","table","risk"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and others to the left"),
                    "image": "Demonstrative Pronouns",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "",
                    "good": ["Lettuce","Zucchini","Pepper","Asparagus"],
                    "bad": ["hands","spoon","duck","cookies","pomogrenate"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and others to the left"),
                    "image": "Vegetables",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["sweet potato","mushroom","Ladyfinger"],
                    "bad": ["tangerine","ice-cream","papaya"]
                },
                {
                    "instructions": qsTr("Place the VEGETABLES to the right and others to the left"),
                    "image": "Vegetables",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["Artichoke","Bottle guard","Coriander"],
                    "bad": ["apricot","boat","boy"]
                }
            ]
        }
    ]
}

