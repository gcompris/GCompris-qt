/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
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
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/france/francebg.jpg"
    //   property string instruction: qsTr("Drag and Drop the items to make them match")
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Mont-Saint-Michel"),
            "text": qsTr("Le Mont-Saint-Michel is an island commune in Normandy, France. The island has held strategic fortifications since ancient times and since the 8th century AD has been the seat of the monastery from which it draws its name. The structural composition of the town exemplifies the feudal society that constructed it: on top, God, the abbey and monastery; below, the great halls; then stores and housing; and at the bottom, outside the walls, houses for fishermen and farmers."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/montStMichel.jpg",
            "text2" : qsTr("Mont-Saint-Michel"),
            "x" : "0.278",
            "y" : "0.268",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Cité de Carcassonne"),
            "text": qsTr("The Cité de Carcassonne is a medieval citadel located in the French city of Carcassonne. Founded during the Gallo-Roman period, the citadel derives its reputation from its 3 kilometres (1.9 mi) long double surrounding walls interspersed by 52 towers. The town has about 2,500 years of history and has seen the Romans, Visigoths, Saracens and Crusaders. At the beginning of its history it was a Gaulish settlement then in the 3rd century A.D., the Romans decided to transform it into a fortified town. The town was finally annexed to the kingdom of France in 1247 A.D. It provided a strong French frontier between France and the Crown of Aragon."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/citedeCarcassonne.jpg",
            "text2" : qsTr("Cité de Carcassonne"),
            "x" : "0.588",
            "y" : "0.875",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Reims Cathedral"),
            "text": qsTr("Notre-Dame de Reims (Our Lady of Reims) is the seat of the Archdiocese of Reims, where the kings of France were crowned. The cathedral replaced an older church, destroyed by fire in 1211, that was built on the site of the basilica where Clovis was baptized by Saint Remi, bishop of Reims, in AD 496. That original structure had itself been erected on the site of some Roman baths. A major tourism destination, the cathedral receives about one million visitors annually."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/reimsCathedral.jpg",
            "text2" : qsTr("Reims Cathedral"),
            "x" : "0.687",
            "y" : "0.196",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Pont du Gard"),
            "text": qsTr("The Pont du Gard is an ancient Roman aqueduct that crosses the Gardon River in the south of France. Located near the town of Vers-Pont-du-Gard, the bridge is part of the Nîmes aqueduct, a 50-kilometer system built in the first century AD to carry water from a spring at Uzès to the Roman colony of Nemausus (Nîmes) Because of the uneven terrain between the two points, the mostly underground aqueduct followed a long, winding route that called for a bridge across the gorge of the Gardon River. The Pont du Gard is the highest of all elevated Roman aqueducts, and, along with the Aqueduct of Segovia, one of the best preserved. It was added to UNESCO's list of World Heritage Sites in 1985 because of its historical importance."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/pontduGard.jpg",
            "text2" : qsTr("Pont du Gard"),
            "x" : "0.691",
            "y" : "0.757",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Arles Amphitheatre"),
            "text": qsTr("The Arles Amphitheatre is a Roman amphitheatre in the southern French town of Arles. This two-tiered Roman amphitheatre is probably the most prominent tourist attraction in the city of Arles, which thrived in Roman times. The pronounced towers jutting out from the top are medieval add-ons. Built in 90 AD, the amphitheatre was capable of seating over 20,000 spectators, and was built to provide entertainment in the form of chariot races and bloody hand-to-hand battles. Today, it draws large crowds for bullfighting during the Feria d'Arles as well as plays and concerts in summer."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/arlesAmphitheater.jpg",
            "text2" : qsTr("Arles Amphitheatre"),
            "x" : "0.730",
            "y" : "0.831",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Château de Chambord"),
            "text": qsTr("The royal Château de Chambord at Chambord, Loir-et-Cher, France, is one of the most recognizable châteaux in the world because of its very distinctive French Renaissance architecture which blends traditional French medieval forms with classical Renaissance structures. The building, which was never completed, was constructed by King Francis I of France."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/chateaudeChambord.jpg",
            "text2" : qsTr("Château de Chambord"),
            "x" : "0.456",
            "y" : "0.388",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Rocamadour"),
            "text": qsTr("Rocamadour has attracted visitors for its setting in a gorge above a tributary of the River Dordogne, and especially for its historical monuments and its sanctuary of the Blessed Virgin Mary, which for centuries has attracted pilgrims from every country, among them kings, bishops, and nobles."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/rocamadour.jpg",
            "text2" : qsTr("Rocamadour"),
            "x" : "0.538",
            "y" : "0.658",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Palais des Papes"),
            "text": qsTr("The Palais des Papes is a historical palace in Avignon, southern France, one of the largest and most important medieval Gothic buildings in Europe. One time fortress and palace, the papal residence was the seat of Western Christianity during the 14th century. Six papal conclaves were held in the Palais, leading to the elections of Benedict XII in 1334, Clement VI in 1342, Innocent VI in 1352, Urban V in 1362, Gregory XI in 1370 and Antipope Benedict XIII in 1394."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/palaisdesPapes.jpg",
            "text2" : qsTr("Palais des Papes"),
            "x" : "0.771",
            "y" : "0.768",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Château de Chenonceau"),
            "text": qsTr("The Château de Chenonceau is a French château spanning the River Cher, near the small village of Chenonceaux in the Indre-et-Loire département of the Loire Valley in France. It is one of the best-known châteaux of the Loire valley."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/chateaudeChenonceau.jpg",
            "text2" : qsTr("Château de Chenonceau"),
            "x" : "0.449",
            "y" : "0.464",
            "height" : "0.07",
            "width" : "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Eiffel Tower"),
            "text": qsTr("The Eiffel Tower is a wrought iron lattice tower on the Champ de Mars in Paris, France. It is named after the engineer Gustave Eiffel, whose company designed and built the tower. Constructed in 1889 as the entrance to the 1889 World's Fair, it was initially criticized by some of France's leading artists and intellectuals for its design, but has become a global cultural icon of France and one of the most recognisable structures in the world. The tower is the tallest structure in Paris and the most-visited paid monument in the world: 6.98 million people ascended it in 2011. The tower received its 250 millionth visitor in 2010."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/france/eiffelTower.jpg",
            "text2" : qsTr("Eiffel Tower"),
            "x" : "0.538",
            "y" : "0.304",
            "height" : "0.07",
            "width" : "0.07"
        },
    ]

    property var instructions : [
        {
            "text": qsTr("Monuments of France.")
        },
        {
            "text": qsTr("Click on location where the given Monument is located.")
        }
    ]
}
