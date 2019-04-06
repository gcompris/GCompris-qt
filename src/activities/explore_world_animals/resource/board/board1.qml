/* GCompris
*
* Copyright (C) 2015 Johnny Jazeix <jazeix@gmail.com>
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
            "title": qsTr("Jaguar"),
            "text": qsTr("The jaguar's jaw is well developed. Because of this, it has the strongest bite of all the felines, being able to break even a tortoise shell!"),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/jaggy.jpg",
            "text2": qsTr("Jaguar"),
            "x": 0.36,
            "y": 0.56,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Hedgehog"),
            "text": qsTr("Hedgehogs eat small animals, like frogs and insects, so many people keep them as useful pets. When in danger, they will curl up into a ball and stick up their coat of sharp spines."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/hedgy.jpg",
            "text2": qsTr("Hedgehog"),
            "x": 0.53,
            "y": 0.24,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Giraffe"),
            "text": qsTr("The giraffe lives in Africa and is the tallest mammal in the world. Just their legs, which are usually 1.8 meters long, are taller than most humans!"),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/giraffe.jpg",
            "text2": qsTr("Giraffe"),
            "x": 0.58,
            "y": 0.48,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Bison"),
            "text": qsTr("Bison live on the plains of North America and were hunted by the Native Americans for food."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/bison.jpg",
            "text2": qsTr("Bison"),
            "x": 0.27,
            "y": 0.29,
            "width": 0.0785,
            "height": 0.1005
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/question.svg",
            "title": qsTr("Narwhal"),
            "text": qsTr("Narwhals are whales that live in the Arctic Ocean and have long tusks. These tusks remind many people of the mythical unicorn's horn."),
            "image2": "qrc:/gcompris/src/activities/explore_world_animals/resource/animals/narwhal.jpg",
            "text2": qsTr("Narwhal"),
            "x": 0.50,
            "y": 0.06,
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
