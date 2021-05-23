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
   property string instruction: qsTr("Districts of Southern Italy")
   property var levels: [
      {
         "pixmapfile" : "italy/south/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "italy/south/sassari.png",
         //: District of Southern Italy: Sassari
         "toolTipText" : qsTr("Sassari"),
         "x" : "0.12",
         "y" : "0.328"
      },
      {
         "pixmapfile" : "italy/south/olbia-tempio.png",
         //: District of Southern Italy: Olbia-Tempio
         "toolTipText" : qsTr("Olbia-Tempio"),
         "x" : "0.171",
         "y" : "0.299"
      },
      {
         "pixmapfile" : "italy/south/nuoro.png",
         //: District of Southern Italy: Nuoro
         "toolTipText" : qsTr("Nuoro"),
         "x" : "0.164",
         "y" : "0.393"
      },
      {
         "pixmapfile" : "italy/south/oristano.png",
         //: District of Southern Italy: Oristano
         "toolTipText" : qsTr("Oristano"),
         "x" : "0.125",
         "y" : "0.433"
      },
      {
         "pixmapfile" : "italy/south/ogliastra.png",
         //: District of Southern Italy: Ogliastra
         "toolTipText" : qsTr("Ogliastra"),
         "x" : "0.19",
         "y" : "0.453"
      },
      {
         "pixmapfile" : "italy/south/cagliari.png",
         //: District of Southern Italy: Cagliari
         "toolTipText" : qsTr("Cagliari"),
         "x" : "0.156",
         "y" : "0.53"
      },
      {
         "pixmapfile" : "italy/south/medio_campidano.png",
         //: District of Southern Italy: Medio Campidano
         "toolTipText" : qsTr("Medio Campidano"),
         "x" : "0.124",
         "y" : "0.502"
      },
      {
         "pixmapfile" : "italy/south/carbonia-iglesias.png",
         //: District of Southern Italy: Carbonia-Iglesias
         "toolTipText" : qsTr("Carbonia-Iglesias"),
         "x" : "0.105",
         "y" : "0.557"
      },
      {
         "pixmapfile" : "italy/south/trapani.png",
         //: District of Southern Italy: Trapani
         "toolTipText" : qsTr("Trapani"),
         "x" : "0.452",
         "y" : "0.763"
      },
      {
         "pixmapfile" : "italy/south/palermo.png",
         //: District of Southern Italy: Palermo
         "toolTipText" : qsTr("Palermo"),
         "x" : "0.542",
         "y" : "0.761"
      },
      {
         "pixmapfile" : "italy/south/agrigento.png",
         //: District of Southern Italy: Agrigento
         "toolTipText" : qsTr("Agrigento"),
         "x" : "0.488",
         "y" : "0.859"
      },
      {
         "pixmapfile" : "italy/south/caltanissetta.png",
         //: District of Southern Italy: Caltanissetta
         "toolTipText" : qsTr("Caltanissetta"),
         "x" : "0.581",
         "y" : "0.837"
      },
      {
         "pixmapfile" : "italy/south/enna.png",
         //: District of Southern Italy: Enna
         "toolTipText" : qsTr("Enna"),
         "x" : "0.616",
         "y" : "0.808"
      },
      {
         "pixmapfile" : "italy/south/catania.png",
         //: District of Southern Italy: Catania
         "toolTipText" : qsTr("Catania"),
         "x" : "0.646",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "italy/south/siracusa.png",
         //: District of Southern Italy: Siracusa
         "toolTipText" : qsTr("Siracusa"),
         "x" : "0.666",
         "y" : "0.887"
      },
      {
         "pixmapfile" : "italy/south/ragusa.png",
         //: District of Southern Italy: Ragusa
         "toolTipText" : qsTr("Ragusa"),
         "x" : "0.635",
         "y" : "0.907"
      },
      {
         "pixmapfile" : "italy/south/messina.png",
         //: District of Southern Italy: Messina
         "toolTipText" : qsTr("Messina"),
         "x" : "0.656",
         "y" : "0.709"
      },
      {
         "pixmapfile" : "italy/south/reggio_calabria.png",
         //: District of Southern Italy: Reggio Calabria
         "toolTipText" : qsTr("Reggio Calabria"),
         "x" : "0.76",
         "y" : "0.706"
      },
      {
         "pixmapfile" : "italy/south/vibo_valentia.png",
         //: District of Southern Italy: Vibo Valentia
         "toolTipText" : qsTr("Vibo Valentia"),
         "x" : "0.761",
         "y" : "0.646"
      },
      {
         "pixmapfile" : "italy/south/catanzaro.png",
         //: District of Southern Italy: Catanzaro
         "toolTipText" : qsTr("Catanzaro"),
         "x" : "0.796",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "italy/south/crotone.png",
         //: District of Southern Italy: Crotone
         "toolTipText" : qsTr("Crotone"),
         "x" : "0.83",
         "y" : "0.563"
      },
      {
         "pixmapfile" : "italy/south/cosenza.png",
         //: District of Southern Italy: Cosenza
         "toolTipText" : qsTr("Cosenza"),
         "x" : "0.785",
         "y" : "0.499"
      },
      {
         "pixmapfile" : "italy/south/potenza.png",
         //: District of Southern Italy: Potenza
         "toolTipText" : qsTr("Potenza"),
         "x" : "0.74",
         "y" : "0.357"
      },
      {
         "pixmapfile" : "italy/south/matera.png",
         //: District of Southern Italy: Matera
         "toolTipText" : qsTr("Matera"),
         "x" : "0.79",
         "y" : "0.366"
      },
      {
         "pixmapfile" : "italy/south/foggia.png",
         //: District of Southern Italy: Foggia
         "toolTipText" : qsTr("Foggia"),
         "x" : "0.714",
         "y" : "0.202"
      },
      {
         "pixmapfile" : "italy/south/barlettaandriatrani.png",
         //: District of Southern Italy: Barletta-Andria-Trani
         "toolTipText" : qsTr("Barletta-Andria-Trani"),
         "x" : "0.77",
         "y" : "0.254"
      },
      {
         "pixmapfile" : "italy/south/bari.png",
         //: District of Southern Italy: Bari
         "toolTipText" : qsTr("Bari"),
         "x" : "0.815",
         "y" : "0.29"
      },
      {
         "pixmapfile" : "italy/south/taranto.png",
         //: District of Southern Italy: Taranto
         "toolTipText" : qsTr("Taranto"),
         "x" : "0.859",
         "y" : "0.354"
      },
      {
         "pixmapfile" : "italy/south/brindisi.png",
         //: District of Southern Italy: Brindisi
         "toolTipText" : qsTr("Brindisi"),
         "x" : "0.898",
         "y" : "0.338"
      },
      {
         "pixmapfile" : "italy/south/lecce.png",
         //: District of Southern Italy: Lecce
         "toolTipText" : qsTr("Lecce"),
         "x" : "0.935",
         "y" : "0.413"
      },
      {
         "pixmapfile" : "italy/south/isernia.png",
         //: District of Southern Italy: Isernia
         "toolTipText" : qsTr("Isernia"),
         "x" : "0.6",
         "y" : "0.182"
      },
      {
         "pixmapfile" : "italy/south/campobasso.png",
         //: District of Southern Italy: Campobasso
         "toolTipText" : qsTr("Campobasso"),
         "x" : "0.644",
         "y" : "0.169"
      },
      {
         "pixmapfile" : "italy/south/caserta.png",
         //: District of Southern Italy: Caserta
         "toolTipText" : qsTr("Caserta"),
         "x" : "0.593",
         "y" : "0.249"
      },
      {
         "pixmapfile" : "italy/south/benevento.png",
         //: District of Southern Italy: Benevento
         "toolTipText" : qsTr("Benevento"),
         "x" : "0.641",
         "y" : "0.248"
      },
      {
         "pixmapfile" : "italy/south/avellino.png",
         //: District of Southern Italy: Avellino
         "toolTipText" : qsTr("Avellino"),
         "x" : "0.67",
         "y" : "0.285"
      },
      {
         "pixmapfile" : "italy/south/napoli.png",
         //: District of Southern Italy: Napoli
         "toolTipText" : qsTr("Napoli"),
         "x" : "0.6",
         "y" : "0.32"
      },
      {
         "pixmapfile" : "italy/south/salerno.png",
         //: District of Southern Italy: Salerno
         "toolTipText" : qsTr("Salerno"),
         "x" : "0.678",
         "y" : "0.373"
      }
   ]
}
