/* GCompris - explore_farm_animals.js
*
* Copyright (C) 2015 Djalil MESLI <djalilmesli@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
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

.import GCompris 1.0 as GCompris
var tab = [
    {
        "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/horse.svg",
        "title": qsTr("Horse"),
        "text": qsTr("The horse goes 'neigh! neigh!'. Horses usually sleep standing up."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/horse.wav"),
        "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/horse.jpg",
        "text2": qsTr("You can ride on the back of this animal!"),
        "x": 0.55896985,
        "y": 0.26696875,
        "width": 0.105645,
        "height": 0.2000287337
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/chicken.svg",
        "title": qsTr("Chicken"),
        "text": qsTr("The chicken goes 'luck, cackle, cluck'. Chickens have over 200 different noises they can use to communicate."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/chickens.wav"),
        "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/chicken.jpg",
        "text2": qsTr("This animal lays eggs."),
        "x": 0.36103875,
        "y": 0.7781575521,
        "width": 0.17824875,
        "height": 0.2027100423
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/cow.svg",
        "title": qsTr("Cow"),
        "text": qsTr("The cow goes 'moo. moo.'. Cows are herbivorous mammals. They graze all day in the meadow."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/cow.wav"),
        "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/cow.jpg",
        "text2": qsTr("You can drink the milk this animal produces."),
        "x": 0.45646875,
        "y": 0.52247722135,
        "width": 0.24231625,
        "height": 0.2436188965
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/cat.svg",
        "title": qsTr("Cat"),
        "text": qsTr("The cat goes 'meow, meow'. Cats usually hate water because their fur doesn't stay warm when it is wet."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/cat.wav"),
        "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/cat.jpg",
        "text2": qsTr("This pet likes chasing mice."),
        "x": 0.44159875,
        "y": 0.4046419271,
        "width": 0.06263625,
        "height": 0.1072301107
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/pig.svg",
        "title": qsTr("Pig"),
        "text": qsTr("The pig goes 'oink, oink'. Pigs are the 4th most intelligent animal."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/pig.wav"),
        "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/pig.jpg",
        "text2": qsTr("This animal likes to lie in the mud."),
        "x": 0.86141875,
        "y": 0.7781575521,
        "width": 0.08060875,
        "height": 0.133525166
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/duck.svg",
        "title": qsTr("Duck"),
        "text": qsTr("The duck goes 'quack, quack'. Ducks have special features like webbed feet and produce an oil to make their feathers 'waterproof'."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/duck.wav"),
        "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/duck.jpg",
        "text2": qsTr("This animal has webbed feet so it can swim in the water."),
        "x": 0.16129375,
        "y": 0.6669921875,
        "width": 0.17968875,
        "height": 0.207092181
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/owl.svg",
        "title": qsTr("Owl"),
        "text": qsTr("The owl goes 'hoo. hoo.' The owl has excellent vision and hearing at night."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/owl.wav"),
        "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/owl.jpg",
        "text2": qsTr("This animal likes to come out at night."),
        "x": 0.90,
        "y": 683/153600,
        "width": 0.05102625,
        "height": 0.1238537793
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/dog.svg",
        "title": qsTr("Dog"),
        "text": qsTr("The dog goes 'bark! bark!'. Dogs are great human companions and usually enjoy love and attention."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/dog.wav"),
        "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/dog.jpg",
        "text2": qsTr("This animal's ancestors were wolves."),
        "x": 0.31079,
        "y": 0.4947916667,
        "width": 0.07916375,
        "height": 0.113404235
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/rooster.svg",
        "title": qsTr("Rooster"),
        "text": qsTr("The rooster goes 'coc-a-doodle-doo!'. Roosters have been on farms for about 5,000 years. Every morning it wakes the farm up with its noises."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/rooster.wav"),
        "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/rooster.jpg",
        "text2": qsTr("This animal wakes the farm up in the morning."),
        "x": 0.60511625,
        "y": 0.7781575521,
        "width": 0.08894625,
        "height": 0.176610638
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/sheep.svg",
        "title": qsTr("Sheep"),
        "text": qsTr("The sheep is a mammal that bears a fleece of wool. It is a grazing herbivore, bred for its wool, its meat, and its milk. The fleece can be removed and used to produce articles of clothing and blankets, among other things."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/sheep.wav"),
        "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/sheep.jpg",
        "text2": qsTr("This animal is a close relative to the goat."),
        "x": 0.8,
        "y": 0.5,
        "width": 0.285,
        "height": 0.22
    }
]


var instruction = [
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
