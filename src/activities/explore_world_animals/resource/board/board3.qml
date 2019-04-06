/* GCompris
*
* Copyright (C) 2017 Ilya Bizyaev <bizyaev@zoho.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6

QtObject {

    property string backgroundImage: "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/content.svg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Crocodile"),
            "text": qsTr("A crocodile is a large amphibious reptile. It lives mostly in large tropical rivers, where it is an ambush predator."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/crocodile.jpg",
            "text2": qsTr("Crocodile"),
            "x": 0.50,
            "y": 0.40,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Komodo dragon"),
            "text": qsTr("The Komodo dragon is the largest living lizard (up to 3 meters). It inhabits the Indonesian islands."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/dragon.jpg",
            "text2": qsTr("Komodo dragon"),
            "x": 0.80,
            "y": 0.49,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Koala"),
            "text": qsTr("Koalas are herbivore marsupials that live in the eucalyptus forests of eastern Australia."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/koala.jpg",
            "text2": qsTr("Koala"),
            "x": 0.87,
            "y": 0.61,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Ring-tailed lemur"),
            "text": qsTr("Lemur is a primate that lives in the dry regions of southwest Madagascar. The striped tail makes it easy to recognize."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/lemur.jpg",
            "text2": qsTr("Ring-tailed lemur"),
            "x": 0.65,
            "y": 0.60,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Panda"),
            "text": qsTr("Panda is a bear with black and white fur that lives in a few mountain ranges in central China. Pandas mostly eat bamboo."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/panda.jpg",
            "text2": qsTr("Panda"),
            "x": 0.80,
            "y": 0.30,
            "width": 0.0785,
            "height": 0.1005
        }
    ]

    property var instructions : [
        {
            "text": qsTr("Explore exotic animals from around the world.")
        },
        {
            "text": qsTr("Click on location where the given animal lives.")
        }
    ]
}
