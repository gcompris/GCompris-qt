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
            "name": qsTr("Fruits"),
            "image": imagesPrefix + "alphabets.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the FRUITS to the right and others to the left"),
                    "image": "Fruits",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["Banana","Orange","Grapes","Pear","Pineapple","Watermelon"],
                    "bad": ["Turnip","Onion","Taj Mahal","Carrot","car","house"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and others to the left"),
                    "image": "Fruits",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["Apple","Mango","Apricot","Lemon","Strawberry","Papaya"],
                    "bad": ["tomato","potato","pancakes","school","dive","cheese"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and others to the left"),
                    "image": "Fruits",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["Fig","Cherry","Avocado","Kiwi","Coconut"],
                    "bad": ["Lettuce","Maize","Beans","water","fries","milk"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and others to the left"),
                    "image": "Demonstrative Pronouns",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "",
                    "good": ["Peach","Blackberry","Grapefruit","Litchi"],
                    "bad": ["cat","walk","peas","cabbage","watch"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and others to the left"),
                    "image": "Fruits",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["Muskmelon","Olive","Raspberry"],
                    "bad": ["kitten","apple","lock"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and others to the left"),
                    "image": "Fruits",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["Watermelon","Pomegranate","Cranberry"],
                    "bad": ["dress","chicken","garlic"]
                },
                {
                    "instructions": qsTr("Place the FRUITS to the right and others to the left"),
                    "image": "Fruits",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["Tangerine","Guava"],
                    "bad": ["London","baseball","cd","spinach"]
                }
            ]
        }
    ]
}

