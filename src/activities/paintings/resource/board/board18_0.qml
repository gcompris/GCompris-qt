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
   property string instruction: qsTr("Pierre-Auguste Renoir, Girls At The Piano - 1892")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-8.webp",
         "x" : "0.608",
         "y" : "0.799"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-7.webp",
         "x" : "0.387",
         "y" : "0.801"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-6.webp",
         "x" : "0.608",
         "y" : "0.593"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-5.webp",
         "x" : "0.387",
         "y" : "0.595"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-4.webp",
         "x" : "0.577",
         "y" : "0.36"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-3.webp",
         "x" : "0.356",
         "y" : "0.36"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-2.webp",
         "x" : "0.608",
         "y" : "0.125"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-1.webp",
         "x" : "0.387",
         "y" : "0.125"
      }
   ]
}
