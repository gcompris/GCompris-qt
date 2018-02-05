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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Katsushika Hokusai, Ejiri in Suruga Province - 1830-1833")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/EjiriSuruga_d3.png",
         "x" : "0.846",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_c3.png",
         "x" : "0.618",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_b3.png",
         "x" : "0.38",
         "y" : "0.752"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_a3.png",
         "x" : "0.174",
         "y" : "0.782"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_d2.png",
         "x" : "0.823",
         "y" : "0.497"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_c2.png",
         "x" : "0.616",
         "y" : "0.468"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_b2.png",
         "x" : "0.405",
         "y" : "0.468"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_a2.png",
         "x" : "0.174",
         "y" : "0.498"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_d1.png",
         "x" : "0.823",
         "y" : "0.242"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_c1.png",
         "x" : "0.616",
         "y" : "0.212"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_b1.png",
         "x" : "0.405",
         "y" : "0.212"
      },
      {
         "pixmapfile" : "image/EjiriSuruga_a1.png",
         "x" : "0.174",
         "y" : "0.212"
      }
   ]
}
