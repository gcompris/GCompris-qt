/* GCompris
 *
 * SPDX-FileCopyrightText: 2022 Jesús Espino <jespinog@gmail.com>
 *
 * Authors:
 *   Jesús Espino <jespinog@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
   property string instruction: qsTr("Autonomous communities or cities of Spain")
   property var levels: [
      {
         "pixmapfile" : "spain/spain_spain.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile": "spain/spain_andalucia.svgz",
          //: Autonomous communities of Spain: Andalusia
          "toolTipText" : qsTr("Andalusia"),
          "x": "0.3407",
          "y": "0.7071"
      },
      {
          "pixmapfile": "spain/spain_madrid.svgz",
          //: Autonomous communities of Spain: Madrid
          "toolTipText" : qsTr("Madrid"),
          "x": "0.3985",
          "y": "0.3761"
      },
      {
          "pixmapfile": "spain/spain_galicia.svgz",
          //: Autonomous communities of Spain: Galicia
          "toolTipText" : qsTr("Galicia"),
          "x": "0.1094",
          "y": "0.1278"
      },
      {
          "pixmapfile": "spain/spain_castilla_y_leon.svgz",
          //: Autonomous communities of Spain: Castile and León
          "toolTipText" : qsTr("Castile and León"),
          "x": "0.3559",
          "y": "0.2543"
      },
      {
          "pixmapfile": "spain/spain_castilla_la_mancha.svgz",
          //: Autonomous communities of Spain: Castilla-La Mancha
          "toolTipText" : qsTr("Castilla-La Mancha"),
          "x": "0.4458",
          "y": "0.4644"
      },
      {
          "pixmapfile": "spain/spain_cataluna.svgz",
          //: Autonomous communities of Spain: Catalonia
          "toolTipText" : qsTr("Catalonia"),
          "x": "0.7814",
          "y": "0.2429"
      },
      {
          "pixmapfile": "spain/spain_aragon.svgz",
          //: Autonomous communities of Spain: Aragon
          "toolTipText" : qsTr("Aragon"),
          "x": "0.6118",
          "y": "0.2803"
      },
      {
          "pixmapfile": "spain/spain_valencia.svgz",
          //: Autonomous communities of Spain: Valencia
          "toolTipText" : qsTr("Valencia"),
          "x": "0.632",
          "y": "0.4973"
      },
      {
          "pixmapfile": "spain/spain_murcia.svgz",
          //: Autonomous communities of Spain: Murcia
          "toolTipText" : qsTr("Murcia"),
          "x": "0.5667",
          "y": "0.6326"
      },
      {
          "pixmapfile": "spain/spain_asturias.svgz",
          //: Autonomous communities of Spain: Asturias
          "toolTipText" : qsTr("Asturias"),
          "x": "0.2594",
          "y": "0.0816"
      },
      {
          "pixmapfile": "spain/spain_pais_vasco.svgz",
          //: Autonomous communities of Spain: Basque Country
          "toolTipText" : qsTr("Basque Country"),
          "x": "0.4808",
          "y": "0.1177"
      },
      {
          "pixmapfile": "spain/spain_la_rioja.svgz",
          //: Autonomous communities of Spain: La Rioja
          "toolTipText" : qsTr("La Rioja"),
          "x": "0.4942",
          "y": "0.1888"
      },
      {
          "pixmapfile": "spain/spain_cantabria.svgz",
          //: Autonomous communities of Spain: Cantabria
          "toolTipText" : qsTr("Cantabria"),
          "x": "0.3846",
          "y": "0.1007"
      },
      {
          "pixmapfile": "spain/spain_navarra.svgz",
          //: Autonomous communities of Spain: Navarre
          "toolTipText" : qsTr("Navarre"),
          "x": "0.5479",
          "y": "0.1528"
      },
      {
          "pixmapfile": "spain/spain_extremadura.svgz",
          //: Autonomous communities of Spain: Extremadura
          "toolTipText" : qsTr("Extremadura"),
          "x": "0.2333",
          "y": "0.5109"
      },
      {
          "pixmapfile": "spain/spain_canarias.svgz",
          //: Autonomous communities of Spain: Canary Islands
          "toolTipText" : qsTr("Canary Islands"),
          "x": "0.7704",
          "y": "0.9013"
      },
      {
          "pixmapfile": "spain/spain_baleares.svgz",
          //: Autonomous communities of Spain: Balearic Islands
          "toolTipText" : qsTr("Balearic Islands"),
          "x": "0.8685",
          "y": "0.4788"
      },
      {
          "pixmapfile": "spain/spain_ceuta.svgz",
          //: Autonomous communities of Spain: Ceuta
          "toolTipText" : qsTr("Ceuta"),
          "x": "0.2815",
          "y": "0.8621"
      },
      {
          "pixmapfile": "spain/spain_melilla.svgz",
          //: Autonomous communities of Spain: Melilla
          "toolTipText" : qsTr("Melilla"),
          "x": "0.4621",
          "y": "0.9273"
      }
   ]
}
