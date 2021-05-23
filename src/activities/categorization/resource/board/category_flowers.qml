/* GCompris
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
    property bool isEmbedded: false
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/data/words/flowers/"
    property var levels: [
        {
            "name": qsTr("Flowers"),
            "image": imagesPrefix + "bunchOfFlowers.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["flowers/allamanda.jpg", "flowers/angiosperms.jpg", "flowers/angiosperms2.jpg", "flowers/aster.jpg", "flowers/aster2.jpg", "flowers/bauhiniaAcuminata.jpg"],
                    "bad": ["plants/plant2.jpg", "birds/bird1.jpg", "insects/insect10.jpg", "transport/cycle.jpg", "animals/camel.jpg", "householdGoods/iron2.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["flowers/bossier.jpg", "flowers/bunchOfFlowers.jpg", "flowers/calendulaSuffruticosa.jpg", "flowers/camellia.jpg", "flowers/capullo.jpg", "flowers/crocus.jpg"],
                    "bad": ["nature/nature5.jpg", "food/biryani.jpg", "food/milk.jpg", "fruits/apple.jpg", "others/house.jpg", "vegetables/carrots.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["flowers/dahlia.jpg", "flowers/daisy.jpg", "flowers/floora.jpg", "flowers/floreInsectos.jpg", "flowers/galanthusNivalis.jpg", "flowers/hibiscus.jpg"],
                    "bad": ["animals/cow.jpg", "transport/helicopter1.jpg", "food/cereal.jpg", "animals/elephant.jpg", "others/pepsi.jpg", "plants/tree3.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["flowers/lily.jpg", "flowers/marigold.jpg", "flowers/orchid.jpg", "flowers/pollen.jpg", "flowers/rose.jpg"],
                    "bad": ["lobster.png", "potato.png", "pumpkin.png", "radio.png"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["flowers/sunflower.jpg", "flowers/tulip.jpg", "flowers/victoriaAmazonica.jpg", "flowers/wildPetunia.jpg"],
                    "bad": ["food/hotdog.jpg", "vegetables/onion.jpg", "food/cheese.jpg", "food/water.jpg", "others/street.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["flowers/lily.jpg", "flowers/marigold.jpg", "flowers/orchid.jpg", "flowers/pollen.jpg", "flowers/rose.jpg"],
                    "bad": ["food/eggs.jpg", "animals/lion.jpg", "birds/bird17.jpg", "householdGoods/iron.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["flowers/lotus.jpg", "flowers/jasmine.jpg", "flowers/rhododendron.jpg"],
                    "bad": ["food/grilledSandwich.jpg", "transport/metro.jpg", "food/frenchFries.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["flowers/ashoka.jpg", "flowers/acidanthera.jpg"],
                    "bad": ["others/fork.jpg", "fruits/apple.jpg", "food/skimmedMilk.jpg", "fruits/grapes.jpg"]
                },
                {
                    "instructions": qsTr("Place the FLOWERS to the right and other objects to the left"),
                    "image": imagesPrefix + "bunchOfFlowers.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 2,
                    "prefix": "qrc:/gcompris/data/words/",
                    "good": ["flowers/allamanda.jpg", "flowers/camellia.jpg", "flowers/jasmine.jpg", "flowers/marigold.jpg"],
                    "bad": ["plants/plant6.jpg", "fruits/papaya.jpg"]
                }
            ]
        }
    ]
}
