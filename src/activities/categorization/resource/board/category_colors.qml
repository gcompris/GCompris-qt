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

QtObject{
    property bool isEmbedded: false
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/data/words/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Colors"),
            "image": imagesPrefix + "others/color2.png",
            "content": [
                {
                    "instructions": "Place the objects matching GREEN color to right and others to the left",
                    "image": imagesPrefix + "green.png",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["artichoke.png","cabbage.png","cucumber.png","cactus.png","clover.png"],
                    "bad": ["left.png","lobster.png","mail.png","post.png"]
                },
                {
                    "instructions": "Place the objects matching WHITE color to right and others to the left",
                    "image": imagesPrefix + "white.png",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["milk.png","paper.png","dove.png","mail.png","egg.png", "bead.png"],
                    "bad": ["flash.png","plum.png","potato.png","pumpkin.png","rabbit.png","kiwi.png"]
                },
                {
                    "instructions": "Place the objects matching PINK color to right and others to the left",
                    "image": imagesPrefix + "pink.png",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["hair_dryer.png","flamingo.png","raspberry.png","pencil.png","flash.png"],
                    "bad": ["ink.png","kiwi.png","ladybug.png","phone.png"]
                },
                {
                    "tags": ["red"],
                    "instructions": "Place the objects matching RED color to right and others to the left",
                    "image": imagesPrefix + "red.png",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/dice.svg","lobster.png","pair.png","ladybug.png","post.png"],
                    "bad": ["shapes/halforange.svg","radio.png","ramp.png","wheat.png"]
                },
                {
                    "instructions": "Place the objects matching BROWN color to right and others to the left",
                    "image": imagesPrefix + "brown.png",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/cookie.svg","date_fruit.png","chocolate.png","board.png","potato.png","kiwi.png"],
                    "bad": ["cheese.png","bright.png","shapes/conehat.svg","dolphin.png","shapes/cd.svg","drip.png"]
                },
                {
                    "instructions": "Place the objects matching PURPLE color to right and others to the left",
                    "categorise": "PURPLE",
                    "image": imagesPrefix + "others/purple.png",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["grape.png","eggplant.png","shapes/conehat.svg","phone.png","plum.png","ink.png"],
                    "bad": ["bulb.png","bell.png","blackbird.png","umbrella.png","pumpkin.png","shapes/halfmoon.svg"]
                },
                {
                    "instructions": "Place the objects matching GREY color to right and others to the left",
                    "image": imagesPrefix + "gray.png",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["chain.png","rabbit.png","ramp.png","dolphin.png","faucet.png","shapes/halfmoon.svg"],
                    "bad": ["shapes/backcard.svg","radio.png","clover.png","left.png","flash.png","ink.png"]
                },
                {
                    "instructions": "Place the objects matching ORANGE color to right and others to the left",
                    "image": imagesPrefix + "orange-color.png",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["pumpkin.png","shapes/halforange.svg","orange.png"],
                    "bad": ["plum.png","potato.png","post.png"]
                },
                {
                    "instructions": "Place the objects matching YELLOW color to right and others to the left",
                    "categorise":"YELLOW",
                    "image": imagesPrefix + "yellow.png",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["anchor.png","cheese.png","bright.png","shapes/rectangle_led.svg","bulb.png","bell.png"],
                    "bad": ["blackbird.png","pair.png","plum.png","potato.png","drip.png","ladybug.png"]
                }
            ]
        }
    ]
}
