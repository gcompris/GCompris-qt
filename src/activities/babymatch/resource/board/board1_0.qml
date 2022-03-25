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
   property string instruction: qsTr("Drag and drop the items to match them.")
   property var levels : [
      {
          "pixmapfile" : "images/lamp.svg",
          "x" : "0.2",
          "y" : "0.8",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/postpoint.svg",
          "x" : "0.5",
          "y" : "0.8",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/sailingboat.svg",
          "x" : "0.8",
          "y" : "0.8",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/light.svg",
          "x" : "0.2",
          "y" : "0.4",
          "type" : "SHAPE_BACKGROUND",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/postcard.svg",
          "x" : "0.5",
          "y" : "0.4",
          "type" : "SHAPE_BACKGROUND",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/fishingboat.svg",
          "x" : "0.8",
          "y" : "0.4",
          "type" : "SHAPE_BACKGROUND",
          "height" : 0.25,
          "width" : 0.25
      }
   ]
}
