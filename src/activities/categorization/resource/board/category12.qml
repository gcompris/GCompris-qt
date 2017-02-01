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
    property string imagesPrefix: "qrc:/gcompris/data/words/shapes/"
    property variant levels: [
        {
            "type": "lesson",
            "name": qsTr("Shapes"),
            "image": imagesPrefix + "cube.JPG",
            "content": [
                {
                    "instructions": qsTr("Place the objects matching CIRCLE to the right and others to the left"),
                    "image": imagesPrefix + "circle.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/cd.svg","shapes/clock.svg","shapes/coin.svg","ball.png","shapes/cookie.svg"],
                    "bad": ["shapes/backcard.svg","shapes/can.svg","shapes/can1.svg","shapes/conehat.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching RECTANGLE to right and others to the left"),
                    "image": imagesPrefix + "rectangle.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/paper.svg","shapes/rectangle_led.svg","shapes/backcard.svg","shapes/slate.svg","shapes/diceface.svg"],
                    "bad": ["shapes/icecream.svg","shapes/icecube.svg","shapes/juice1.svg","strainer.png"]
                },
                {
                    "instructions": qsTr("Place the objects matching HEMISPHERE to right and others to the left"),
                    "image": imagesPrefix + "hemisphere.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/halforange.svg","shapes/bowl.svg","shapes/bowl1.svg","shapes/bowl2.svg"],
                    "bad": ["shapes/football.svg","shapes/watermelon.svg","shapes/sunrise.svg","shapes/juice2.svg","shapes/icecube.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching TRAPEZIUM to right and others to the left"),
                    "image": imagesPrefix + "trapezium.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/trapezium2.svg","shapes/trapezium3.svg","shapes/trapezium1.svg","shapes/kite.svg"],
                    "bad": ["shapes/rhombus1.svg","shapes/pgram2.svg","shapes/icecube.svg","shapes/juice1.svg","shapes/square.png"]
                },
                {
                    "instructions": qsTr("Place the objects matching TRIANGLE to right and others to the left"),
                    "image": imagesPrefix + "triangle.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/pizza.svg","shapes/trianglehat.svg","shapes/warning.svg","shapes/warning1.svg"],
                    "bad": ["shapes/sun.svg","shapes/sunrays.svg","tape_measure.png","shapes/trapezium1.svg","shapes/rainbowsquare.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching SEMICIRCLE to right and others to the left"),
                    "image": imagesPrefix + "semicircle.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/fan.svg","shapes/halfmoon.svg","shapes/sunrise.svg","shapes/rainbow.svg"],
                    "bad": ["shapes/diceface.svg","shapes/tin.png","shapes/torch.png","shapes/trianglehat.svg","trap.png"]
                },
                {
                    "instructions": qsTr("Place the objects matching PENTAGON to right and others to the left"),
                    "image": imagesPrefix + "pentagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/pentagon1.svg","shapes/pentagon2.svg","shapes/pentagon3.svg","shapes/pentagon4.svg"],
                    "bad": ["shapes/nonagon1.svg","shapes/trianglehat.svg","shapes/rainbowsquare.svg","shapes/paper.svg","shapes/hexagon1.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching SQUARE to right and others to the left"),
                    "image": imagesPrefix + "rectangle.svg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/rsquare.svg","shapes/rainbowsquare.svg","shapes/square.png","shapes/squareclock.svg","shapes/stickynote.svg"],
                    "bad": ["shapes/shapes.png","shapes/slate.svg","glass.png","shapes/globe.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching CONE to right and others to the left"),
                    "image": imagesPrefix + "cone.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/icecone.svg","shapes/ice_cream.png","shapes/wcone.svg","shapes/torch.png","shapes/icecream.svg","shapes/conehat.svg"],
                    "bad": ["flour.png","shapes/yellowtriangle.svg","shapes/glass.svg","shapes/sugar.png","book.png","shapes/dice.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching PARELLELOGRAM to right and others to the left"),
                    "image": imagesPrefix + "parallelogram.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/shapes/",
                    "good": ["pgram1.svg","pgram2.svg","pgram3.svg","pgram4.svg"],
                    "bad": ["rsquare.svg","rainbowsquare.svg","paper.svg","rectangle_led.svg","rhombus4.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching HEPTAGON to right and others to the left"),
                    "image": imagesPrefix + "heptagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/shapes/",
                    "good": ["heptagon1.svg","heptagon2.svg","heptagon3.svg","heptagon4.svg"],
                    "bad": ["nonagon4.svg","octagon1.svg","decagon2.svg","pentagon1.svg","hexagon4.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching CUBE to right and others to the left"),
                    "image": imagesPrefix + "cube.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/icecube.svg","shapes/sugar.png","shapes/cube1.svg","shapes/dice.svg","shapes/rubikscube.svg","shapes/rubikscube1.svg"],
                    "bad": ["shapes/juice2.svg","mattress.png","shapes/squareclock.svg","shapes/stickynote.svg","shapes/backcard.svg","shapes/diceface.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching RHOMBUS to right and others to the left"),
                    "image": imagesPrefix + "rhombus.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/shapes/",
                    "good": ["rhombus1.svg","rhombus2.svg","rhombus3.svg","rhombus4.svg"],
                    "bad": ["squareclock.svg","stickynote.svg","backcard.svg","pgram1.svg","diceface.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching NONAGON to right and others to the left"),
                    "image": imagesPrefix + "nonagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/shapes/",
                    "good": ["nonagon1.svg","nonagon4.svg","nonagon2.svg","nonagon3.svg"],
                    "bad": ["pgram2.svg","diceface.svg","octagon2.svg","decagon1.svg","decagon2.svg"],
                },
                {
                    "instructions": qsTr("Place the objects matching CUBOID to right and others to the left"),
                    "image": imagesPrefix + "cuboid.svg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/juice2.svg","mattress.png","radio.png","shapes/rectbin.svg","book.png","trap.png"],
                    "bad": ["shapes/dice.svg","shapes/rubikscube.svg","shapes/rectangle_led.svg","shapes/slate.svg","shapes/rsquare.svg","shapes/rainbowsquare.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching HEXAGON to right and others to the left"),
                    "image": imagesPrefix + "hexagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/shapes/",
                    "good": ["hexagon2.svg","hexagon3.svg","hexagon4.svg","hexagon1.svg"],
                    "bad": ["rhombus1.svg","pgram2.svg","heptagon1.svg","pentagon3.svg","trapezium2.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching OCTAGON to right and others to the left"),
                    "image": imagesPrefix + "octagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/shapes/",
                    "good": ["octagon2.svg","octagon3.svg","octagon4.svg","octagon1.svg"],
                    "bad": ["rectangle_led.svg","decagon2.svg","hexagon2.svg","heptagon1.svg","nonagon2.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching CYLINDER to right and others to the left"),
                    "image": imagesPrefix + "cylinder.svg",
                    "maxNumberOfGood": 7,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["shapes/rolling_pin.png","spool.png","shapes/bin.png","bucket.png","shapes/can.svg","shapes/gascylinder.svg","shapes/glass.svg"],
                    "bad": ["shapes/halforange.svg","radio.png","shapes/sugar.png","shapes/ice_cream.png","shapes/juice2.svg"]
                },
                {
                    "instructions": qsTr("Place the objects matching DECAGON to right and others to the left"),
                    "image": imagesPrefix + "decagon.svg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/shapes/",
                    "good": ["decagon3.svg","decagon4.svg","decagon1.svg","decagon2.svg"],
                    "bad": ["hexagon2.svg","nonagon1.svg","nonagon4.svg","octagon2.svg","heptagon1.svg"]
                }
            ]
        }
    ]
}
