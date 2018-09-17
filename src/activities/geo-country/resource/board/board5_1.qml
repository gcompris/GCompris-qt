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
   property string instruction: qsTr("Eastern Districts of Turkey")
   property var levels: [
      {
         "pixmapfile" : "turkey/turkey-east.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "turkey/van.png",
         "toolTipText" : "Van",
         "x" : "0.85",
         "y" : "0.492"
      },
      {
         "pixmapfile" : "turkey/tunceli.png",
         "toolTipText" : "Tunceli",
         "x" : "0.413",
         "y" : "0.433"
      },
      {
         "pixmapfile" : "turkey/trabzon.png",
         "toolTipText" : "Trabzon",
         "x" : "0.435",
         "y" : "0.21"
      },
      {
         "pixmapfile" : "turkey/tokat.png",
         "toolTipText" : "Tokat",
         "x" : "0.098",
         "y" : "0.287"
      },
      {
         "pixmapfile" : "turkey/sivas.png",
         "toolTipText" : "Sivas",
         "x" : "0.163",
         "y" : "0.405"
      },
      {
         "pixmapfile" : "turkey/sirnak.png",
         "toolTipText" : "Sirnak",
         "x" : "0.733",
         "y" : "0.662"
      },
      {
         "pixmapfile" : "turkey/siirt.png",
         "toolTipText" : "Siirt",
         "x" : "0.7",
         "y" : "0.597"
      },
      {
         "pixmapfile" : "turkey/sanliurfa.png",
         "toolTipText" : "Sanliurfa",
         "x" : "0.368",
         "y" : "0.69"
      },
      {
         "pixmapfile" : "turkey/rize.png",
         "toolTipText" : "Rize",
         "x" : "0.543",
         "y" : "0.177"
      },
      {
         "pixmapfile" : "turkey/osmaniye.png",
         "toolTipText" : "Osmaniye",
         "x" : "0.065",
         "y" : "0.695"
      },
      {
         "pixmapfile" : "turkey/ordu.png",
         "toolTipText" : "Ordu",
         "x" : "0.188",
         "y" : "0.231"
      },
      {
         "pixmapfile" : "turkey/mus.png",
         "toolTipText" : "Mus",
         "x" : "0.67",
         "y" : "0.444"
      },
      {
         "pixmapfile" : "turkey/mardin.png",
         "toolTipText" : "Mardin",
         "x" : "0.565",
         "y" : "0.685"
      },
      {
         "pixmapfile" : "turkey/malatya.png",
         "toolTipText" : "Malatya",
         "x" : "0.27",
         "y" : "0.528"
      },
      {
         "pixmapfile" : "turkey/kilis.png",
         "toolTipText" : "Kilis",
         "x" : "0.158",
         "y" : "0.774"
      },
      {
         "pixmapfile" : "turkey/kars.png",
         "toolTipText" : "Kars",
         "x" : "0.76",
         "y" : "0.223"
      },
      {
         "pixmapfile" : "turkey/kahramanmaras.png",
         "toolTipText" : "Kahramanmaras",
         "x" : "0.14",
         "y" : "0.621"
      },
      {
         "pixmapfile" : "turkey/igdir.png",
         "toolTipText" : "Igdir",
         "x" : "0.875",
         "y" : "0.297"
      },
      {
         "pixmapfile" : "turkey/hatay.png",
         "toolTipText" : "Hatay",
         "x" : "0.073",
         "y" : "0.836"
      },
      {
         "pixmapfile" : "turkey/hakkari.png",
         "toolTipText" : "Hakkari",
         "x" : "0.903",
         "y" : "0.633"
      },
      {
         "pixmapfile" : "turkey/gumushane.png",
         "toolTipText" : "Gümüshane",
         "x" : "0.38",
         "y" : "0.277"
      },
      {
         "pixmapfile" : "turkey/giresun.png",
         "toolTipText" : "Giresun",
         "x" : "0.298",
         "y" : "0.251"
      },
      {
         "pixmapfile" : "turkey/gaziantep.png",
         "toolTipText" : "Gaziantep",
         "x" : "0.173",
         "y" : "0.744"
      },
      {
         "pixmapfile" : "turkey/erzurum.png",
         "toolTipText" : "Erzurum",
         "x" : "0.605",
         "y" : "0.29"
      },
      {
         "pixmapfile" : "turkey/erzincan.png",
         "toolTipText" : "Erzincan",
         "x" : "0.395",
         "y" : "0.382"
      },
      {
         "pixmapfile" : "turkey/elazig.png",
         "toolTipText" : "Elazig",
         "x" : "0.39",
         "y" : "0.49"
      },
      {
         "pixmapfile" : "turkey/diyarbakir.png",
         "toolTipText" : "Diyarbakir",
         "x" : "0.493",
         "y" : "0.577"
      },
      {
         "pixmapfile" : "turkey/bitlis.png",
         "toolTipText" : "Bitlis",
         "x" : "0.715",
         "y" : "0.505"
      },
      {
         "pixmapfile" : "turkey/bingol.png",
         "toolTipText" : "Bingöl",
         "x" : "0.525",
         "y" : "0.449"
      },
      {
         "pixmapfile" : "turkey/bayburt.png",
         "toolTipText" : "Bayburt",
         "x" : "0.478",
         "y" : "0.279"
      },
      {
         "pixmapfile" : "turkey/batman.png",
         "toolTipText" : "Batman",
         "x" : "0.618",
         "y" : "0.579"
      },
      {
         "pixmapfile" : "turkey/artvin.png",
         "toolTipText" : "Artvin",
         "x" : "0.635",
         "y" : "0.162"
      },
      {
         "pixmapfile" : "turkey/ardahan.png",
         "toolTipText" : "Ardahan",
         "x" : "0.74",
         "y" : "0.138"
      },
      {
         "pixmapfile" : "turkey/agri.png",
         "toolTipText" : "Agri",
         "x" : "0.818",
         "y" : "0.369"
      },
      {
         "pixmapfile" : "turkey/adiyaman.png",
         "toolTipText" : "Adiyaman",
         "x" : "0.288",
         "y" : "0.626"
      }
   ]
}
