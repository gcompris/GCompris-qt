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
   property string instruction: qsTr("Hello! My name is Lock.")
   property var levels: [
      {
          "pixmapfile" : "dog1/dog.webp",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "dog1/dog1.webp",
          "x" : "0.295",
          "y" : "0.745"
      },
      {
          "pixmapfile" : "dog1/dog2.webp",
          "x" : "0.793",
          "y" : "0.45"
      },
      {
          "pixmapfile" : "dog1/dog3.webp",
          "x" : "0.355",
          "y" : "0.25"
      }
   ]
}
