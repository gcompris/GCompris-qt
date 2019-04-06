/* GCompris
*
* Copyright (C) 2017 Sergey Popov <sergobot@protonmail.com>
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
            "title": qsTr("Chameleon"),
            "text": qsTr("Chameleon lives in Africa and Madagascar and is well-known for its ability to change its skin color in a couple of seconds."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/chameleon.jpg",
            "text2": qsTr("Chameleon"),
            "x": 0.63,
            "y": 0.56,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Polar bear"),
            "text": qsTr("Polar bear is one of the world's largest predatory mammals. It weights up to a ton and can be as long as 3 meters!"),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/polar_bear.jpg",
            "text2": qsTr("Polar bear"),
            "x": 0.75,
            "y": 0.10,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Kangaroo"),
            "text": qsTr("Kangaroo lives in Australia and is well-known for pouch on its belly used to cradle baby kangaroos."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/kangaroo.jpg",
            "text2": qsTr("Kangaroo"),
            "x": 0.87,
            "y": 0.61,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Scarlet macaw"),
            "text": qsTr("Scarlet macaw lives in South America and is a big and bright colored parrot, able to learn up to 100 words!"),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/scarlet_macaw.jpg",
            "text2": qsTr("Scarlet macaw"),
            "x": 0.33,
            "y": 0.48,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Moose"),
            "text": qsTr("Being the largest of all the deers, moose eats as much as 25 kg a day. However, it's not easy, so sometimes moose has to stand on its hind legs to reach branches up to 4 meters!"),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/moose.jpg",
            "text2": qsTr("Moose"),
            "x": 0.25,
            "y": 0.15,
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
