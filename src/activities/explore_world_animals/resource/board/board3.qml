/* GCompris
*
* SPDX-FileCopyrightText: 2017 Ilya Bizyaev <bizyaev@zoho.com>
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
            "title": qsTr("Crocodile"),
            "text": qsTr("The crocodile is a large amphibious reptile. It lives mostly in large tropical rivers, where it is an ambush predator."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/crocodile.webp",
            "text2": qsTr("Crocodile"),
            "x": 0.525,
            "y": 0.55,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Komodo dragon"),
            "text": qsTr("The Komodo dragon is the largest living lizard (up to 3 meters). It lives in the Indonesian islands."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/dragon.webp",
            "text2": qsTr("Komodo dragon"),
            "x": 0.8,
            "y": 0.58,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Koala"),
            "text": qsTr("Koalas are herbivore marsupials that live in the eucalyptus forests of eastern Australia."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/koala.webp",
            "text2": qsTr("Koala"),
            "x": 0.885,
            "y": 0.64,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Ring-tailed lemur"),
            "text": qsTr("The ring-tailed lemur is a primate that lives in the dry regions of southwest Madagascar. Its striped tail makes it easy to recognize."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/lemur.webp",
            "text2": qsTr("Ring-tailed lemur"),
            "x": 0.595,
            "y": 0.63,
            "width": 0.1,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Panda"),
            "text": qsTr("The panda is a bear with black and white fur that lives in a few mountain ranges in central China. Pandas mostly eat bamboo."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/panda.webp",
            "text2": qsTr("Panda"),
            "x": 0.765,
            "y": 0.45,
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
