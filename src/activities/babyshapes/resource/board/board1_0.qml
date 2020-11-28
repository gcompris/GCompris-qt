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
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Drag and Drop the items to match them.")

   property var levels: [
      {
          "pixmapfile" : "food/baby_bottle.png",
          "x" : "0.5",
          "y" : "0.25"
      },
      {
          "pixmapfile" : "food/orange.png",
          "x" : "0.2",
          "y" : "0.75"
      },
      {
          "pixmapfile" : "food/cookie.png",
          "x" : "0.8",
          "y" : "0.75"
      },
      {
          "pixmapfile" : "food/chocolate.png",
          "x" : "0.5",
          "y" : "0.75"
      },
      {
          "pixmapfile" : "food/marmelade.png",
          "x" : "0.8",
          "y" : "0.25"
      },
      {
          "pixmapfile" : "food/butter.png",
          "x" : "0.2",
          "y" : "0.25"
      },
      {
          "pixmapfile" : "shapeBackground/T_butter.png",
          "x" : "0.2",
          "y" : "0.25",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_baby_bottle.png",
          "x" : "0.5",
          "y" : "0.25",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_marmelade.png",
          "x" : "0.8",
          "y" : "0.25",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_orange.png",
          "x" : "0.2",
          "y" : "0.75",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_chocolate.png",
          "x" : "0.5",
          "y" : "0.75",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_cookie.png",
          "x" : "0.8",
          "y" : "0.75",
          "type" : "SHAPE_BACKGROUND"
      }
   ]
}
