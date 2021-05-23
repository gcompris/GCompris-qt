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
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Hello! My name is Lock.")
   property var levels: [
      {
          "pixmapfile" : "dog1/dog.png",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "dog1/dog1.png",
          "x" : "0.295",
          "y" : "0.745"
      },
      {
          "pixmapfile" : "dog1/dog2.png",
          "x" : "0.793",
          "y" : "0.45"
      },
      {
          "pixmapfile" : "dog1/dog3.png",
          "x" : "0.355",
          "y" : "0.25"
      }
   ]
}
