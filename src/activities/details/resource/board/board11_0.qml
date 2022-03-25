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
   property string instruction: qsTr("Gizah Pyramids, Egypt")
   property var levels: [
      {
         "pixmapfile" : "image/GizahPyramids_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/GizahPyramids_0.webp",
         "x" : "0.754",
         "y" : "0.498",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/GizahPyramids_1.webp",
         "x" : "0.585",
         "y" : "0.365",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/GizahPyramids_2.webp",
         "x" : "0.41",
         "y" : "0.604",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/GizahPyramids_3.webp",
         "x" : "0.891",
         "y" : "0.71",
         "dropAreaSize" : "8"
      }
   ]
}
