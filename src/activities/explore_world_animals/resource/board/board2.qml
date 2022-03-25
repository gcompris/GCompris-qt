/* GCompris
*
* SPDX-FileCopyrightText: 2017 Sergey Popov <sergobot@protonmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

QtObject {

    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/world-map.svg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Chameleon"),
            "text": qsTr("The chameleon lives in Africa and Madagascar and is well-known for its ability to change its skin color in a couple of seconds."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/chameleon.webp",
            "text2": qsTr("Chameleon"),
            "x": 0.6,
            "y": 0.615,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Polar bear"),
            "text": qsTr("The polar bear is one of the world's largest predatory mammals. It weighs up to a ton and can be as long as 3 meters!"),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/polar_bear.webp",
            "text2": qsTr("Polar bear"),
            "x": 0.365,
            "y": 0.25,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Kangaroo"),
            "text": qsTr("The kangaroo lives in Australia and is well-known for the pouch on its belly used to cradle baby kangaroos."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/kangaroo.webp",
            "text2": qsTr("Kangaroo"),
            "x": 0.840,
            "y": 0.63,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Scarlet macaw"),
            "text": qsTr("The scarlet macaw lives in South America and is a big and bright colored parrot, able to learn up to 100 words!"),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/scarlet_macaw.webp",
            "text2": qsTr("Scarlet macaw"),
            "x": 0.3,
            "y": 0.55,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Moose"),
            "text": qsTr("Being the largest of all the deers, the moose eats as much as 25 kg per day. However, it's not easy, so sometimes the moose has to stand on its hind legs to reach branches up to 4 meters!"),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/moose.webp",
            "text2": qsTr("Moose"),
            "x": 0.125,
            "y": 0.37,
            "width": 0.1,
            "height": 0.1
        }
    ]

    property var instructions : [
        {
            "text": qsTr("Explore wild animals from around the world.")
        },
        {
            "text": qsTr("Click on the location where the given animal lives.")
        }
    ]
}
