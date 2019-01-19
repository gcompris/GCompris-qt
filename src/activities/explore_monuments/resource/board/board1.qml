/* GCompris
 *
 * Copyright (C) 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
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

    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/worldbg.jpg"
    property var tab: [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Chichén Itzá"),
            "text": qsTr("Chichen Itza, meaning “at the mouth of the Itza well”, is a Mayan City on the Yucatan Peninsula in Mexico, between Valladolid and Merida. It was established before the period of Christopher Colombus and probably served as the religion center of Yucatan for a while."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/chichenItza.jpg",
            "text2": qsTr("Chichén Itzá"),
            "x": "0.206",
            "y": "0.498",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Colosseum"),
            "text": qsTr("The Colosseum or Coliseum is today the most recognizable of Rome's Classical buildings. Even 2,000 years after it was built, and despite centuries when the abandoned building was pillaged for building materials, it is instantly recognizable as a classical template for the stadia of today. It was the first permanent amphitheatre to be raised in Rome, and the most impressive arena the Classical world had yet seen."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/colosseum.jpg",
            "text2": qsTr("Colosseum"),
            "x": "0.514",
            "y": "0.406",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Christ the Redeemer"),
            "text": qsTr("Christ the Redeemer is an Art Deco statue of Jesus Christ in Rio de Janeiro, Brazil. A symbol of Christianity across the world, the statue has also become a cultural icon of both Rio de Janeiro and Brazil."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/christTheRedeemer.jpg",
            "text2": qsTr("Christ the Redeemer"),
            "x": "0.351",
            "y": "0.628",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("The Great Wall of China"),
            "text": qsTr("The Great Wall, was listed as a World Heritage by UNESCO in 1987. Just like a gigantic dragon, it winds up and down across deserts, grasslands, mountains and plateaus, stretching approximately 13,170 miles (21,196 kilometers) from east to west of China."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/greatWallofChina.jpg",
            "text2": qsTr("The Great Wall of China"),
            "x": "0.765",
            "y": "0.445",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Machu Picchu"),
            "text": qsTr("Machu Picchu stands 2,430 m above sea-level, in the middle of a tropical mountain forest, in an extraordinarily beautiful setting. It was probably the most amazing urban creation of the Inca Empire at its height; its giant walls, terraces and ramps seem as if they have been cut naturally in the continuous rock escarpments. The natural setting, on the eastern slopes of the Andes, encompasses the upper Amazon basin with its rich diversity of flora and fauna."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/machuPicchu.jpg",
            "text2": qsTr("Machu Picchu"),
            "x": "0.267",
            "y": "0.598",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Petra"),
            "text": qsTr("Petra is a historical and archaeological city in the southern Jordanian governorate of Ma'an that is famous for its rock-cut architecture and water conduit system. Established possibly as early as 312 BC as the capital city of the Arab Nabataeans, it is a symbol of Jordan, as well as Jordan's most-visited tourist attraction."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/petra.jpg",
            "text2": qsTr("Petra"),
            "x": "0.586",
            "y": "0.462",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Taj Mahal, India"),
            "text": qsTr("The Taj Mahal is a white marble mausoleum located on the southern bank of the Yamuna River in the Indian city of Agra. It was commissioned in 1632 by the Mughal emperor Shah Jahan reigned to house the tomb of his favorite wife of three, Mumtaz Mahal."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/tajMahal.jpg",
            "text2": qsTr("Taj Mahal"),
            "x": "0.692",
            "y": "0.471",
            "height": "0.07",
            "width": "0.07"
        }
    ]

    property var instructions: [
        {
            "text": qsTr("The 7 New Wonders of World.")
        },
        {
            "text": qsTr("Click on location where the given monument is located.")
        }
    ]
}
