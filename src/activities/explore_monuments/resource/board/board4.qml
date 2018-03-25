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
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/germany/germanybg.jpg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Neuschwanstein Castle"),
            "text": qsTr("The ultimate fairytale castle, Neuschwanstein is situated on a rugged hill near Füssen in southwest Bavaria. It was the inspiration for the Sleeping Beauty castles in the Disneyland parks. The castle was commissioned by King Ludwig II of Bavaria who was declared insane when the castle was almost completed in 1886 and found dead a few days later. Neuschwanstein is the most photographed building in the country and one of the most popular tourist attractions in Germany."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/neuschwansteinCastle.jpg",
            "text2" : qsTr("Neuschwanstein Castle"),
            "x": "0.525",
            "y": "0.938",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Trier Imperial Baths"),
            "text": qsTr("The Trier Imperial Baths are a large Roman bath complex in Trier, Germany. It is designated as part of the Roman Monuments, Cathedral of St. Peter and Church of Our Lady in Trier UNESCO World Heritage Site."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/trierImperialBaths.jpg",
            "text2" : qsTr("Trier Imperial Baths"),
            "x": "0.205",
            "y": "0.721",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Brandenburg Gate"),
            "text": qsTr("The Brandenburg Gate is the only surviving city gate of Berlin and symbolizes the reunification of East and West Berlin. Built in the 18th century, the Brandenburg Gate is the entry to Unter den Linden, the prominent boulevard of linden trees which once led directly to the palace of the Prussian monarchs. It is regarded as one of the most famous landmarks in Europe."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/brandenburgGate.jpg",
            "text2" : qsTr("Brandenburg Gate"),
            "x": "0.753",
            "y": "0.331",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Berlin Cathedral"),
            "text": qsTr("The Cathedral of Berlin is the largest church in the city, and it serves as a vital center for the Protestant church of Germany. Reaching out well beyond the borders of the parish and of Berlin, the cathedral attracts thousands of visitors, year after year, from Germany and abroad."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/berlinCathedral.jpg",
            "text2" : qsTr("Berlin Cathedral"),
            "x": "0.736",
            "y": "0.255",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Schwerin Palace"),
            "text": qsTr("This romantic fairytale fortress, with all its many towers, domes and wings, is reflected in the waters of Lake Schwerin. It was completed in 1857 and symbolized the powerful dynasty of its founder, Friedrich Franz II."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/schwerinPalace.jpg",
            "text2" : qsTr("Schwerin Palace"),
            "x": "0.585",
            "y": "0.206",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Aula Palatina"),
            "text": qsTr("The long, high-ceilinged brick structure was the throne hall of the Roman emperor until the destruction of the city by Germanic tribes. The invaders built a settlement inside the roofless ruin. In the 12th century, the apse was converted into a tower to accommodate the Archbishop of Trier."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/aulaPalatina.jpg",
            "text2" : qsTr("Aula Palatina"),
            "x": "0.245",
            "y": "0.655",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Worms Cathedral"),
            "text": qsTr("Worms Cathedral (Wormser Dom) also known as the Cathedral of St Peter is a Romanesque cathedral in the German city of Worms. A sandstone structure with distinctive conical towers, Worms Cathedral was constructed in phases throughout the twelfth century and mostly completed by 1181."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/wormsCathedral.jpg",
            "text2" : qsTr("Worms Cathedral"),
            "x": "0.332",
            "y": "0.697",
            "height": "0.07",
            "width": "0.07"
        },
    ]

    property var instructions : [
        {
            "text": qsTr("Monuments of Germany")
        },
        {
            "text": qsTr("Click on location where the given monument is located.")
        }
    ]
}
