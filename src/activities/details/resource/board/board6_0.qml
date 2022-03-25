/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
   property string instruction: qsTr("Vincent van Gogh, Cafe Terrace at Night - 1888")
   property var levels: [
      {
         "pixmapfile" : "image/Gogh4_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Gogh4_0.webp",
         "x" : "0.753",
         "y" : "0.594",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_1.webp",
         "x" : "0.234",
         "y" : "0.776",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_2.webp",
         "x" : "0.633",
         "y" : "0.618",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_3.webp",
         "x" : "0.459",
         "y" : "0.922",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_4.webp",
         "x" : "0.511",
         "y" : "0.112",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_5.webp",
         "x" : "0.88",
         "y" : "0.532",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_6.webp",
         "x" : "0.783",
         "y" : "0.198",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_7.webp",
         "x" : "0.229",
         "y" : "0.444",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Gogh4_8.webp",
         "x" : "0.579",
         "y" : "0.794",
         "dropAreaSize" : "8"
      }
   ]
}
