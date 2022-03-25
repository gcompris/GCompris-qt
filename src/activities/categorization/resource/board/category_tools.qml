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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/tools/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Tools"),
            "image": imagesPrefix + "measuringTape6.webp",
            "content": [
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "wrench.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/hammer8.webp", "tools/hammer9.webp","tools/hammer6.webp","tools/hammer7.webp","tools/hammer1.webp","tools/hammer2.webp"],
                    "bad": ["monuments/arcDeTriomphe.webp","others/buffetset.webp","monuments/cathedral.webp","others/pillow.webp","renewable/windmill1.webp", "renewable/geothermal.webp"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "sideCutter1.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/measuringTape5.webp","tools/measuringTape1.webp","tools/plier3.webp","tools/plier1.webp","tools/measuringTape3.webp","tools/measuringTape4.webp"],
                    "bad": ["others/pan.webp","others/blackslate.webp","monuments/colosseum.webp","fishes/fish10.webp","renewable/dam1.webp","monuments/monument3.webp"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "scissors4.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/scissors1.webp","tools/scissors2.webp","tools/scissors3.webp","tools/spray.webp","tools/tweezer.webp","tools/wrench1.webp"],
                    "bad": ["others/buffetset.webp","monuments/brandenburgGate.webp","monuments/parthenon.webp","fishes/fish12.webp","fishes/fish16.webp","others/plate.webp"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "spray.webp",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/spray.webp","tools/screwDriver.webp","tools/screwDriver1.webp","tools/screwDriver2.webp","tools/screwDriver3.webp","tools/plier1.webp"],
                    "bad": ["others/baseball.webp","others/igloo.webp","monuments/mountRushmore.webp","renewable/dam3.webp","monuments/greatWall.webp","renewable/windmill7.webp"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "plier1.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/multimeter1.webp","tools/screwDriver.webp","tools/hammer3.webp","tools/measuringTape6.webp","tools/plier3.webp"],
                    "bad": ["fishes/fish25.webp","fishes/fish18.webp","monuments/monument1.webp","monuments/monument2.webp"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "plier1.webp",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/wrench.webp","tools/tweezer1.webp","tools/sickle.webp","tools/plier2.webp","tools/sideCutter1.webp"],
                    "bad": ["renewable/solar5.webp","others/bulb.webp","renewable/dam3.webp","monuments/operaHouse.webp"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "multimeter2.webp",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/plier3.webp","tools/scissors1.webp","tools/plier2.webp","tools/sideCutter1.webp"],
                    "bad": ["fishes/fish3.webp","others/chair.webp","monuments/operaHouse.webp","renewable/windmill12.webp","monuments/IndiaGate.webp"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "nailCutter.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/measuringTape2.webp","tools/hammer5.webp","tools/plier1.webp"],
                    "bad": ["fishes/fish6.webp","monuments/tajMahal.webp","renewable/solar3.webp"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "screwDriver.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/plier3.webp","tools/multimeter3.webp","tools/nailCutter.webp"],
                    "bad": ["fishes/fish10.webp","others/pan.webp","others/igloo.webp"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "scissors2.webp",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/hammer4.webp","tools/screwDriver.webp","tools/multimeter2.webp"],
                    "bad": ["renewable/dam2.webp","monuments/leaningTowerOfPisa.webp", "others/pillow.webp"]
                }
            ]
        }
    ]
}
