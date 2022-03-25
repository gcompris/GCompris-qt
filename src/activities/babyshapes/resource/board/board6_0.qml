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
   property string instruction: qsTr("Lock with colored shapes.")
   property bool glow: false
   property var levels: [
	  {
          "pixmapfile" : "dog2/dog.webp",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "dog2/dog1.webp",
          "x" : "0.74",
          "y" : "0.771"
      },
      {
          "pixmapfile" : "dog2/dog2.webp",
          "x" : "0.199",
          "y" : "0.726"
      },
      {
          "pixmapfile" : "dog2/dog3.webp",
          "x" : "0.28",
          "y" : "0.303"
      },
      {
          "pixmapfile" : "dog2/dog4.webp",
          "x" : "0.859",
          "y" : "0.301"
      },
      {
          "pixmapfile" : "dog2/dog5.webp",
          "x" : "0.568",
          "y" : "0.206"
      },
      {
          "pixmapfile" : "dog2/dog6.webp",
          "x" : "0.473",
          "y" : "0.692"
      }  
   ]
}
