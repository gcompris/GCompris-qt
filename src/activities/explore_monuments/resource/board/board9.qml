/* GCompris
 *
 * SPDX-FileCopyrightText: 2024 Nidhish Chauhan <rch246chauhan@gmail.com>
 *
 * Authors:
 *   Nidhish Chauhan <rch246chauhan@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/japan/japan.svg"
    property var tab: [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Himeji Castle"),
            "text": qsTr("Himeji-jo is the finest surviving example of early 17th-century Japanese castle architecture, comprising 83 buildings with highly developed systems of defence and ingenious protection devices dating from the beginning of the Shogun period. It is a masterpiece of construction in wood, combining function with aesthetic appeal, both in its elegant appearance unified by the white plastered earthen walls and in the subtlety of the relationships between the building masses and the multiple roof layers."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/japan/himejiCastle.webp",
            "text2": qsTr("Himeji Castle"),
            "x": "0.496",
            "y": "0.490",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Hiroshima Peace Memorial Park"),
            "text": qsTr("Hiroshima Peace Memorial Park is a symbol of peace and a reminder of the devastating consequences of war. Located in Hiroshima, Japan, the park commemorates the victims of the atomic bombing on August 6, 1945. The park features several monuments, including the iconic Atomic Bomb Dome, which was once a government building and now stands as a UNESCO World Heritage Site. The park also houses the Hiroshima Peace Memorial Museum, which educates visitors about the events surrounding the bombing and promotes a message of peace, nonviolence, and the importance of nuclear disarmament. It serves as a solemn space for reflection, honoring the lives lost and advocating for global peace."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/japan/hiroshimaPeaceMemorialPark.webp",
            "text2": qsTr("Hiroshima Peace Memorial Park"),
            "x": "0.400",
            "y": "0.515",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Arakura Fuji Sengen Shrine"),
            "text": qsTr("The shrine was founded in 705 to enshrine the deity of the site. Following the great eruption of Mt. Fuji in 807, the emperor dispatched an imperial envoy to this shrine to perform a ritual to halt the eruption. It is said that during the Warring States Period, when Takeda Nobutora, the father of a famous warlord Takeda Shingen, battled with the Hojo Family, he set up camp here, prayed for victory, and won the battle. He then dedicated his sword to this shrine. Today, locals and those from afar visit the shrine to ward off evil, to pray for family happiness, and safe childbirth. In the spring, the cherry blossom trees bloom and crowds gather to enjoy the stunning view of Mt. Fuji."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/japan/arakuraShrine.webp",
            "text2": qsTr("Arakura Fuji Sengen Shrine"),
            "x": "0.680",
            "y": "0.470",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Okinawa Shuri Castle"),
            "text": qsTr("Shuri Castle, located in Naha, Okinawa, Japan, is a UNESCO World Heritage Site and a symbol of the Ryukyu Kingdom's rich cultural history. Originally constructed in the 14th century, the castle served as the political, economic, and cultural hub of the kingdom for centuries. Renowned for its distinctive fusion of Chinese and Japanese architectural styles, Shuri Castle features vermillion lacquered structures, ornate decorations, and a commanding hilltop position. Though destroyed during World War II, it was meticulously reconstructed and became a key tourist attraction. Tragically, much of the castle was lost in a fire in 2019, but efforts to restore it are ongoing, reflecting its enduring importance to Okinawa's heritage."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/japan/okinawaShuriCastle.webp",
            "text2": qsTr("Okinawa Shuri Castle"),
            "x": "0.193",
            "y": "0.875",
            "height": "0.05",
            "width": "0.05"
        },
    ]

    property var instructions: [
        {
            "text": qsTr("Monuments of Japan")
        },
        {
            "text": qsTr("Click on the location of the given monument.")
        }
    ]
}
