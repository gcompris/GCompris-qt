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
import GCompris 1.0 as GCompris

QtObject {

    property string backgroundImage: "qrc:/gcompris/src/activities/explore_world_music/resource/music/content.svg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Australia"),
            "text": qsTr("Aboriginals were the first people to live in Australia. They sing and play instruments, like the didgeridoo. It is made from a log and can be up to five meters long!"),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/australia.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/australia.jpg",
            "text2": qsTr("Australia"),
            "x": 0.87,
            "y": 0.65,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Africa"),
            "text": qsTr("Music is a part of everyday life in Africa. African music features a great variety of drums, and they believe it is a sacred and magical instrument."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/africa.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/africa.jpg",
            "text2": qsTr("Africa"),
            "x": 0.57,
            "y": 0.47,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Middle East"),
            "text": qsTr("Music is a very important part of middle eastern culture. Specific songs are played to call worshipers to prayer. The lute is an instrument invented thousands of years ago and still in use today."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/middleeast.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/middleeast.jpg",
            "text2": qsTr("Middle East"),
            "x": 0.62,
            "y": 0.32,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Japan"),
            "text": qsTr("Taiko drumming comes from Japan. This type of drumming was originally used to scare enemies in battle. It is very loud, and performances are very exciting with crowds cheering and performers yelling!"),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/japan.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/japan.jpg",
            "text2": qsTr("Japan"),
            "x": 0.87,
            "y": 0.22,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Scotland and Ireland"),
            "text": qsTr("Folk music of this region is called celtic music, often incorporates a narrative poem or story. Typical instruments include bagpipes, fiddles, flutes, harps, and accordions."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/ireland.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/ireland.jpg",
            "text2": qsTr("Scotland and Ireland"),
            "x": 0.50,
            "y": 0.14,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Italy"),
            "text": qsTr("Italy is famous for its Opera. Opera is a musical theater where actors tell a story by acting and singing. Opera singers, both male and female, learn special techniques to sing operas."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/italy.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/italy.jpg",
            "text2": qsTr("Italy"),
            "x": 0.54,
            "y": 0.22,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("European Classical Music"),
            "text": qsTr("Europe is the home of classical music. Famous composers like Bach, Beethoven, and Mozart forever changed music history."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/beethoven.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/orchestra.jpg",
            "text2": qsTr("European Classical Music"),
            "x": 0.57,
            "y": 0.17,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Mexico"),
            "text": qsTr("Mariachi is a famous type of Mexican music. It features guitars, trumpets, and violins. These bands play for many occasions, including weddings and parties."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/mexico.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/mexico.jpg",
            "text2": qsTr("Mexico"),
            "x": 0.24,
            "y": 0.37,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("United States of America"),
            "text": qsTr("USA also has a wide variety of musical genres, but perhaps it is most famous for rock n' roll music. This music features vocalists, guitars, and drums."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/america.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/america.jpg",
            "text2": qsTr("United States of America"),
            "x": 0.25,
            "y": 0.22,
            "width": 0.05,
            "height": 0.05
        }
    ]

    property var instructions : [
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
}
