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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Districts of Southern Italy")
   property var levels: [
      {
         "pixmapfile" : "italy/south/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "italy/south/sassari.png",
         "toolTipText" : "Sassari",
         "x" : "0.12",
         "y" : "0.328"
      },
      {
         "pixmapfile" : "italy/south/olbia-tempio.png",
         "toolTipText" : "Olbia-Tempio",
         "x" : "0.171",
         "y" : "0.299"
      },
      {
         "pixmapfile" : "italy/south/nuoro.png",
         "toolTipText" : "Nuoro",
         "x" : "0.164",
         "y" : "0.393"
      },
      {
         "pixmapfile" : "italy/south/oristano.png",
         "toolTipText" : "Oristano",
         "x" : "0.125",
         "y" : "0.433"
      },
      {
         "pixmapfile" : "italy/south/ogliastra.png",
         "toolTipText" : "Ogliastra",
         "x" : "0.19",
         "y" : "0.453"
      },
      {
         "pixmapfile" : "italy/south/cagliari.png",
         "toolTipText" : "Cagliari",
         "x" : "0.156",
         "y" : "0.53"
      },
      {
         "pixmapfile" : "italy/south/medio_campidano.png",
         "toolTipText" : "Medio_Campidano",
         "x" : "0.124",
         "y" : "0.502"
      },
      {
         "pixmapfile" : "italy/south/carbonia-iglesias.png",
         "toolTipText" : "Carbonia-Iglesias",
         "x" : "0.105",
         "y" : "0.557"
      },
      {
         "pixmapfile" : "italy/south/trapani.png",
         "toolTipText" : "Trapani",
         "x" : "0.452",
         "y" : "0.763"
      },
      {
         "pixmapfile" : "italy/south/palermo.png",
         "toolTipText" : "Palermo",
         "x" : "0.542",
         "y" : "0.761"
      },
      {
         "pixmapfile" : "italy/south/agrigento.png",
         "toolTipText" : "Agrigento",
         "x" : "0.488",
         "y" : "0.859"
      },
      {
         "pixmapfile" : "italy/south/caltanissetta.png",
         "toolTipText" : "Caltanissetta",
         "x" : "0.581",
         "y" : "0.837"
      },
      {
         "pixmapfile" : "italy/south/enna.png",
         "toolTipText" : "Enna",
         "x" : "0.616",
         "y" : "0.808"
      },
      {
         "pixmapfile" : "italy/south/catania.png",
         "toolTipText" : "Catania",
         "x" : "0.646",
         "y" : "0.819"
      },
      {
         "pixmapfile" : "italy/south/siracusa.png",
         "toolTipText" : "Siracusa",
         "x" : "0.666",
         "y" : "0.887"
      },
      {
         "pixmapfile" : "italy/south/ragusa.png",
         "toolTipText" : "Ragusa",
         "x" : "0.635",
         "y" : "0.907"
      },
      {
         "pixmapfile" : "italy/south/messina.png",
         "toolTipText" : "Messina",
         "x" : "0.656",
         "y" : "0.709"
      },
      {
         "pixmapfile" : "italy/south/reggio_calabria.png",
         "toolTipText" : "Reggio_Calabria",
         "x" : "0.76",
         "y" : "0.706"
      },
      {
         "pixmapfile" : "italy/south/vibo_valentia.png",
         "toolTipText" : "Vibo_Valentia",
         "x" : "0.761",
         "y" : "0.646"
      },
      {
         "pixmapfile" : "italy/south/catanzaro.png",
         "toolTipText" : "Catanzaro",
         "x" : "0.796",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "italy/south/crotone.png",
         "toolTipText" : "Crotone",
         "x" : "0.83",
         "y" : "0.563"
      },
      {
         "pixmapfile" : "italy/south/cosenza.png",
         "toolTipText" : "Cosenza",
         "x" : "0.785",
         "y" : "0.499"
      },
      {
         "pixmapfile" : "italy/south/potenza.png",
         "toolTipText" : "Potenza",
         "x" : "0.74",
         "y" : "0.357"
      },
      {
         "pixmapfile" : "italy/south/matera.png",
         "toolTipText" : "Matera",
         "x" : "0.79",
         "y" : "0.366"
      },
      {
         "pixmapfile" : "italy/south/foggia.png",
         "toolTipText" : "Foggia",
         "x" : "0.714",
         "y" : "0.202"
      },
      {
         "pixmapfile" : "italy/south/barlettaandriatrani.png",
         "toolTipText" : "Barletta-Andria-Trani",
         "x" : "0.77",
         "y" : "0.254"
      },
      {
         "pixmapfile" : "italy/south/bari.png",
         "toolTipText" : "Bari",
         "x" : "0.815",
         "y" : "0.29"
      },
      {
         "pixmapfile" : "italy/south/taranto.png",
         "toolTipText" : "Taranto",
         "x" : "0.859",
         "y" : "0.354"
      },
      {
         "pixmapfile" : "italy/south/brindisi.png",
         "toolTipText" : "Brindisi",
         "x" : "0.898",
         "y" : "0.338"
      },
      {
         "pixmapfile" : "italy/south/lecce.png",
         "toolTipText" : "Lecce",
         "x" : "0.935",
         "y" : "0.413"
      },
      {
         "pixmapfile" : "italy/south/isernia.png",
         "toolTipText" : "Isernia",
         "x" : "0.6",
         "y" : "0.182"
      },
      {
         "pixmapfile" : "italy/south/campobasso.png",
         "toolTipText" : "Campobasso",
         "x" : "0.644",
         "y" : "0.169"
      },
      {
         "pixmapfile" : "italy/south/caserta.png",
         "toolTipText" : "Caserta",
         "x" : "0.593",
         "y" : "0.249"
      },
      {
         "pixmapfile" : "italy/south/benevento.png",
         "toolTipText" : "Benevento",
         "x" : "0.641",
         "y" : "0.248"
      },
      {
         "pixmapfile" : "italy/south/avellino.png",
         "toolTipText" : "Avellino",
         "x" : "0.67",
         "y" : "0.285"
      },
      {
         "pixmapfile" : "italy/south/napoli.png",
         "toolTipText" : "Napoli",
         "x" : "0.6",
         "y" : "0.32"
      },
      {
         "pixmapfile" : "italy/south/salerno.png",
         "toolTipText" : "Salerno",
         "x" : "0.678",
         "y" : "0.373"
      }
   ]
}
