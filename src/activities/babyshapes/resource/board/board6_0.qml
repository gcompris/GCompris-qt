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
   property string instruction: qsTr("Lock with colored shapes.")
   property bool glow: false
   property var levels: [
	  {
          "pixmapfile" : "dog3/dog.png",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "dog3/dog1.png",
          "x" : "0.74",
          "y" : "0.771"
      },
      {
          "pixmapfile" : "dog3/dog2.png",
          "x" : "0.199",
          "y" : "0.726"
      },
      {
          "pixmapfile" : "dog3/dog3.png",
          "x" : "0.28",
          "y" : "0.303"
      },
      {
          "pixmapfile" : "dog3/dog4.png",
          "x" : "0.859",
          "y" : "0.301"
      },
      {
          "pixmapfile" : "dog3/dog5.png",
          "x" : "0.568",
          "y" : "0.206"
      },
      {
          "pixmapfile" : "dog3/dog6.png",
          "x" : "0.473",
          "y" : "0.692"
      }  
   ]
}
