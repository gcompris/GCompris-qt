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
   property string instruction: qsTr("Castle Neuschwanstein at Schwangau, Bavaria, Germany")
   property var levels: [
      {
         "pixmapfile" : "image/Neuschwanstein_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_0.webp",
         "x" : "0.876",
         "y" : "0.578",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_1.webp",
         "x" : "0.759",
         "y" : "0.537",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_2.webp",
         "x" : "0.674",
         "y" : "0.348",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_3.webp",
         "x" : "0.557",
         "y" : "0.465",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_4.webp",
         "x" : "0.553",
         "y" : "0.735",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_5.webp",
         "x" : "0.434",
         "y" : "0.537",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_6.webp",
         "x" : "0.325",
         "y" : "0.265",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_7.webp",
         "x" : "0.254",
         "y" : "0.11",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_8.webp",
         "x" : "0.165",
         "y" : "0.535",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/Neuschwanstein_9.webp",
         "x" : "0.059",
         "y" : "0.499",
         "dropAreaSize" : "8"
      }
   ]
}
