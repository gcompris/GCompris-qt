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
   property int numberOfSubLevel: 4
   property string instruction: qsTr("Michelangelo, Pieta - 1499")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_c4.png",
         "x" : "0.696",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_b4.png",
         "x" : "0.474",
         "y" : "0.854"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_a4.png",
         "x" : "0.275",
         "y" : "0.831"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_c3.png",
         "x" : "0.719",
         "y" : "0.619"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_b3.png",
         "x" : "0.521",
         "y" : "0.619"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_a3.png",
         "x" : "0.298",
         "y" : "0.617"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_c2.png",
         "x" : "0.696",
         "y" : "0.352"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_b2.png",
         "x" : "0.474",
         "y" : "0.352"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_a2.png",
         "x" : "0.275",
         "y" : "0.377"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_c1.png",
         "x" : "0.696",
         "y" : "0.138"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_b1.png",
         "x" : "0.497",
         "y" : "0.138"
      },
      {
         "pixmapfile" : "image/Michelangelo_Pieta_a1.png",
         "x" : "0.298",
         "y" : "0.138"
      }
   ]
}
