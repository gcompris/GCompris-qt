/* GCompris
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
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

QtObject {
    property bool isEmbedded: true
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/flowers/"
    property var levels: [
        {
            "name": qsTr("Flowers"),
            "image": imagesPrefix + "rose.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/flowers/allamanda.jpg", "categorization/resource/images/flowers/angiosperms.jpg", "categorization/resource/images/flowers/angiosperms2.jpg", "categorization/resource/images/flowers/aster.jpg", "categorization/resource/images/flowers/aster2.jpg", "categorization/resource/images/flowers/bauhiniaAcuminata.jpg"],
                    "bad": ["categorization/resource/images/alphabets/upperZ.svg", "lang/resource/words_sample/fruit.png", "lang/resource/words_sample/mosquito.png", "lang/resource/words_sample/coconut.png", "lang/resource/words_sample/dolphin.png", "lang/resource/words_sample/kiwi.png"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["flowers/bossier.jpg", "flowers/bunchOfFlowers.jpg", "flowers/calendulaSuffruticosa.jpg", "flowers/camellia.jpg", "flowers/capullo.jpg", "flowers/crocus.jpg"],
                    "bad": ["monuments/beandenburgGate.jpg", "monuments/burj.jpg", "others/bulb.jpg", "tools/cutingTool.jpg", "others/knife.jpg", "tools/multimeter.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["flowers/dahlia.jpg", "flowers/daisy.jpg", "flowers/floora.jpg", "flowers/floreInsectos.jpg", "flowers/galanthusNivalis.jpg", "flowers/hibiscus.jpg"],
                    "bad": ["fishes/fish3.jpg", "fishes/fish5.jpg", "renewable/dam2.jpg", "others/spoons.jpg", "others/igloo.jpg", "tools/measuringTape.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/flowers/lily.jpg", "categorization/resource/images/flowers/marigold.jpg", "categorization/resource/images/flowers/orchid.jpg", "categorization/resource/images/flowers/pollen.jpg", "categorization/resource/images/flowers/rose.jpg"],
                    "bad": ["categorization/resource/images/alphabets/upperZ.svg", "categorization/resource/images/alphabets/lowerH.svg", "lang/resource/words_sample/mosquito.png", "lang/resource/words_sample/fruit.png"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["flowers/sunflower.jpg", "flowers/tulip.jpg", "flowers/victoriaAmazonica.jpg", "flowers/wildPetunia.jpg"],
                    "bad": ["fishes/fish7.jpg", "fishes/fish16.jpg", "tools/hammer4.jpg", "tools/sprinkler.jpg", "renewable/solar5.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/",
                    "good": ["categorization/resource/images/flowers/lily.jpg", "categorization/resource/images/flowers/marigold.jpg", "categorization/resource/images/flowers/orchid.jpg", "categorization/resource/images/flowers/pollen.jpg", "categorization/resource/images/flowers/rose.jpg"],
                    "bad": ["lang/resource/words_sample/mosquito.png", "lang/resource/words_sample/fruit.png", "lang/resource/words_sample/color.png", "lang/resource/words_sample/strawberry.png"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["flowers/lotus.jpg", "flowers/jasmine.jpg", "flowers/rhododendron.jpg"],
                    "bad": ["others/plate.jpg", "fishes/fish18.jpg", "monuments/leMusee.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["flowers/ashoka.jpg", "flowers/acidanthera.jpg"],
                    "bad": ["fishes/fish6.jpg", "fishes/fish3.jpg", "others/pan.jpg", "others/spoons.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 2,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["flowers/allamanda.jpg", "flowers/camellia.jpg", "flowers/jasmine.jpg", "flowers/marigold.jpg"],
                    "bad": ["others/baseball.jpg", "monuments/arcDeTriomphe.jpg"]
                }
            ]
        }
    ]
}
