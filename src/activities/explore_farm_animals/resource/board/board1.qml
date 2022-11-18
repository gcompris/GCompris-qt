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
import QtQuick 2.12
import GCompris 1.0 as GCompris

QtObject {

    property string backgroundImage: "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/farm-animals.svg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/horse.svg",
            "title": qsTr("Horse"),
            "text": qsTr("The horse goes 'neigh'. Horses are adapted to run, allowing them to quickly escape predators, and possess an excellent sense of balance. They have single-toed hooves."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/horse.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/horse.webp",
            "text2": qsTr("This animal has single-toed hooves."),
            "x": 0.18,
            "y": 0.43,
            "width": 0.2,
            "height": 0.19
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/chicken.svg",
            "title": qsTr("Chicken"),
            "text": qsTr("The chicken goes 'cluck'. Domestic chickens have wings, but are not capable of long-distance flight. They have a comb on their head."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/chickens.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/chicken.webp",
            "text2": qsTr("This animal has a comb on its head."),
            "x": 0.7,
            "y": 0.8,
            "width": 0.19,
            "height": 0.12
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cow.svg",
            "title": qsTr("Cow"),
            "text": qsTr("The cow goes 'moo'. Cows have a wide field of view of 330°. They have a well-developed sense of taste, with around 20,000 taste buds. They can detect odours 8km away."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cow.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cow.webp",
            "text2": qsTr("This animal has around 20,000 taste buds."),
            "x": 0.43,
            "y": 0.46,
            "width": 0.21,
            "height": 0.16
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cat.svg",
            "title": qsTr("Cat"),
            "text": qsTr("The cat goes 'meow'. Cats are valued by humans for companionship and their ability to chase mice and other rodents. They purr to communicate various emotions."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cat.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/cat.webp",
            "text2": qsTr("This animal can purr."),
            "x": 0.14,
            "y": 0.68,
            "width": 0.12,
            "height": 0.1
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/pig.svg",
            "title": qsTr("Pig"),
            "text": qsTr("The pig goes 'oink'. Pigs wallow in the mud, mainly to control their body temperature."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/pig.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/pig.webp",
            "text2": qsTr("This animal wallows in the mud to control its body temperature."),
            "x": 0.38,
            "y": 0.65,
            "width": 0.18,
            "height": 0.14
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/duck.svg",
            "title": qsTr("Duck"),
            "text": qsTr("The duck goes 'quack'. Ducks are mostly aquatic birds. They have waterproof feathers and webbed feet which enable them to swim on the water."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/duck.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/duck.webp",
            "text2": qsTr("This animal has webbed feet and can swim on the water."),
            "x": 0.33,
            "y": 0.83,
            "width": 0.245,
            "height": 0.14
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/owl.svg",
            "title": qsTr("Owl"),
            "text": qsTr("The owl goes 'hoot'. Owls are nocturnal birds, they have excellent vision and hearing at night."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/owl.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/owl.webp",
            "text2": qsTr("This animal is a nocturnal bird."),
            "x": 0.88,
            "y": 0.37,
            "width": 0.07,
            "height": 0.08
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/dog.svg",
            "title": qsTr("Dog"),
            "text": qsTr("The dog goes 'woof'. Dogs are probably the oldest domesticated species. They are descendants of the wolf."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/dog.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/dog.webp",
            "text2": qsTr("This animal is a descendant of the wolf."),
            "x": 0.86,
            "y": 0.62,
            "width": 0.195,
            "height": 0.14
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/sheep.svg",
            "title": qsTr("Sheep"),
            "text": qsTr("The sheep goes 'baa'. Most sheep breeds bear a fleece of wool. The fleece can be sheared and used to produce textile fibre."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/sheep.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_farm_animals/resource/animals/sheep.webp",
            "text2": qsTr("This animal produces wool."),
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
