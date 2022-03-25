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
import QtQuick 2.12

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
         "pixmapfile" : "image/renoir-moulin_de_la_galette-4.webp",
         "x" : "0.226",
         "y" : "0.651"
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-5.webp",
         "x" : "0.504",
         "y" : "0.651"
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-3.webp",
         "x" : "0.782",
         "y" : "0.327"
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-1.webp",
         "x" : "0.255",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-2.webp",
         "x" : "0.533",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "image/renoir-moulin_de_la_galette-6.webp",
         "x" : "0.781",
         "y" : "0.69"
      }
   ]
}
