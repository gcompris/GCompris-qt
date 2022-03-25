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

QtObject {
    property bool isEmbedded: true
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/fishes/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Fishes"),
            "image": imagesPrefix + "fish20.webp",
            "content": [
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish10.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish1.webp","fishes/fish2.webp","fishes/fish3.webp","fishes/fish4.webp","fishes/fish5.webp","fishes/fish6.webp"],
                    "bad": ["monuments/brandenburgGate.webp","monuments/burj.webp","others/bulb.webp","tools/cuttingTool.webp","others/knife.webp","tools/multimeter2.webp"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish13.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish7.webp","fishes/fish8.webp","fishes/fish9.webp","fishes/fish10.webp","fishes/fish11.webp","fishes/fish12.webp"],
                    "bad": ["renewable/dam2.webp","renewable/solar5.webp","others/pillow.webp","tools/plier1.webp","tools/nailCutter.webp","monuments/colosseum.webp"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish3.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish13.webp","fishes/fish14.webp","fishes/fish15.webp","fishes/fish16.webp","fishes/fish17.webp"],
                    "bad": ["others/bulb.webp","others/chair.webp","renewable/windmill.webp","monuments/monument2.webp"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish16.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish18.webp","fishes/fish19.webp","fishes/fish20.webp","fishes/fish21.webp",
                            "fishes/fish22.webp"],
                    "bad": ["others/plate.webp","monuments/operaHouse.webp","monuments/zimniPalace.webp","renewable/geothermal.webp"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish20.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish23.webp","fishes/fish24.webp", "fishes/fish25.webp"],
                    "bad": ["monuments/monument3.webp","others/pan.webp","others/pencil.webp"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish25.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish26.webp","fishes/fish27.webp","fishes/fish28.webp"],
                    "bad": ["renewable/windmill13.webp","renewable/geothermal.webp","tools/scissors1.webp"]
                }
            ]
        }
    ]
}
