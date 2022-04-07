/* GCompris
 *
 * SPDX-FileCopyrightText: 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject{
    property bool isEmbedded: false
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Colors"),
            "image": imagesPrefix + "others/color2.webp",
            "content": [
                {
                    "instructions": qsTr("Place the objects matching GREEN color to the right and others to the left"),
                    "image": imagesPrefix + "green.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["artichoke.webp","cabbage.webp","cucumber.webp","cactus.webp","clover.webp"],
                    "bad": ["left.webp","lobster.webp","mail.webp","post.webp"]
                },
                {
                    "instructions": qsTr("Place the objects matching WHITE color to the right and others to the left"),
                    "image": imagesPrefix + "white.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["milk.webp","paper.webp","dove.webp","mail.webp","egg.webp", "garlic.webp"],
                    "bad": ["flash.webp","plum.webp","potato.webp","pumpkin.webp","rabbit.webp","kiwi.webp"]
                },
                {
                    "instructions": qsTr("Place the objects matching PINK color to the right and others to the left"),
                    "image": imagesPrefix + "pink.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["hair_dryer.webp","flamingo.webp","raspberry.webp","pencil.webp","flash.webp"],
                    "bad": ["ink.webp","kiwi.webp","ladybug.webp","phone.webp"]
                },
                {
                    "tags": ["red"],
                    "instructions": qsTr("Place the objects matching RED color to the right and others to the left"),
                    "image": imagesPrefix + "red.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["shapes/dice.svg","lobster.webp","pair.webp","ladybug.webp","post.webp"],
                    "bad": ["shapes/halforange.svg","radio.webp","ramp.webp","wheat.webp"]
                },
                {
                    "instructions": qsTr("Place the objects matching BROWN color to the right and others to the left"),
                    "image": imagesPrefix + "brown.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["shapes/cookie.svg","date_fruit.webp","chocolate.webp","board.webp","potato.webp","kiwi.webp"],
                    "bad": ["cheese.webp","bright.webp","shapes/conehat.svg","dolphin.webp","shapes/cd.svg","drip.webp"]
                },
                {
                    "instructions": qsTr("Place the objects matching PURPLE color to the right and others to the left"),
                    "categorise": "PURPLE",
                    "image": imagesPrefix + "others/purple.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["grape.webp","eggplant.webp","shapes/conehat.svg","phone.webp","plum.webp","ink.webp"],
                    "bad": ["bulb.webp","bell.webp","blackbird.webp","umbrella.webp","pumpkin.webp","shapes/halfmoon.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching GREY color to the right and others to the left"),
                    "image": imagesPrefix + "gray.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["chain.webp","rabbit.webp","ramp.webp","dolphin.webp","faucet.webp","shapes/halfmoon.svg"],
                    "bad": ["shapes/backcard.svg","radio.webp","clover.webp","left.webp","flash.webp","ink.webp"]
                },
                {
                    "instructions": qsTr("Place the objects matching ORANGE color to the right and others to the left"),
                    "image": imagesPrefix + "orange-color.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["pumpkin.webp","shapes/halforange.svg","orange.webp"],
                    "bad": ["plum.webp","potato.webp","post.webp"]
                },
                {
                    "instructions": qsTr("Place the objects matching YELLOW color to the right and others to the left"),
                    "categorise":"YELLOW",
                    "image": imagesPrefix + "yellow.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["anchor.webp","cheese.webp","bright.webp","shapes/rectangle_led.svg","bulb.webp","bell.webp"],
                    "bad": ["blackbird.webp","pair.webp","plum.webp","potato.webp","drip.webp","ladybug.webp"]
                }
            ]
        }
    ]
}
