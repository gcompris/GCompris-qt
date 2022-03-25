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
   property string instruction: qsTr("Sydney Opera House, Australia")
   property var levels: [
      {
         "pixmapfile" : "image/OperaSidney_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/OperaSidney_0.webp",
         "x" : "0.243",
         "y" : "0.543",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/OperaSidney_1.webp",
         "x" : "0.399",
         "y" : "0.596",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/OperaSidney_2.webp",
         "x" : "0.471",
         "y" : "0.375",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/OperaSidney_3.webp",
         "x" : "0.579",
         "y" : "0.58",
         "dropAreaSize" : "8"
      }
   ]
}
