/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property int numberOfSubLevel: 3
   property string instruction: qsTr("Districts of Italy")
   property var levels: [
      {
         "pixmapfile" : "italy/backgrounditaly.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "italy/liguria.png",
         //: Districts of Italy: Liguria
         "toolTipText" : qsTr("Liguria"),
         "x" : "0.181",
         "y" : "0.267"
      },
      {
         "pixmapfile" : "italy/piemonte.png",
         //: Districts of Italy: Piemonte
         "toolTipText" : qsTr("Piemonte"),
         "x" : "0.108",
         "y" : "0.169"
      },
      {
         "pixmapfile" : "italy/valle_d_aosta.png",
         //: Districts of Italy: Valle d'Aosta
         "toolTipText" : qsTr("Valle d'Aosta"),
         "x" : "0.063",
         "y" : "0.13"
      },
      {
         "pixmapfile" : "italy/lombardia.png",
         //: Districts of Italy: Lombardia
         "toolTipText" : qsTr("Lombardia"),
         "x" : "0.276",
         "y" : "0.134"
      },
      {
         "pixmapfile" : "italy/trentino_alto_adige.png",
         //: Districts of Italy: Trentino Alto Adige
         "toolTipText" : qsTr("Trentino Alto Adige"),
         "x" : "0.401",
         "y" : "0.07"
      },
      {
         "pixmapfile" : "italy/veneto.png",
         //: Districts of Italy: Veneto
         "toolTipText" : qsTr("Veneto"),
         "x" : "0.438",
         "y" : "0.127"
      },
      {
         "pixmapfile" : "italy/friuli_venezia_giulia.png",
         //: Districts of Italy: Friuli Venezia Giulia
         "toolTipText" : qsTr("Friuli Venezia Giulia"),
         "x" : "0.547",
         "y" : "0.093"
      },
      {
         "pixmapfile" : "italy/emilia_romagna.png",
         //: Districts of Italy: Emilia Romagna
         "toolTipText" : qsTr("Emilia Romagna"),
         "x" : "0.366",
         "y" : "0.247"
      },
      {
         "pixmapfile" : "italy/toscana.png",
         //: Districts of Italy: Toscana
         "toolTipText" : qsTr("Toscana"),
         "x" : "0.371",
         "y" : "0.341"
      },
      {
         "pixmapfile" : "italy/umbria.png",
         //: Districts of Italy: Umbria
         "toolTipText" : qsTr("Umbria"),
         "x" : "0.5",
         "y" : "0.378"
      },
      {
         "pixmapfile" : "italy/marche.png",
         //: Districts of Italy: Marche
         "toolTipText" : qsTr("Marche"),
         "x" : "0.539",
         "y" : "0.346"
      },
      {
         "pixmapfile" : "italy/lazio.png",
         //: Districts of Italy: Lazio
         "toolTipText" : qsTr("Lazio"),
         "x" : "0.513",
         "y" : "0.461"
      },
      {
         "pixmapfile" : "italy/abruzzo.png",
         //: Districts of Italy: Abruzzo
         "toolTipText" : qsTr("Abruzzo"),
         "x" : "0.612",
         "y" : "0.437"
      },
      {
         "pixmapfile" : "italy/molise.png",
         //: Districts of Italy: Molise
         "toolTipText" : qsTr("Molise"),
         "x" : "0.668",
         "y" : "0.487"
      },
      {
         "pixmapfile" : "italy/campania.png",
         //: Districts of Italy: Campania
         "toolTipText" : qsTr("Campania"),
         "x" : "0.688",
         "y" : "0.569"
      },
      {
         "pixmapfile" : "italy/puglia.png",
         //: Districts of Italy: Puglia
         "toolTipText" : qsTr("Puglia"),
         "x" : "0.849",
         "y" : "0.558"
      },
      {
         "pixmapfile" : "italy/basilicata.png",
         //: Districts of Italy: Basilicata
         "toolTipText" : qsTr("Basilicata"),
         "x" : "0.797",
         "y" : "0.589"
      },
      {
         "pixmapfile" : "italy/calabria.png",
         //: Districts of Italy: Calabria
         "toolTipText" : qsTr("Calabria"),
         "x" : "0.822",
         "y" : "0.713"
      },
      {
         "pixmapfile" : "italy/sicilia.png",
         //: Districts of Italy: Sicilia
         "toolTipText" : qsTr("Sicilia"),
         "x" : "0.598",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "italy/sardegna.png",
         //: Districts of Italy: Sardegna
         "toolTipText" : qsTr("Sardegna"),
         "x" : "0.198",
         "y" : "0.625"
      }
   ]
}
