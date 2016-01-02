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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0

QtObject {
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/germany/germanybg.jpg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Neuschwanstein Castle"),
            "text": qsTr("Neuschwanstein Castle is a nineteenth-century Romanesque Revival palace on a rugged hill above the village of Hohenschwangau near Füssen in southwest Bavaria, Germany. The palace was commissioned by Ludwig II of Bavaria as a retreat and as an homage to Richard Wagner. Ludwig paid for the palace out of his personal fortune and by means of extensive borrowing, rather than Bavarian public funds."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/neuschwansteinCastle.jpg",
            "text2" : qsTr("Neuschwanstein Castle"),
            "x" : "0.525",
            "y" : "0.938",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Trier Imperial Baths"),
            "text": qsTr("The Trier Imperial Baths are a large Roman bath complex in Trier, Germany. It is designated as part of the Roman Monuments, Cathedral of St. Peter and Church of Our Lady in Trier UNESCO World Heritage Site."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/trierImperialBaths.jpg",
            "text2" : qsTr("Trier Imperial Baths"),
            "x" : "0.205",
            "y" : "0.721",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Brandenburg Gate"),
            "text": qsTr("The Brandenburg Gate is an 18th-century neoclassical triumphal arch in Berlin, and one of the best-known landmarks of Germany. It is built on the site of a former city gate that marked the start of the road from Berlin to the town of Brandenburg an der Havel."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/brandenburgGate.jpg",
            "text2" : qsTr("Brandenburg Gate"),
            "x" : "0.753",
            "y" : "0.331",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Berlin Cathedral"),
            "text": qsTr("Berlin Cathedral is the short name for the Evangelical (i.e. Protestant) Supreme Parish and Collegiate Church in Berlin, Germany. It is located on Museum Island in the Mitte borough. The current building was finished in 1905 and is a main work of Historicist architecture of the 'Kaiserzeit'."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/berlinCathedral.jpg",
            "text2" : qsTr("Berlin Cathedral"),
            "x" : "0.736",
            "y" : "0.255",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Schwerin Palace"),
            "text": qsTr("Schwerin Palace, or Schwerin Castle, is a palatial schloss located in the city of Schwerin, the capital of Mecklenburg-Vorpommern state, Germany. It is situated on an island in the city's main lake, the Schweriner See. For centuries the palace was the home of the dukes and grand dukes of Mecklenburg and later Mecklenburg-Schwerin. Today it serves as the residence of the Mecklenburg-Vorpommern state parliament."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/schwerinPalace.jpg",
            "text2" : qsTr("Schwerin Palace"),
            "x" : "0.585",
            "y" : "0.206",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Aula Palatina"),
            "text": qsTr("The Basilica of Constantine, or Aula Palatina, at Trier, Germany is a Roman palace basilica that was built by the emperor Constantine (AD 306–337) at the beginning of the 4th century. Today it is used as the Church of the Redeemer and owned by a congregation within the Evangelical Church in the Rhineland. The basilica contains the largest extant hall from antiquity and is ranked a World Heritage Site. The hall has a length of 67 m, a width of 26.05 m and a height of 33 m. It is designated as part of the Roman Monuments, Cathedral of St. Peter and Church of Our Lady in Trier UNESCO World Heritage Site."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/aulaPalatina.jpg",
            "text2" : qsTr("Aula Palatina"),
            "x" : "0.245",
            "y" : "0.655",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Worms Cathedral"),
            "text": qsTr("The Cathedral of St Peter is a church in Worms, southern Germany. It was the seat of the Catholic Prince-Bishopric of Worms until its extinction in 1800. It is a basilica with four round towers, two large domes, and a choir at each end. The interior is built in red sandstone. Today, the Wormser Dom is a Catholic parish church, honoured with the title of 'Minor Basilica'."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/germany/wormsCathedral.jpg",
            "text2" : qsTr("Worms Cathedral"),
            "x" : "0.332",
            "y" : "0.697",
            "height" : "0.07",
            "width" : "0.07"
        },
    ]

    property var instructions : [
        {
            "text": qsTr("Monuments of Germany")
        },
        {
            "text": qsTr("Click on location where the given Monument is located.")
        }
    ]
}
