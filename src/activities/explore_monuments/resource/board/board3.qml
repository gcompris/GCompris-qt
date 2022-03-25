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
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/france/france.svg"
    property var tab: [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Mont-Saint-Michel"),
            "text": qsTr("Mont Saint-Michel is a rocky tidal island located in Normandy, at the mouth of the Couesnon River, near the city of Avranches. The highest point of the island is the spire at the top of the Abbey’s bell tower, 170 meters above sea level. There are currently less than 50 people living on the island. The unique feature of Mont Saint-Michel is that it is completely surrounded by water and can only be accessed at low tide."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/montStMichel.webp",
            "text2": qsTr("Mont-Saint-Michel"),
            "x": "0.265",
            "y": "0.285",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Cité de Carcassonne"),
            "text": qsTr("With more than 4 million visitors each year, Carcassonne is among the most prestigious tourist destinations in France, on a par with Mont Saint Michel and Paris’ Notre-Dame. A UNESCO World Heritage Site since 1997, Carcassonne is a dramatic representation of medieval architecture perched on a rocky spur that towers above the River Aude, southeast of the new town."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/citedeCarcassonne.webp",
            "text2": qsTr("Cité de Carcassonne"),
            "x": "0.545",
            "y": "0.880",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Reims Cathedral"),
            "text": qsTr("By size, Reims Cathedral is quite an extraordinary construction: designed to accommodate huge crowds, its gigantic dimensions include a surface area of 6650 m2 and a length of 122m. A Gothic art masterpiece and the coronation site of the Kings of France, it has been listed as a UNESCO World Heritage Site since 1991. The Mecca for tourists in the Champagne region welcomes 1500000 visitors every year."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/reimsCathedral.webp",
            "text2": qsTr("Reims Cathedral"),
            "x": "0.670",
            "y": "0.225",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Pont du Gard"),
            "text": qsTr("The Pont du Gard was built shortly before the Christian era to allow the aqueduct of Nîmes (which is almost 50 km long) to cross the Gardon river. The Roman architects and hydraulic engineers who designed this bridge, which stands almost 50 m high and is on three levels – the longest measuring 275 m – created a technical as well as an artistic masterpiece."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/pontduGard.webp",
            "text2": qsTr("Pont du Gard"),
            "x": "0.691",
            "y": "0.757",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Arles Amphitheatre"),
            "text": qsTr("This Roman amphitheatre dates back to the first century BC and was originally the setting for gladiator battles and chariot races during Antiquity. Modified many times, it was finally renovated during the 19th century."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/arlesAmphitheater.webp",
            "text2": qsTr("Arles Amphitheatre"),
            "x": "0.730",
            "y": "0.831",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Château de Chambord"),
            "text": qsTr("Prestigious, majestic, colossal, extravagant, are these adjectives enough to fully describe the splendour of Chambord? The largest château of the Loire Valley is indeed full of surprises for those who are lucky enough to explore its domain. This remarkable piece of architecture is certainly more than just a castle: it is the dream of a king, transformed into reality."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/chateaudeChambord.webp",
            "text2": qsTr("Château de Chambord"),
            "x": "0.456",
            "y": "0.388",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Rocamadour"),
            "text": qsTr("When coming from Cahors by road, Rocamadour suddenly appears clinging precariously against the cliff above the Alzou canyon. One of the most famous villages of Europe, Rocamadour seemingly defies the laws of gravity. The vertiginous Citadel of Faith is best summed up by an old local saying: “houses on the river, churches on the houses, rocks on the churches, castle on the rock”."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/rocamadour.webp",
            "text2": qsTr("Rocamadour"),
            "x": "0.538",
            "y": "0.658",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Palais des Papes"),
            "text": qsTr("The star attraction of Avignon is the Palais des Papes (Palace of the Popes), a vast castle of significant historic, religious and architectural importance. It is one of the largest and most important medieval Gothic buildings in Europe."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/palaisdesPapes.webp",
            "text2": qsTr("Palais des Papes"),
            "x": "0.771",
            "y": "0.768",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Château de Chenonceau"),
            "text": qsTr("The Château de Chenonceau is among many of Loire Valley Châteaux that boast amazing architecture and historical significance drawing thousands of tourists from all over the world. Château de Chenonceau is sometimes called the Ladies Castle by some historians due to feminine figures having greatly influenced the construction and development of this French Château over the centuries."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/chateaudeChenonceau.webp",
            "text2": qsTr("Château de Chenonceau"),
            "x": "0.449",
            "y": "0.464",
            "height": "0.05",
            "width": "0.05"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/key.svg",
            "title": qsTr("Eiffel Tower"),
            "text": qsTr("The world-famous metallic tower was built for the Paris International Exhibition in 1889 for the centenary of the French Revolution. At the time of its inauguration, it was the world’s tallest monument."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/eiffelTower.webp",
            "text2": qsTr("Eiffel Tower"),
            "x": "0.538",
            "y": "0.304",
            "height": "0.05",
            "width": "0.05"
        },
    ]

    property var instructions: [
        {
            "text": qsTr("Monuments of France")
        },
        {
            "text": qsTr("Click on the location of the given monument.")
        }
    ]
}
