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
import QtQuick 2.12

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
         "x" : "0.1861",
         "y" : "0.2787"
      },
      {
         "pixmapfile" : "italy/piedmont.svgz",
         //: Region of Italy: Piedmont
         "toolTipText" : qsTr("Piedmont"),
         "x" : "0.1248",
         "y" : "0.1827"
      },
      {
         "pixmapfile" : "italy/aosta_valley.svgz",
         //: Region of Italy: Aosta Valley
         "toolTipText" : qsTr("Aosta Valley"),
         "x" : "0.0879",
         "y" : "0.1375"
      },
      {
         "pixmapfile" : "italy/lombardy.svgz",
         //: Region of Italy: Lombardy
         "toolTipText" : qsTr("Lombardy"),
         "x" : "0.2808",
         "y" : "0.1508"
      },
      {
         "pixmapfile" : "italy/trentino-south_tyrol.svgz",
         //: Region of Italy: Trentino-South Tyrol
         "toolTipText" : qsTr("Trentino-South Tyrol"),
         "x" : "0.3936",
         "y" : "0.0854"
      },
      {
         "pixmapfile" : "italy/veneto.svgz",
         //: Region of Italy: Veneto
         "toolTipText" : qsTr("Veneto"),
         "x" : "0.4245",
         "y" : "0.145"
      },
      {
         "pixmapfile" : "italy/friuli_venezia_giulia.svgz",
         //: Region of Italy: Friuli Venezia Giulia
         "toolTipText" : qsTr("Friuli Venezia Giulia"),
         "x" : "0.5202",
         "y" : "0.1095"
      },
      {
         "pixmapfile" : "italy/emilia-romagna.svgz",
         //: Region of Italy: Emilia-Romagna
         "toolTipText" : qsTr("Emilia-Romagna"),
         "x" : "0.3572",
         "y" : "0.264"
      },
      {
         "pixmapfile" : "italy/tuscany.svgz",
         //: Region of Italy: Tuscany
         "toolTipText" : qsTr("Tuscany"),
         "x" : "0.3619",
         "y" : "0.3602"
      },
      {
         "pixmapfile" : "italy/umbria.svgz",
         //: Region of Italy: Umbria
         "toolTipText" : qsTr("Umbria"),
         "x" : "0.4816",
         "y" : "0.3985"
      },
      {
         "pixmapfile" : "italy/marche.svgz",
         //: Region of Italy: Marche
         "toolTipText" : qsTr("Marche"),
         "x" : "0.5189",
         "y" : "0.3668"
      },
      {
         "pixmapfile" : "italy/lazio.svgz",
         //: Region of Italy: Lazio
         "toolTipText" : qsTr("Lazio"),
         "x" : "0.4951",
         "y" : "0.5068"
      },
      {
         "pixmapfile" : "italy/abruzzo.svgz",
         //: Region of Italy: Abruzzo
         "toolTipText" : qsTr("Abruzzo"),
         "x" : "0.5874",
         "y" : "0.4617"
      },
      {
         "pixmapfile" : "italy/molise.svgz",
         //: Region of Italy: Molise
         "toolTipText" : qsTr("Molise"),
         "x" : "0.6409",
         "y" : "0.5128"
      },
      {
         "pixmapfile" : "italy/campania.svgz",
         //: Region of Italy: Campania
         "toolTipText" : qsTr("Campania"),
         "x" : "0.6635",
         "y" : "0.6022"
      },
      {
         "pixmapfile" : "italy/apulia.svgz",
         //: Region of Italy: Apulia
         "toolTipText" : qsTr("Apulia"),
         "x" : "0.8224",
         "y" : "0.5747"
      },
      {
         "pixmapfile" : "italy/basilicata.svgz",
         //: Region of Italy: Basilicata
         "toolTipText" : qsTr("Basilicata"),
         "x" : "0.7717",
         "y" : "0.6204"
      },
      {
         "pixmapfile" : "italy/calabria.svgz",
         //: Region of Italy: Calabria
         "toolTipText" : qsTr("Calabria"),
         "x" : "0.8073",
         "y" : "0.7569"
      },
      {
         "pixmapfile" : "italy/sicily.svgz",
         //: Region of Italy: Sicily
         "toolTipText" : qsTr("Sicily"),
         "x" : "0.5857",
         "y" : "0.8794"
      },
      {
         "pixmapfile" : "italy/sardinia.svgz",
         //: Region of Italy: Sardinia
         "toolTipText" : qsTr("Sardinia"),
         "x" : "0.1889",
         "y" : "0.6641"
      }
   ]
}
