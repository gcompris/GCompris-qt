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
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/shapes/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Shapes"),
            "image": imagesPrefix + "cube.webp",
            "content": [
                {
                    "instructions": qsTr("Place the objects matching a CIRCLE to the right and others to the left"),
                    "image": imagesPrefix + "circle.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["cd.svg","clock.svg","coin.svg","globe.svg","smile.svg"],
                    "bad": ["backcard.svg","can.svg","can1.svg","conehat.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a RECTANGLE to the right and others to the left"),
                    "image": imagesPrefix + "rectangle.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["paper.svg","rectangle_led.svg","stickynote.svg","rainbowsquare.svg"],
                    "bad": ["cylinder.svg","icecream.svg","trapezium.svg","trash.svg","pizza.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a SPHERE to the right and others to the left"),
                    "image": imagesPrefix + "sun.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["shapes/football.svg","shapes/globe.svg","ball.webp","shapes/watermelon.svg"],
                    "bad": ["shapes/cone.svg","shapes/halforange.svg","shapes/sunrise.svg","shapes/juice2.svg","shapes/icecube.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a TRAPEZOID to the right and others to the left"),
                    "image": imagesPrefix + "trapezium.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["trapezium2.svg","trapezium4.svg","trapezium3.svg","rectangle.svg","rhombus1.svg"],
                    "bad": ["cube.svg","dice.svg","rectbin.svg","yellowtriangle.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a TRIANGLE to the right and others to the left"),
                    "image": imagesPrefix + "triangle.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["yellowtriangle.svg","trianglehat.svg","warning.svg","warning1.svg"],
                    "bad": ["sun.svg","cookie.svg","rhombus2.svg","trapezium2.svg","semicircle.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a SEMICIRCLE to the right and others to the left"),
                    "image": imagesPrefix + "semicircle.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["fan.svg","halfmoon.svg","sunrise.svg","rainbow.svg"],
                    "bad": ["diceface.svg","watermelon.svg","squareclock.svg","trianglehat.svg","circle.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a PENTAGON to the right and others to the left"),
                    "image": imagesPrefix + "pentagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["shapes/pentagon1.svg","shapes/pentagon2.svg","shapes/pentagon3.svg","shapes/pentagon4.svg"],
                    "bad": ["shapes/nonagon1.svg","shapes/trianglehat.svg","shapes/rainbowsquare.svg","shapes/paper.svg","shapes/hexagon1.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a SQUARE to the right and others to the left"),
                    "image": imagesPrefix + "rhombus.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["rsquare.svg","rainbowsquare.svg","ledsquare.svg","stickynote.svg"],
                    "bad": ["trapezium.svg","slate.svg","rhombus4.svg","globe.svg","parallelogram.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a CONE to the right and others to the left"),
                    "image": imagesPrefix + "cone.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["ice_cream.webp","icecone.svg","icecream.svg","conehat.svg"],
                    "bad": ["semicircle.svg","glass.svg","bowl3.svg","halforange.svg","dice.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a PARALLELOGRAM to the right and others to the left"),
                    "image": imagesPrefix + "parallelogram.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["pgram1.svg","pgram2.svg","pgram3.svg","paper.svg","rectangle_led.svg",],
                    "bad": ["globe.svg","heptagon.svg","pizza.svg","trapezium4.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a HEPTAGON to the right and others to the left"),
                    "image": imagesPrefix + "heptagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["heptagon1.svg","heptagon2.svg","heptagon3.svg","heptagon4.svg"],
                    "bad": ["nonagon4.svg","octagon1.svg","decagon2.svg","pentagon1.svg","hexagon4.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a CUBE to the right and others to the left"),
                    "image": imagesPrefix + "cube.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["icecube.svg","cube1.svg","dice.svg","rubikscube.svg","rubikscube1.svg"],
                    "bad": ["juice2.svg","cuboid1.svg","stickynote.svg","backcard.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a RHOMBUS to the right and others to the left"),
                    "image": imagesPrefix + "rhombus1.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["rainbowsquare.svg","rhombus2.svg","ledsquare.svg","rhombus4.svg"],
                    "bad": ["hexagon.svg","parallelogram.svg","pentagon4.svg","pgram1.svg","trapezium2.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a NONAGON to the right and others to the left"),
                    "image": imagesPrefix + "nonagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["nonagon1.svg","nonagon4.svg","nonagon2.svg","nonagon3.svg"],
                    "bad": ["pgram2.svg","diceface.svg","octagon2.svg","decagon1.svg","decagon2.svg"],
                },
                {
                    "instructions": qsTr("Place the objects matching a CUBOID to the right and others to the left"),
                    "image": imagesPrefix + "cuboid.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["dice.svg","rubikscube.svg","cuboid1.svg","juice2.svg","cube1.svg"],
                    "bad": ["backcard.svg","cone.svg","pizza.svg","trash.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a HEXAGON to the right and others to the left"),
                    "image": imagesPrefix + "hexagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["hexagon2.svg","hexagon3.svg","hexagon4.svg","hexagon1.svg"],
                    "bad": ["rhombus1.svg","pgram2.svg","heptagon1.svg","pentagon3.svg","trapezium2.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching an OCTAGON to the right and others to the left"),
                    "image": imagesPrefix + "octagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["octagon2.svg","octagon3.svg","octagon4.svg","octagon1.svg"],
                    "bad": ["rectangle_led.svg","decagon2.svg","hexagon2.svg","heptagon1.svg","nonagon2.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a CYLINDER to the right and others to the left"),
                    "image": imagesPrefix + "cylinder.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["rolling_pin.webp","tin.webp","can1.svg","can.svg", "trash.svg"],
                    "bad": ["halforange.svg","decagon3.svg","wcone.svg","juice2.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching a DECAGON to the right and others to the left"),
                    "image": imagesPrefix + "decagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/shapes/",
                    "good": ["decagon3.svg","decagon4.svg","decagon1.svg","decagon2.svg"],
                    "bad": ["hexagon2.svg","nonagon1.svg","nonagon4.svg","octagon2.svg","heptagon1.svg"]
                }
            ]
        }
    ]
}
