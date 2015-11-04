/* GCompris - explore_.js
 *
 * Copyright (C) 2015 Djalil Mesli <djalilmesli@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Djalil Mesli <djalilmesli@gmail.com> (Qt Quick port)
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
var tab= [

             {
                 "image" :  "qrc:/gcompris/src/activities/explore_farm_animals/resource/horse.svg",
                 "text"  :  qsTr("The horse goes 'neigh! neigh!'. Horses usually sleep standing up"),
                 "audio" :  GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/horse.wav"),
                 "image2":  "qrc:/gcompris/src/activities/explore_farm_animals/resource/horse.jpg",
                 "text2" :  qsTr("You can ride on the back of this animal!")
             },
             {
                 "image"  : "qrc:/gcompris/src/activities/explore_farm_animals/resource/chicken.svg",
                 "text"   : qsTr("The chicken goes 'luck, cackle, cluck'. Chickens have over 200 different noises they can use to communicate."),
                 "audio"  : GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/chickens.wav"),
                 "image2" : "qrc:/gcompris/src/activities/explore_farm_animals/resource/chicken.jpg",
                 "text2"  : qsTr("This animal lays eggs.")
             },
             {
                 "image"  : "qrc:/gcompris/src/activities/explore_farm_animals/resource/cow.svg",
                 "text"   : qsTr("The cow goes 'moo. moo.'. Cows are herbivorous mammals. They graze all day in the meadow."),
                 "audio"  : GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/cow.wav"),
                 "image2" : "qrc:/gcompris/src/activities/explore_farm_animals/resource/cow.jpg",
                 "text2"  : qsTr("You can drink the milk this animal produces.")
             },
             {
                 "image"  : "qrc:/gcompris/src/activities/explore_farm_animals/resource/cat.svg",
                 "text"   : qsTr("The cat goes 'meow, meow'. Cats usually hate water because their fur doesn't stay warm when it is wet."),
                 "audio"  : GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/cat.wav"),
                 "image2" : "qrc:/gcompris/src/activities/explore_farm_animals/resource/cat.jpg",
                 "text2"  : qsTr("This pet likes chasing mice.")
             },
             {
                 "image"  : "qrc:/gcompris/src/activities/explore_farm_animals/resource/pig.svg",
                 "text"   : qsTr("The pig goes 'oink, oink'. Pigs are the 4th most intelligent animal."),
                 "audio"  : GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/pig.wav"),
                 "image2" : "qrc:/gcompris/src/activities/explore_farm_animals/resource/pig.jpg",
                 "text2"  : qsTr("This animal likes to lie in the mud.")
             },
             {
                 "image"  : "qrc:/gcompris/src/activities/explore_farm_animals/resource/duck.svg",
                 "text"   : qsTr("The duck goes 'quack, quack'. Ducks have special features like webbed feet and produce an oil to make their feathers 'waterproof'."),
                 "audio"  : GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/duck.wav"),
                 "image2" : "qrc:/gcompris/src/activities/explore_farm_animals/resource/duck.jpg",
                 "text2"  : qsTr("This animal has webbed feet so it can swim in the water.")
             },
             {
                 "image"  : "qrc:/gcompris/src/activities/explore_farm_animals/resource/owl.svg",
                 "text"   : qsTr("The owl goes 'hoo. hoo.' The owl has excellent vision and hearing at night."),
                 "audio"  : GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/owl.wav"),
                 "image2" : "qrc:/gcompris/src/activities/explore_farm_animals/resource/owl.jpg",
                 "text2"  : qsTr("This animal likes to come out at night.")
              },
             {
                "image"  : "qrc:/gcompris/src/activities/explore_farm_animals/resource/dog.svg",
                "text"   : qsTr("The dog goes 'bark! bark!'. Dogs are great human companions and usually enjoy love and attention."),
                "audio"  : GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/dog.wav"),
                "image2" : "qrc:/gcompris/src/activities/explore_farm_animals/resource/dog.jpg",
                "text2"  : qsTr("This animal's ancestors were wolves.")
            },
            {
                "image"  : "qrc:/gcompris/src/activities/explore_farm_animals/resource/rooster.svg",
                "text"   : qsTr("The rooster goes 'coc-a-doodle-doo!'. Roosters have been on farms for about 5,000 years. Every morning it wakes the farm up with its noises."),
                "audio"  : GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_farm_animals/resource/rooster.wav"),
                "image2" : "qrc:/gcompris/src/activities/explore_farm_animals/resource/rooster.jpg",
                "text2"  : qsTr("This animal wakes the farm up in the morning.")
            }



           ]



