/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (new SVG map)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Regions of Italy")
   property var levels: [
      {
         "pixmapfile" : "italy/italy.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "italy/liguria.svgz",
         //: Region of Italy: Liguria
         "toolTipText" : qsTr("Liguria"),
         "x" : "0.1942",
         "y" : "0.2583"
      },
      {
         "pixmapfile" : "italy/piedmont.svgz",
         //: Region of Italy: Piedmont
         "toolTipText" : qsTr("Piedmont"),
         "x" : "0.1244",
         "y" : "0.173"
      },
      {
         "pixmapfile" : "italy/aosta_valley.svgz",
         //: Region of Italy: Aosta Valley
         "toolTipText" : qsTr("Aosta Valley"),
         "x" : "0.08",
         "y" : "0.1346"
      },
      {
         "pixmapfile" : "italy/lombardy.svgz",
         //: Region of Italy: Lombardy
         "toolTipText" : qsTr("Lombardy"),
         "x" : "0.2893",
         "y" : "0.1404"
      },
      {
         "pixmapfile" : "italy/trentino-south_tyrol.svgz",
         //: Region of Italy: Trentino-South Tyrol
         "toolTipText" : qsTr("Trentino-South Tyrol"),
         "x" : "0.4077",
         "y" : "0.0807"
      },
      {
         "pixmapfile" : "italy/veneto.svgz",
         //: Region of Italy: Veneto
         "toolTipText" : qsTr("Veneto"),
         "x" : "0.4427",
         "y" : "0.134"
      },
      {
         "pixmapfile" : "italy/friuli_venezia_giulia.svgz",
         //: Region of Italy: Friuli Venezia Giulia
         "toolTipText" : qsTr("Friuli Venezia Giulia"),
         "x" : "0.5442",
         "y" : "0.1028"
      },
      {
         "pixmapfile" : "italy/emilia-romagna.svgz",
         //: Region of Italy: Emilia-Romagna
         "toolTipText" : qsTr("Emilia-Romagna"),
         "x" : "0.3712",
         "y" : "0.2412"
      },
      {
         "pixmapfile" : "italy/tuscany.svgz",
         //: Region of Italy: Tuscany
         "toolTipText" : qsTr("Tuscany"),
         "x" : "0.3754",
         "y" : "0.3303"
      },
      {
         "pixmapfile" : "italy/umbria.svgz",
         //: Region of Italy: Umbria
         "toolTipText" : qsTr("Umbria"),
         "x" : "0.5004",
         "y" : "0.3603"
      },
      {
         "pixmapfile" : "italy/marche.svgz",
         //: Region of Italy: Marche
         "toolTipText" : qsTr("Marche"),
         "x" : "0.5386",
         "y" : "0.3322"
      },
      {
         "pixmapfile" : "italy/lazio.svgz",
         //: Region of Italy: Lazio
         "toolTipText" : qsTr("Lazio"),
         "x" : "0.5133",
         "y" : "0.4572"
      },
      {
         "pixmapfile" : "italy/abruzzo.svgz",
         //: Region of Italy: Abruzzo
         "toolTipText" : qsTr("Abruzzo"),
         "x" : "0.6071",
         "y" : "0.418"
      },
      {
         "pixmapfile" : "italy/molise.svgz",
         //: Region of Italy: Molise
         "toolTipText" : qsTr("Molise"),
         "x" : "0.6597",
         "y" : "0.4651"
      },
      {
         "pixmapfile" : "italy/campania.svgz",
         //: Region of Italy: Campania
         "toolTipText" : qsTr("Campania"),
         "x" : "0.6785",
         "y" : "0.5448"
      },
      {
         "pixmapfile" : "italy/apulia.svgz",
         //: Region of Italy: Apulia
         "toolTipText" : qsTr("Apulia"),
         "x" : "0.8353",
         "y" : "0.5235"
      },
      {
         "pixmapfile" : "italy/basilicata.svgz",
         //: Region of Italy: Basilicata
         "toolTipText" : qsTr("Basilicata"),
         "x" : "0.7848",
         "y" : "0.5639"
      },
      {
         "pixmapfile" : "italy/calabria.svgz",
         //: Region of Italy: Calabria
         "toolTipText" : qsTr("Calabria"),
         "x" : "0.8104",
         "y" : "0.686"
      },
      {
         "pixmapfile" : "italy/sicily.svgz",
         //: Region of Italy: Sicily
         "toolTipText" : qsTr("Sicily"),
         "x" : "0.5981",
         "y" : "0.8408"
      },
      {
         "pixmapfile" : "italy/sardinia.svgz",
         //: Region of Italy: Sardinia
         "toolTipText" : qsTr("Sardinia"),
         "x" : "0.2099",
         "y" : "0.5994"
      }
   ]
}
