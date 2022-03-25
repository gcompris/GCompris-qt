/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {

    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/world-map.svg"
    property var tab: [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Chichén Itzá"),
            "text": qsTr("Chichen Itza, meaning “at the mouth of the Itza well”, is a Mayan City on the Yucatan Peninsula in Mexico, between Valladolid and Merida. It was established before the period of Christopher Colombus and probably served as the religion center of Yucatan for a while."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/chichenItza.webp",
            "text2": qsTr("Chichén Itzá"),
            "x": "0.226",
            "y": "0.495",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Colosseum"),
            "text": qsTr("The Colosseum or Coliseum is today the most recognizable of Rome's Classical buildings. Even 2000 years after it was built, and despite centuries when the abandoned building was pillaged for building materials, it is instantly recognizable as a classical template for the stadia of today. It was the first permanent amphitheatre to be raised in Rome, and the most impressive arena the Classical world had yet seen."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/colosseum.webp",
            "text2": qsTr("Colosseum"),
            "x": "0.506",
            "y": "0.425",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Christ the Redeemer"),
            "text": qsTr("Christ the Redeemer is an Art Deco statue of Jesus Christ in Rio de Janeiro, Brazil. A symbol of Christianity across the world, the statue has also become a cultural icon of both Rio de Janeiro and Brazil."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/christTheRedeemer.webp",
            "text2": qsTr("Christ the Redeemer"),
            "x": "0.348",
            "y": "0.630",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("The Great Wall of China"),
            "text": qsTr("The Great Wall was listed as a World Heritage by UNESCO in 1987. Just like a gigantic dragon, it winds up and down across deserts, grasslands, mountains and plateaus, stretching approximately 13170 miles (21196 kilometers) from east to west of China."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/greatWallofChina.webp",
            "text2": qsTr("The Great Wall of China"),
            "x": "0.794",
            "y": "0.428",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Machu Picchu"),
            "text": qsTr("The Machu Picchu stands 2430 meters above sea-level, in the middle of a tropical mountain forest, in an extraordinarily beautiful setting. It was probably the most amazing urban creation of the Inca Empire at its height, its giant walls, terraces and ramps seem as if they had been cut naturally in the continuous rock escarpments. The natural setting, on the eastern slopes of the Andes, encompasses the upper Amazon basin with its rich diversity of flora and fauna."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/machuPicchu.webp",
            "text2": qsTr("Machu Picchu"),
            "x": "0.272",
            "y": "0.6",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Petra"),
            "text": qsTr("Petra is a historical and archaeological city in the southern Jordanian governorate of Ma'an that is famous for its rock-cut architecture and water conduit system. Established possibly as early as 312 BC as the capital city of the Arab Nabataeans, it is a symbol of Jordan, as well as Jordan's most-visited tourist attraction."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/petra.webp",
            "text2": qsTr("Petra"),
            "x": "0.569",
            "y": "0.465",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Taj Mahal, India"),
            "text": qsTr("The Taj Mahal is a white marble mausoleum located on the southern bank of the Yamuna River in the Indian city of Agra. It was commissioned in 1632 by the Mughal emperor Shah Jahan reigned to house the tomb of his favorite wife of three, Mumtaz Mahal."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/tajMahal.webp",
            "text2": qsTr("Taj Mahal"),
            "x": "0.689",
            "y": "0.472",
            "height": "0.05",
            "width": "0.05"
        }
    ]

    property var instructions: [
        {
            "text": qsTr("The New 7 Wonders of the World.")
        },
        {
            "text": qsTr("Click on the location of the given monument.")
        }
    ]
}
