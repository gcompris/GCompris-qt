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
   property string instruction: qsTr("Regions of Spain")
   property var levels: [
      {
         "pixmapfile" : "spain/spain_spain.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile": "spain/spain_andalucia.svgz",
           //: Region of Spain: Andalucía
           "toolTipText" : qsTr("Andalucía"),
          "x": "0.3407",
          "y": 0.7071
      },
      {
          "pixmapfile": "spain/spain_madrid.svgz",
           //: Region of Spain: Madrid
           "toolTipText" : qsTr("Comunidad de Madrid"),
          "x": "0.3985",
          "y": 0.3761
      },
      {
          "pixmapfile": "spain/spain_galicia.svgz",
           //: Region of Spain: Galicia
           "toolTipText" : qsTr("Galicia"),
          "x": "0.1094",
          "y": 0.1278
      },
      {
          "pixmapfile": "spain/spain_castilla_y_leon.svgz",
           //: Region of Spain: Castilla y León
           "toolTipText" : qsTr("Castilla y León"),
          "x": "0.3559",
          "y": 0.2543
      },
      {
          "pixmapfile": "spain/spain_castilla_la_mancha.svgz",
           //: Region of Spain: Castilla-La Mancha
           "toolTipText" : qsTr("Castilla-La Mancha"),
          "x": "0.4458",
          "y": 0.4644
      },
      {
          "pixmapfile": "spain/spain_cataluña.svgz",
           //: Region of Spain: Cataluña
           "toolTipText" : qsTr("Cataluña"),
          "x": "0.7814",
          "y": 0.2429
      },
      {
          "pixmapfile": "spain/spain_aragon.svgz",
           //: Region of Spain: Aragón
           "toolTipText" : qsTr("Aragón"),
          "x": "0.6118",
          "y": 0.2803
      },
      {
          "pixmapfile": "spain/spain_valencia.svgz",
           //: Region of Spain: Comunitat Valenciana
           "toolTipText" : qsTr("Comunitat Valenciana"),
          "x": "0.632",
          "y": 0.4973
      },
      {
          "pixmapfile": "spain/spain_murcia.svgz",
           //: Region of Spain: Región de Murcia
           "toolTipText" : qsTr("Región de Murcia"),
          "x": "0.5667",
          "y": 0.6326
      },
      {
          "pixmapfile": "spain/spain_asturias.svgz",
           //: Region of Spain: Principado de Asturias
           "toolTipText" : qsTr("Principado de Asturias"),
          "x": "0.2594",
          "y": 0.0816
      },
      {
          "pixmapfile": "spain/spain_pais_vasco.svgz",
           //: Region of Spain: País Vasco
           "toolTipText" : qsTr("País Vasco"),
          "x": "0.4808",
          "y": 0.1177
      },
      {
          "pixmapfile": "spain/spain_la_rioja.svgz",
           //: Region of Spain: La Rioja
           "toolTipText" : qsTr("La Rioja"),
          "x": "0.4942",
          "y": 0.1888
      },
      {
          "pixmapfile": "spain/spain_cantabria.svgz",
           //: Region of Spain: Cantabria
           "toolTipText" : qsTr("Cantabria"),
          "x": "0.3846",
          "y": 0.1007
      },
      {
          "pixmapfile": "spain/spain_navarra.svgz",
           //: Region of Spain: Comunidad Foral de Navarra
           "toolTipText" : qsTr("Comunidad Foral de Navarra"),
          "x": "0.5479",
          "y": 0.1528
      },
      {
          "pixmapfile": "spain/spain_extremadura.svgz",
           //: Region of Spain: Extremadura
           "toolTipText" : qsTr("Extremadura"),
          "x": "0.2333",
          "y": 0.5109
      },
      {
          "pixmapfile": "spain/spain_canarias.svgz",
           //: Region of Spain: Canarias
           "toolTipText" : qsTr("Canarias"),
          "x": "0.7704",
          "y": 0.9013
      },
      {
          "pixmapfile": "spain/spain_baleares.svgz",
           //: Region of Spain: Illes Balears
           "toolTipText" : qsTr("Illes Balears"),
          "x": "0.8685",
          "y": 0.4788
      },
      {
          "pixmapfile": "spain/spain_ceuta.svgz",
           //: Region of Spain: Ciudad Autónoma de Ceuta
           "toolTipText" : qsTr("Ciudad Autónoma de Ceuta"),
          "x": "0.2815",
          "y": 0.8621
      },
      {
          "pixmapfile": "spain/spain_melilla.svgz",
           //: Region of Spain: Ciudad Autónoma de Melilla
           "toolTipText" : qsTr("Ciudad Autónoma de Melilla"),
          "x": "0.4621",
          "y": 0.9273
      }
   ]
}
