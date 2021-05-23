/* GCompris
*
* SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (new images and coordinates)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.9
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
            "x": 0.18,
            "y": 0.43,
            "width": 0.2,
            "height": 0.19
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/chicken.svg",
            "title": qsTr("Chicken"),
            "text": qsTr("The chicken goes 'luck, cackle, cluck'. Chickens have over 200 different noises they can use to communicate."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/chickens.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/chicken.jpg",
            "text2": qsTr("This animal lays eggs."),
            "x": 0.45,
            "y": 0.81,
            "width": 0.19,
            "height": 0.12
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cow.svg",
            "title": qsTr("Cow"),
            "text": qsTr("The cow goes 'moo! moo!'. Cows are herbivorous mammals. They graze all day in the meadow."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cow.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cow.jpg",
            "text2": qsTr("You can drink the milk this animal produces."),
            "x": 0.43,
            "y": 0.46,
            "width": 0.21,
            "height": 0.16
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cat.svg",
            "title": qsTr("Cat"),
            "text": qsTr("The cat goes 'meow, meow'. Cats usually hate water because their fur doesn't stay warm when it is wet."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cat.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cat.jpg",
            "text2": qsTr("This pet likes chasing mice."),
            "x": 0.14,
            "y": 0.68,
            "width": 0.12,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/pig.svg",
            "title": qsTr("Pig"),
            "text": qsTr("The pig goes 'oink, oink'. Pigs are the 4th most intelligent animal."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/pig.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/pig.jpg",
            "text2": qsTr("This animal likes to lie in the mud."),
            "x": 0.38,
            "y": 0.65,
            "width": 0.18,
            "height": 0.14
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/duck.svg",
            "title": qsTr("Duck"),
            "text": qsTr("The duck goes 'quack, quack'. Ducks have special features like webbed feet and produce an oil to make their feathers 'waterproof'."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/duck.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/duck.jpg",
            "text2": qsTr("This animal has webbed feet so it can swim in the water."),
            "x": 0.2,
            "y": 0.86,
            "width": 0.245,
            "height": 0.14
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/owl.svg",
            "title": qsTr("Owl"),
            "text": qsTr("The owl goes 'hoo. hoo.' The owl has excellent vision and hearing at night."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/owl.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/owl.jpg",
            "text2": qsTr("This animal likes to come out at night."),
            "x": 0.88,
            "y": 0.37,
            "width": 0.07,
            "height": 0.08
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/dog.svg",
            "title": qsTr("Dog"),
            "text": qsTr("The dog goes 'bark! bark!'. Dogs are great human companions and usually enjoy love and attention."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/dog.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/dog.jpg",
            "text2": qsTr("This animal's ancestors were wolves."),
            "x": 0.86,
            "y": 0.62,
            "width": 0.195,
            "height": 0.14
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/rooster.svg",
            "title": qsTr("Rooster"),
            "text": qsTr("The rooster goes 'coc-a-doodle-doo!'. Roosters have been on farms for about 5,000 years. Every morning it wakes the farm up with its noises."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/rooster.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/rooster.jpg",
            "text2": qsTr("This animal wakes the farm up in the morning."),
            "x": 0.68,
            "y": 0.84,
            "width": 0.1,
            "height": 0.13
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/sheep.svg",
            "title": qsTr("Sheep"),
            "text": qsTr("The sheep is a mammal that bears a fleece of wool. It is a grazing herbivore, bred for its wool, its meat, and its milk. The fleece can be removed and used to produce articles of clothing and blankets, among other things."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/sheep.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/sheep.jpg",
            "text2": qsTr("This animal is a close relative to the goat."),
            "x": 0.64,
            "y": 0.59,
            "width": 0.16,
            "height": 0.16
        }
    ]

    property var instructions : [
        {
            "text": qsTr("Click on each farm animal to discover them.")
        },
        {
            "text": qsTr("Click on the farm animal that makes the sound you hear.")
        },
        {
            "text": qsTr("Click the animal that matches the description.")
        }
    ]
}
