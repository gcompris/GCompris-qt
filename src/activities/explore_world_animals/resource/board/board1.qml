/* GCompris
*
* SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
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
            "title": qsTr("Jaguar"),
            "text": qsTr("The jaguar's jaw is well developed. Because of this, it has the strongest bite of all the felines, being able to break even a tortoise shell!"),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/jaguar.webp",
            "text2": qsTr("Jaguar"),
            "x": 0.32,
            "y": 0.575,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Hedgehog"),
            "text": qsTr("Hedgehogs eat small animals, like frogs and insects, so many people keep them as useful pets. When in danger, they will curl up into a ball and stick up their coat of sharp spines."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/hedgehog.webp",
            "text2": qsTr("Hedgehog"),
            "x": 0.5,
            "y": 0.4,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Giraffe"),
            "text": qsTr("The giraffe lives in Africa and is the tallest mammal in the world. Just their legs, which are usually 1.8 meters long, are taller than most humans!"),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/giraffe.webp",
            "text2": qsTr("Giraffe"),
            "x": 0.525,
            "y": 0.53,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Bison"),
            "text": qsTr("Bisons live on the plains of North America and were hunted by the Native Americans for food."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/bison.webp",
            "text2": qsTr("Bison"),
            "x": 0.215,
            "y": 0.445,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Narwhal"),
            "text": qsTr("Narwhals are whales that live in the Arctic Ocean and have long tusks. These tusks remind many people of the mythical unicorn's horn."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/narwhal.webp",
            "text2": qsTr("Narwhal"),
            "x": 0.47,
            "y": 0.255,
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
