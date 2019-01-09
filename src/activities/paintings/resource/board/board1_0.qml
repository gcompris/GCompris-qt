/* GCompris
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
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
   property string instruction: qsTr("Pierre-Auguste Renoir, Bal du moulin de la Galette - 1876")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-4.png",
         "x" : "0.226",
         "y" : "0.651"
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-5.png",
         "x" : "0.504",
         "y" : "0.651"
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-3.png",
         "x" : "0.782",
         "y" : "0.327"
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-1.png",
         "x" : "0.255",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-2.png",
         "x" : "0.533",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-6.png",
         "x" : "0.781",
         "y" : "0.69"
      }
   ]
}
