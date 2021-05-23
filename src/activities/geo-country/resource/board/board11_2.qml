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
   property string instruction: qsTr("Districts of Central Italy")
   property var levels: [
      {
         "pixmapfile" : "italy/central/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "italy/central/massa-carrara.png",
         //: District of Central Italy: Massa-Carrara
         "toolTipText" : qsTr("Massa-Carrara"),
         "x" : "0.199",
         "y" : "0.159"
      },
      {
         "pixmapfile" : "italy/central/lucca.png",
         //: District of Central Italy: Lucca
         "toolTipText" : qsTr("Lucca"),
         "x" : "0.259",
         "y" : "0.213"
      },
      {
         "pixmapfile" : "italy/central/pistoia.png",
         //: District of Central Italy: Pistoia
         "toolTipText" : qsTr("Pistoia"),
         "x" : "0.313",
         "y" : "0.225"
      },
      {
         "pixmapfile" : "italy/central/prato.png",
         //: District of Central Italy: Prato
         "toolTipText" : qsTr("Prato"),
         "x" : "0.343",
         "y" : "0.239"
      },
      {
         "pixmapfile" : "italy/central/firenze.png",
         //: District of Central Italy: Firenze
         "toolTipText" : qsTr("Firenze"),
         "x" : "0.358",
         "y" : "0.262"
      },
      {
         "pixmapfile" : "italy/central/pisa.png",
         //: District of Central Italy: Pisa
         "toolTipText" : qsTr("Pisa"),
         "x" : "0.283",
         "y" : "0.355"
      },
      {
         "pixmapfile" : "italy/central/livorno.png",
         //: District of Central Italy: Livorno
         "toolTipText" : qsTr("Livorno"),
         "x" : "0.235",
         "y" : "0.48"
      },
      {
         "pixmapfile" : "italy/central/arezzo.png",
         //: District of Central Italy: Arezzo
         "toolTipText" : qsTr("Arezzo"),
         "x" : "0.447",
         "y" : "0.334"
      },
      {
         "pixmapfile" : "italy/central/siena.png",
         //: District of Central Italy: Siena
         "toolTipText" : qsTr("Siena"),
         "x" : "0.389",
         "y" : "0.43"
      },
      {
         "pixmapfile" : "italy/central/grosseto.png",
         //: District of Central Italy: Grosseto
         "toolTipText" : qsTr("Grosseto"),
         "x" : "0.36",
         "y" : "0.539"
      },
      {
         "pixmapfile" : "italy/central/terni.png",
         //: District of Central Italy: Terni
         "toolTipText" : qsTr("Terni"),
         "x" : "0.512",
         "y" : "0.561"
      },
      {
         "pixmapfile" : "italy/central/perugia.png",
         //: District of Central Italy: Perugia
         "toolTipText" : qsTr("Perugia"),
         "x" : "0.537",
         "y" : "0.446"
      },
      {
         "pixmapfile" : "italy/central/pesaro-urbino.png",
         //: District of Central Italy: Pesaro-Urbino
         "toolTipText" : qsTr("Pesaro-Urbino"),
         "x" : "0.55",
         "y" : "0.296"
      },
      {
         "pixmapfile" : "italy/central/ancona.png",
         //: District of Central Italy: Ancona
         "toolTipText" : qsTr("Ancona"),
         "x" : "0.617",
         "y" : "0.35"
      },
      {
         "pixmapfile" : "italy/central/macerata.png",
         //: District of Central Italy: Macerata
         "toolTipText" : qsTr("Macerata"),
         "x" : "0.63",
         "y" : "0.426"
      },
      {
         "pixmapfile" : "italy/central/fermo.png",
         //: District of Central Italy: Fermo
         "toolTipText" : qsTr("Fermo"),
         "x" : "0.663",
         "y" : "0.447"
      },
      {
         "pixmapfile" : "italy/central/ascoli_piceno.png",
         //: District of Central Italy: Ascoli Piceno
         "toolTipText" : qsTr("Ascoli Piceno"),
         "x" : "0.665",
         "y" : "0.499"
      },
      {
         "pixmapfile" : "italy/central/viterbo.png",
         //: District of Central Italy: Viterbo
         "toolTipText" : qsTr("Viterbo"),
         "x" : "0.459",
         "y" : "0.6"
      },
      {
         "pixmapfile" : "italy/central/rieti.png",
         //: District of Central Italy: Rieti
         "toolTipText" : qsTr("Rieti"),
         "x" : "0.583",
         "y" : "0.621"
      },
      {
         "pixmapfile" : "italy/central/roma.png",
         //: District of Central Italy: Roma
         "toolTipText" : qsTr("Roma"),
         "x" : "0.528",
         "y" : "0.756"
      },
      {
         "pixmapfile" : "italy/central/frosinone.png",
         //: District of Central Italy: Frosinone
         "toolTipText" : qsTr("Frosinone"),
         "x" : "0.658",
         "y" : "0.82"
      },
      {
         "pixmapfile" : "italy/central/latina.png",
         //: District of Central Italy: Latina
         "toolTipText" : qsTr("Latina"),
         "x" : "0.62",
         "y" : "0.858"
      },
      {
         "pixmapfile" : "italy/central/teramo.png",
         //: District of Central Italy: Teramo
         "toolTipText" : qsTr("Teramo"),
         "x" : "0.689",
         "y" : "0.556"
      },
      {
         "pixmapfile" : "italy/central/pescara.png",
         //: District of Central Italy: Pescara
         "toolTipText" : qsTr("Pescara"),
         "x" : "0.723",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "italy/central/chieti.png",
         //: District of Central Italy: Chieti
         "toolTipText" : qsTr("Chieti"),
         "x" : "0.777",
         "y" : "0.696"
      },
      {
         "pixmapfile" : "italy/central/l_aquila.png",
         //: District of Central Italy: L Aquila
         "toolTipText" : qsTr("L Aquila"),
         "x" : "0.676",
         "y" : "0.685"
      }
   ]
}
