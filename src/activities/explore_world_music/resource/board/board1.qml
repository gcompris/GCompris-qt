/* GCompris
*
* SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0 as GCompris

QtObject {

    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/world-map.svg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Australia"),
            "text": qsTr("Aboriginals were the first people to live in Australia. They sing and play instruments, like the didgeridoo. It is made from a log and can be up to five meters long!"),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/australia.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/australia.webp",
            "text2": qsTr("Australia"),
            "x": 0.840,
            "y": 0.63,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Africa"),
            "text": qsTr("Music is a part of everyday life in Africa. African music features a great variety of drums, and they believe it is a sacred and magical instrument."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/africa.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/africa.webp",
            "text2": qsTr("Africa"),
            "x": 0.53,
            "y": 0.54,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Middle East"),
            "text": qsTr("Music is a very important part of middle eastern culture. Specific songs are played to call worshipers to prayer. The lute is an instrument invented thousands of years ago and still in use today."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/middleeast.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/middleeast.webp",
            "text2": qsTr("Middle East"),
            "x": 0.59,
            "y": 0.46,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Japan"),
            "text": qsTr("Taiko drumming comes from Japan. This type of drumming was originally used to scare enemies in battle. It is very loud, and performances are very exciting with crowds cheering and performers yelling!"),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/japan.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/japan.webp",
            "text2": qsTr("Japan"),
            "x": 0.855,
            "y": 0.445,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Scotland and Ireland"),
            "text": qsTr("Folk music of this region is called celtic music. It often incorporates a narrative poem or story. Typical instruments include bagpipes, fiddles, flutes, harps, and accordions."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/ireland.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/ireland.webp",
            "text2": qsTr("Scotland and Ireland"),
            "x": 0.44,
            "y": 0.36,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Italy"),
            "text": qsTr("Italy is famous for its Opera. Opera is a musical theater where actors tell a story by acting and singing. Opera singers, both male and female, learn special techniques to sing operas."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/italy.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/italy.webp",
            "text2": qsTr("Italy"),
            "x": 0.52,
            "y": 0.44,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("European Classical Music"),
            "text": qsTr("Europe is the home of classical music. Famous composers like Bach, Beethoven, and Mozart forever changed music history."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/beethoven.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/orchestra.webp",
            "text2": qsTr("European Classical Music"),
            "x": 0.50,
            "y": 0.38,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("Mexico"),
            "text": qsTr("Mariachi is a famous type of Mexican music. It features guitars, trumpets, and violins. These bands play for many occasions, including weddings and parties."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/mexico.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/mexico.webp",
            "text2": qsTr("Mexico"),
            "x": 0.19,
            "y": 0.5,
            "width": 0.05,
            "height": 0.05
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_world_music/resource/music/suitcase.svg",
            "title": qsTr("United States of America"),
            "text": qsTr("USA also has a wide variety of musical genres, but perhaps it is most famous for rock n' roll music. This music features vocalists, guitars, and drums."),
            "audio": GCompris.ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/activities/explore_world_music/resource/music/america.$CA"),
            "image2": "qrc:/gcompris/src/activities/explore_world_music/resource/music/america.webp",
            "text2": qsTr("United States of America"),
            "x": 0.185,
            "y": 0.425,
            "width": 0.05,
            "height": 0.05
        }
    ]

    property var instructions : [
        {
            "text": qsTr("Explore world music. Click on the suitcases.")
        },
        {
            "text": qsTr("Click on the location that matches the music you hear.")
        },
        {
            "text": qsTr("Click on the location that matches the text.")
        }
    ]
}
