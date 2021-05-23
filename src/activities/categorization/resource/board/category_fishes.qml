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
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/fishes/"
    property var levels: [
        {
            "type": "lesson",
            "name": qsTr("Fishes"),
            "image": imagesPrefix + "fish20.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish10.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish1.jpg","fishes/fish2.png","fishes/fish3.jpg","fishes/fish4.jpg","fishes/fish5.jpg","fishes/fish6.jpg"],
                    "bad": ["monuments/beandenburgGate.jpg","monuments/burj.jpg","others/bulb.jpg","tools/cutingTool.jpg","others/knife.jpg","tools/multimeter.jpg"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish13.jpg",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish7.jpg","fishes/fish8.jpg","fishes/fish9.jpg","fishes/fish10.jpg","fishes/fish11.jpg","fishes/fish12.jpg"],
                    "bad": ["renewable/dam2.jpg","renewable/solar5.jpg","others/pillow.jpg","tools/plier2.jpg","tools/nailCutter.jpg","monuments/colosseum.jpg"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish3.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish13.jpg","fishes/fish14.jpg","fishes/fish15.jpg","fishes/fish16.jpg","fishes/fish17.jpg"],
                    "bad": ["others/bulb.jpg","others/chair.jpg","renewable/windmill.jpg","monuments/monument2.jpg"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish16.jpg",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish18.jpg","fishes/fish19.jpg","fishes/fish20.jpg","fishes/fish21.jpg",
                            "fishes/fish22.jpg"],
                    "bad": ["others/plate.jpg","monuments/operaHouse.jpg","monuments/zimniPalace.jpg","renewable/geothermal.jpg"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish20.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish23.jpg","fishes/fish24.jpg", "fishes/fish25.jpg"],
                    "bad": ["monuments/monument3.jpg","others/pan.jpg","others/pencil.jpg"]
                },
                {
                    "instructions": qsTr("Place the FISHES to the right and other objects to the left"),
                    "image": imagesPrefix + "fish25.jpg",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "qrc:/gcompris/src/activities/categorization/resource/images/",
                    "good": ["fishes/fish26.jpg","fishes/fish27.jpg","fishes/fish28.jpg"],
                    "bad": ["renewable/windmill13.jpg","renewable/geothermal.jpg","tools/scissors.jpg"]
                }
            ]
        }
    ]
}
