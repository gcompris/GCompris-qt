/* GCompris
 *
 * SPDX-FileCopyrightText: 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
    property bool isEmbedded: true
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/tools/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Tools"),
            "image": imagesPrefix + "measuringTape.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "wrench.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/clawHammer.jpg", "tools/clawHammer1.jpg","tools/estwingHammer.jpg","tools/framingHammer.jpg","tools/hammer1.jpg","tools/hammer2.jpg"],
                    "bad": ["monuments/arcDeTriomphe.jpg","others/buffetset.jpg","monuments/cathedral.jpg","others/pillow.jpg","renewable/windmill1.jpg", "renewable/geothermal.jpg"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "sideCutter1.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/measuringTape.jpeg","tools/measuringTape1.jpg","tools/nosePlier.jpg","tools/nosePlier1.jpg","tools/measuringTape3.jpg","tools/measuringTape4.jpg"],
                    "bad": ["others/pan.jpg","others/blackslate.jpg","monuments/colosseum.jpg","fishes/fish10.jpg","renewable/dam1.jpg","monuments/monument3.jpg"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "scissors.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/scissor1.jpg","tools/scissor2.jpg","tools/scissors.jpg","tools/sprinkler.jpg","tools/tweezer.jpg","tools/wrench1.jpg"],
                    "bad": ["others/buffetset.jpg","monuments/beandenburgGate.jpg","monuments/parthenon.jpg","fishes/fish12.jpg","fishes/fish16.jpg","others/plate.jpg"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "sprinkler.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/sprinkler.jpg","tools/screwDriver.jpg","tools/screwDriver1.jpg","tools/screwDriver2.jpg","tools/screwDriver3.jpg","tools/plier.jpg"],
                    "bad": ["others/baseball.jpg","others/igloo.jpg","monuments/mountRushmore.jpg","renewable/dam3.jpg","monuments/greatWall.jpg","renewable/windmill7.jpg"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "plier.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/multimeter.jpg","tools/screwDriver.jpg","tools/hammer3.jpg","tools/measuringTape.jpg","tools/nosePlier.jpg"],
                    "bad": ["fishes/fish25.jpg","fishes/fish18.jpg","monuments/monument1.jpg","monuments/monument2.jpg"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "nosePlier2.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/wrench.jpg","tools/tweezer1.jpg","tools/sickle.jpg","tools/plier.jpg","tools/sideCutter1.jpg"],
                    "bad": ["renewable/solar5.jpg","others/bulb.jpg","renewable/dam3.jpg","monuments/leninMuseum.jpg"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "multimeter.jpg",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/nosePlier3.jpg","tools/scissor.jpg","tools/plier2.jpg","tools/sideCutter1.jpg"],
                    "bad": ["fishes/fish3.jpg","others/chair.jpg","monuments/operaHouse.jpg","renewable/windmill12.jpg","monuments/IndiaGate.jpg"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "nailCutter.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/measuringTape2.jpg","tools/hammer5.jpg","tools/plier1.jpg"],
                    "bad": ["fishes/fish6.jpg","monuments/tajMahal.jpg","renewable/solar3.jpg"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "screwDriver.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/nosePlier2.jpg","tools/multimeter2.jpg","tools/nailCutter.jpg"],
                    "bad": ["fishes/fish10.jpg","others/pan.jpg","others/igloo.jpg"]
                },
                {
                    "instructions": qsTr("Place the TOOLS to the right and other objects to the left"),
                    "image": imagesPrefix + "scissor.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["tools/hammer4.jpg","tools/screwDriver.jpg","tools/multimeter1.jpg"],
                    "bad": ["renewable/dam2.jpg","monuments/leaningTowerOfPisa.jpg", "others/pillow.jpg"]
                }
            ]
        }
    ]
}
