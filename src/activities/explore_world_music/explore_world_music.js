/* GCompris - explore_world_music.js
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

.import GCompris 1.0 as GCompris
var tab = [
    {
        "image": "qrc:/gcompris/src/activities/explore_world_music/resource/suitcase.svg",
        "title": qsTr("Australia"),
        "text": qsTr("Aboriginals were the first people to live in Australia. They sing and play instruments, like the didgeridoo. It is made from a log and can be up to five meters long!"),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/australia.ogg"),
        "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/australia.jpg",
        "text2": qsTr("Australia"),
        "x": 0.85,
        "y": 0.63,
        "width": 0.05,
        "height": 0.05
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_world_music/resource/suitcase.svg",
        "title": qsTr("Africa"),
        "text": qsTr("Music is a part of everyday life in Africa. African music features a great variety of drums, and they believe it is a sacred and magical instrument."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/africa.ogg"),
        "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/africa.jpg",
        "text2": qsTr("Africa"),
        "x": 0.55,
        "y": 0.45,
        "width": 0.05,
        "height": 0.05
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_world_music/resource/suitcase.svg",
        "title": qsTr("Middle East"),
        "text": qsTr("Music is a very important part of middle eastern culture. Specific songs are played to call worshipers to prayer. The lute is an instrument invented thousands of years ago and still in use today."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/middleeast.ogg"),
        "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/middleeast.jpg",
        "text2": qsTr("Middle East"),
        "x": 0.6,
        "y": 0.3,
        "width": 0.05,
        "height": 0.05
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_world_music/resource/suitcase.svg",
        "title": qsTr("Japan"),
        "text": qsTr("Taiko drumming comes from Japan. This type of drumming was originally used to scare enemies in battle. It is very loud, and performances are very exciting with crowds cheering and performers yelling!"),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/japan.ogg"),
        "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/japan.jpg",
        "text2": qsTr("Japan"),
        "x": 0.85,
        "y": 0.2,
        "width": 0.05,
        "height": 0.05
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_world_music/resource/suitcase.svg",
        "title": qsTr("Scotland and Ireland"),
        "text": qsTr("Folk music of this region is called celtic music, often incorporates a narrative poem or story. Typical instruments include bagpipes, fiddles, flutes, harps, and accordions."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/ireland.ogg"),
        "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/ireland.jpg",
        "text2": qsTr("Scotland and Ireland"),
        "x": 0.48,
        "y": 0.12,
        "width": 0.05,
        "height": 0.05
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_world_music/resource/suitcase.svg",
        "title": qsTr("Italy"),
        "text": qsTr("Italy is famous for its Opera. Opera is a musical theater where actors tell a story by acting and singing. Opera singers, both male and female, learn special techniques to sing operas."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/italy.ogg"),
        "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/italy.jpg",
        "text2": qsTr("Italy"),
        "x": 0.52,
        "y": 0.2,
        "width": 0.05,
        "height": 0.05
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_world_music/resource/suitcase.svg",
        "title": qsTr("European Classical Music"),
        "text": qsTr("Europe is the home of classical music. Famous composers like Bach, Beethoven, and Mozart forever changed music history."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/beethoven.ogg"),
        "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/orchestra.jpg",
        "text2": qsTr("European Classical Music"),
        "x": 0.55,
        "y": 0.15,
        "width": 0.05,
        "height": 0.05
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_world_music/resource/suitcase.svg",
        "title": qsTr("Mexico"),
        "text": qsTr("Mariachi is a famous type of Mexican music. It features guitars, trumpets, and violins. These bands play for many occasions, including weddings and parties."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/mexico.ogg"),
        "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/mexico.jpg",
        "text2": qsTr("Mexico"),
        "x": 0.22,
        "y": 0.35,
        "width": 0.05,
        "height": 0.05
    },
    {
        "image": "qrc:/gcompris/src/activities/explore_world_music/resource/suitcase.svg",
        "title": qsTr("United States of America"),
        "text": qsTr("USA also has a wide variety of musical genres, but perhaps it is most famous for rock n' roll music. This music features vocalists, guitars, and drums."),
        "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/america.ogg"),
        "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/america.jpg",
        "text2": qsTr("United States of America"),
        "x": 0.23,
        "y": 0.2,
        "width": 0.05,
        "height": 0.05
    }
]


var instruction = [
    {
        "text": qsTr("Explore world music! Click on the suitcases.")
    },
    {
        "text": qsTr("Click on the location that matches the music you hear.")
    },
    {
        "text": qsTr("Click on the location that matches the text.")
    }
]
