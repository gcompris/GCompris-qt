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
   property string instruction: qsTr("Wassily Kandinsky, Composition VIII - 1923")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/kandinky_8.webp",
         "x" : "0.85",
         "y" : "0.618"
      },
      {
         "pixmapfile" : "image/kandinky_7.webp",
         "x" : "0.642",
         "y" : "0.618"
      },
      {
         "pixmapfile" : "image/kandinky_6.webp",
         "x" : "0.376",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "image/kandinky_5.webp",
         "x" : "0.138",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "image/kandinky_4.webp",
         "x" : "0.85",
         "y" : "0.228"
      },
      {
         "pixmapfile" : "image/kandinky_3.webp",
         "x" : "0.642",
         "y" : "0.228"
      },
      {
         "pixmapfile" : "image/kandinky_2.webp",
         "x" : "0.405",
         "y" : "0.283"
      },
      {
         "pixmapfile" : "image/kandinky_1.webp",
         "x" : "0.167",
         "y" : "0.283"
      }
   ]
}
