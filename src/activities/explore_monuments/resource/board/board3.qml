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
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/france/francebg.jpg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Mont-Saint-Michel"),
            "text": qsTr("Mont Saint-Michel is a rocky tidal island located in Normandy, at the mouth of the Couesnon River, near the city of Avranches. The highest point of the island is the spire at the top of the Abbey’s bell tower, 170 metres above sea level. They are currently less than 50 people living on the island. The unique feature of Mont Saint-Michel is that it is completely surrounded by water and can only be accessed at low tide."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/montStMichel.jpg",
            "text2" : qsTr("Mont-Saint-Michel"),
            "x": "0.278",
            "y": "0.268",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Cité de Carcassonne"),
            "text": qsTr("With more than 4 million visitors each year, Carcassonne is among the most prestigious tourist destinations in France, on a par with Mont Saint Michel and Paris’ Notre-Dame. A UNESCO World Heritage Site since 1997, Carcassonne is a dramatic representation of medieval architecture perched on a rocky spur that towers above the River Aude, southeast of the new town."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/citedeCarcassonne.jpg",
            "text2" : qsTr("Cité de Carcassonne"),
            "x": "0.588",
            "y": "0.875",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Reims Cathedral"),
            "text": qsTr("By size, Reims Cathedral is quite an extraordinary construction: designed to accommodate huge crowds, its gigantic dimensions include a surface area of 6,650 m2 and a length of 122m. A Gothic art masterpiece and the coronation site of the Kings of France, it has been listed as a UNESCO World Heritage Site since 1991. The Mecca for tourists in the Champagne region welcomes 1,500,000 visitors every year."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/reimsCathedral.jpg",
            "text2" : qsTr("Reims Cathedral"),
            "x": "0.687",
            "y": "0.196",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Pont du Gard"),
            "text": qsTr("The Pont du Gard was built shortly before the Christian era to allow the aqueduct of Nîmes (which is almost 50 km long) to cross the Gardon river. The Roman architects and hydraulic engineers who designed this bridge, which stands almost 50 m high and is on three levels – the longest measuring 275 m – created a technical as well as an artistic masterpiece."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/pontduGard.jpg",
            "text2" : qsTr("Pont du Gard"),
            "x": "0.691",
            "y": "0.757",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Arles Amphitheatre"),
            "text": qsTr("This Roman amphitheatre dates back to the first century BC and was originally the setting for gladiator battles and chariot races during Antiquity. Modified many times, it was finally renovated during the 19th century."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/arlesAmphitheater.jpg",
            "text2" : qsTr("Arles Amphitheatre"),
            "x": "0.730",
            "y": "0.831",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Château de Chambord"),
            "text": qsTr("Prestigious, majestic, colossal, extravagant are these adjectives enough to fully describe the splendour of Chambord? The largest chateau of the Loire Valley is indeed full of surprises for those who are lucky enough to explore its domain. This remarkable piece of architecture is certainly more than just a castle: it is the dream of a King, transformed into reality."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/chateaudeChambord.jpg",
            "text2" : qsTr("Château de Chambord"),
            "x": "0.456",
            "y": "0.388",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Rocamadour"),
            "text": qsTr("When coming from Cahors by road, Rocamadour suddenly appears clinging precariously against the cliff above the Alzou canyon. One of the most famous villages of Europe, Rocamadour seemingly defies the laws of gravity. The vertiginous Citadel of Faith is best summed up by an old local saying: “houses on the river, churches on the houses, rocks on the churches, castle on the rock”."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/rocamadour.jpg",
            "text2" : qsTr("Rocamadour"),
            "x": "0.538",
            "y": "0.658",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Palais des Papes"),
            "text": qsTr("The star attraction of Avignon is the Palais des Papes (Palace of the Popes), a vast castle of significant historic, religious and architectural importance. It is one of the largest and most important medieval Gothic buildings in Europe."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/palaisdesPapes.jpg",
            "text2" : qsTr("Palais des Papes"),
            "x": "0.771",
            "y": "0.768",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Château de Chenonceau"),
            "text": qsTr("Chateau de Chenonceau is among many of Loire Valley Chateaux that boast amazing architecture and historical significance drawing thousands of tourists from all over the world. Chateau de Chenonceau is sometimes called the Ladies Castle by some historians due to feminine figures having greatly influenced the construction and development of this French Chateau over the centuries."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/chateaudeChenonceau.jpg",
            "text2" : qsTr("Château de Chenonceau"),
            "x": "0.449",
            "y": "0.464",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Eiffel Tower"),
            "text": qsTr("The world-famous metallic tower was built for the Paris International Exhibition in 1889 for the centenary of the French Revolution. At the time of its inauguration, it was the world’s tallest monument."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/eiffelTower.jpg",
            "text2" : qsTr("Eiffel Tower"),
            "x": "0.538",
            "y": "0.304",
            "height": "0.07",
            "width": "0.07"
        },
    ]

    property var instructions : [
        {
            "text": qsTr("Monuments of France")
        },
        {
            "text": qsTr("Click on location where the given monument is located.")
        }
    ]
}
