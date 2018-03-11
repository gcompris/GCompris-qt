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
*   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import GCompris 1.0 as GCompris

QtObject {

    property string backgroundImage: "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/farm-animals.svg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/horse.svg",
            "title": qsTr("Horse"),
            "text": qsTr("The horse goes 'neigh! neigh!'. Horses usually sleep standing up."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/horse.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/horse.jpg",
            "text2": qsTr("You can ride on the back of this animal!"),
            "x": 0.304,
            "y": 0.480,
            "width": 0.156,
            "height": 0.166
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/chicken.svg",
            "title": qsTr("Chicken"),
            "text": qsTr("The chicken goes 'luck, cackle, cluck'. Chickens have over 200 different noises they can use to communicate."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/chickens.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/chicken.jpg",
            "text2": qsTr("This animal lays eggs."),
            "x": 0.66,
            "y": 0.67,
            "width": 0.190,
            "height": 0.119
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cow.svg",
            "title": qsTr("Cow"),
            "text": qsTr("The cow goes 'moo. moo.'. Cows are herbivorous mammals. They graze all day in the meadow."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cow.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cow.jpg",
            "text2": qsTr("You can drink the milk this animal produces."),
            "x": 0.364,
            "y": 0.620,
            "width": 0.305,
            "height": 0.172
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cat.svg",
            "title": qsTr("Cat"),
            "text": qsTr("The cat goes 'meow, meow'. Cats usually hate water because their fur doesn't stay warm when it is wet."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cat.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cat.jpg",
            "text2": qsTr("This pet likes chasing mice."),
            "x": 0.880,
            "y": 0.550,
            "width": 0.114,
            "height": 0.110
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/pig.svg",
            "title": qsTr("Pig"),
            "text": qsTr("The pig goes 'oink, oink'. Pigs are the 4th most intelligent animal."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/pig.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/pig.jpg",
            "text2": qsTr("This animal likes to lie in the mud."),
            "x": 0.42,
            "y": 0.75,
            "width": 0.185,
            "height": 0.153
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/duck.svg",
            "title": qsTr("Duck"),
            "text": qsTr("The duck goes 'quack, quack'. Ducks have special features like webbed feet and produce an oil to make their feathers 'waterproof'."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/duck.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/duck.jpg",
            "text2": qsTr("This animal has webbed feet so it can swim in the water."),
            "x": 0.163,
            "y": 0.76,
            "width": 0.210,
            "height": 0.134
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/owl.svg",
            "title": qsTr("Owl"),
            "text": qsTr("The owl goes 'hoo. hoo.' The owl has excellent vision and hearing at night."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/owl.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/owl.jpg",
            "text2": qsTr("This animal likes to come out at night."),
            "x": 0.71,
            "y": 0.29,
            "width": 0.042,
            "height": 0.056
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/dog.svg",
            "title": qsTr("Dog"),
            "text": qsTr("The dog goes 'bark! bark!'. Dogs are great human companions and usually enjoy love and attention."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/dog.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/dog.jpg",
            "text2": qsTr("This animal's ancestors were wolves."),
            "x": 0.120,
            "y": 0.600,
            "width": 0.126,
            "height": 0.101
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/rooster.svg",
            "title": qsTr("Rooster"),
            "text": qsTr("The rooster goes 'coc-a-doodle-doo!'. Roosters have been on farms for about 5,000 years. Every morning it wakes the farm up with its noises."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/rooster.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/rooster.jpg",
            "text2": qsTr("This animal wakes the farm up in the morning."),
            "x": 0.66,
            "y": 0.78,
            "width": 0.122,
            "height": 0.127
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/sheep.svg",
            "title": qsTr("Sheep"),
            "text": qsTr("The sheep is a mammal that bears a fleece of wool. It is a grazing herbivore, bred for its wool, its meat, and its milk. The fleece can be removed and used to produce articles of clothing and blankets, among other things."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/sheep.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/sheep.jpg",
            "text2": qsTr("This animal is a close relative to the goat."),
            "x": 0.66,
            "y": 0.548,
            "width": 0.20,
            "height": 0.13
        }
    ]

    property var instructions : [
        {
            "text": qsTr("Click on the questions to explore each farm animal.")
        },
        {
            "text": qsTr("Click on the farm animal that makes the sound you hear.")
        },
        {
            "text": qsTr("Click the animal that matches the description.")
        }
    ]
}
