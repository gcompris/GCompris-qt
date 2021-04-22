/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.6

QtObject {
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
