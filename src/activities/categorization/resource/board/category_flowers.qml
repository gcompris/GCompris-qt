/* GCompris
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
    property bool isEmbedded: false
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/data/words-webp/flowers/"
    property var levels: [
        {
            "name": qsTr("Flowers"),
            "image": imagesPrefix + "bunchOfFlowers.webp",
            "content": [
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["flowers/allamanda.webp", "flowers/angiosperms.webp", "flowers/angiosperms2.webp", "flowers/aster.webp", "flowers/aster2.webp", "flowers/bauhiniaAcuminata.webp"],
                    "bad": ["plants/plant2.webp", "birds/bird1.webp", "insects/insect10.webp", "transport/cycle.webp", "animals/camel.webp", "householdGoods/iron2.webp"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["flowers/bossier.webp", "flowers/bunchOfFlowers.webp", "flowers/calendulaSuffruticosa.webp", "flowers/camellia.webp", "flowers/capullo.webp", "flowers/crocus.webp"],
                    "bad": ["nature/nature5.webp", "food/biryani.webp", "food/milk.webp", "fruits/apple.webp", "others/house.webp", "vegetables/carrots.webp"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["flowers/dahlia.webp", "flowers/daisy.webp", "flowers/floora.webp", "flowers/floreInsectos.webp", "flowers/galanthusNivalis.webp", "flowers/hibiscus.webp"],
                    "bad": ["animals/cow.webp", "transport/helicopter1.webp", "food/cereal.webp", "animals/elephant.webp", "others/pepsi.webp", "plants/tree3.webp"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["flowers/lily.webp", "flowers/marigold.webp", "flowers/orchid.webp", "flowers/pollen.webp", "flowers/rose.webp"],
                    "bad": ["lobster.webp", "potato.webp", "pumpkin.webp", "radio.webp"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["flowers/sunflower.webp", "flowers/tulip.webp", "flowers/victoriaAmazonica.webp", "flowers/wildPetunia.webp"],
                    "bad": ["food/hotdog.webp", "vegetables/onion.webp", "food/cheese.webp", "food/water.webp", "others/street.webp"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["flowers/lily.webp", "flowers/marigold.webp", "flowers/orchid.webp", "flowers/pollen.webp", "flowers/rose.webp"],
                    "bad": ["food/eggs.webp", "animals/lion.webp", "birds/bird17.webp", "householdGoods/iron.webp"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["flowers/lotus.webp", "flowers/jasmine.webp", "flowers/rhododendron.webp"],
                    "bad": ["food/grilledSandwich.webp", "transport/metro.webp", "food/frenchFries.webp"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.webp",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["flowers/ashoka.webp", "flowers/acidanthera.webp"],
                    "bad": ["others/fork.webp", "fruits/apple.webp", "food/skimmedMilk.webp", "fruits/grapes.webp"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 2,
                    "prefix": "qrc:/gcompris/data/words-webp/",
                    "good": ["flowers/allamanda.webp", "flowers/camellia.webp", "flowers/jasmine.webp", "flowers/marigold.webp"],
                    "bad": ["plants/plant6.webp", "fruits/papaya.webp"]
                }
            ]
        }
    ]
}
