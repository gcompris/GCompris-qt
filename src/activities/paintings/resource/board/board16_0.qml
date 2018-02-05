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
   property string instruction: qsTr("Albrecht Dürer, Lion - 1494")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_d4.png",
         "x" : "0.864",
         "y" : "0.831"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_c4.png",
         "x" : "0.623",
         "y" : "0.831"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_b4.png",
         "x" : "0.349",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_a4.png",
         "x" : "0.13",
         "y" : "0.831"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_d3.png",
         "x" : "0.839",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_c3.png",
         "x" : "0.597",
         "y" : "0.594"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_b3.png",
         "x" : "0.349",
         "y" : "0.643"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_a3.png",
         "x" : "0.13",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_d2.png",
         "x" : "0.864",
         "y" : "0.4"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_c2.png",
         "x" : "0.623",
         "y" : "0.376"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_b2.png",
         "x" : "0.374",
         "y" : "0.4"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_a2.png",
         "x" : "0.156",
         "y" : "0.377"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_d1.png",
         "x" : "0.864",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_c1.png",
         "x" : "0.647",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_b1.png",
         "x" : "0.4",
         "y" : "0.163"
      },
      {
         "pixmapfile" : "image/AlbrechtDurer_a1.png",
         "x" : "0.156",
         "y" : "0.138"
      }
   ]
}
