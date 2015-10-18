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
   property string instruction: qsTr("The 7 Wonders of World.")
   property variant levels: [
      {
         "pixmapfile" : "wonders/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "wonders/chickenitzamexico.png",
         "toolTipText" : "Chichén Itzá, Mexico",
         "x" : "0.214",
         "y" : "0.542",
         "heigth" : "0.15",
         "width" : "0.15"
      },
      {
         "pixmapfile" : "wonders/romancolosseumrome.png",
         "toolTipText" : "Roman Colosseum, Rome",
         "x" : "0.496",
         "y" : "0.408",
         "heigth" : "0.08",
         "width" : "0.08"
      },
      {
         "pixmapfile" : "wonders/christtheredeemerbrazil.png",
         "toolTipText" : "Christ the Redeemer, Brazil",
         "x" : "0.351",
         "y" : "0.736",
         "heigth" : "0.08",
         "width" : "0.08"
      },
      {
         "pixmapfile" : "wonders/greatwallofchina.png",
         "toolTipText" : "The Great Wall of China, China",
         "x" : "0.726",
         "y" : "0.42",
         "heigth" : "0.11",
         "width" : "0.11"
      },
      {
         "pixmapfile" : "wonders/machupicchu.png",
         "toolTipText" : "Machu Picchu, Peru",
         "x" : "0.276",
         "y" : "0.711",
         "heigth" : "0.15",
         "width" : "0.15"
      },
      {
         "pixmapfile" : "wonders/petrajordan.png",
         "toolTipText" : "Petra, Jordan",
         "x" : "0.560",
         "y" : "0.453",
         "heigth" : "0.15",
         "width" : "0.15"
      },
      {
         "pixmapfile" : "wonders/tajmahal.png",
         "toolTipText" : "Taj Mahal, India",
         "x" : "0.672",
         "y" : "0.476",
         "heigth" : "0.11",
         "width" : "0.11"
      },
    ]
}
