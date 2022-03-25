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
   property string instruction: qsTr("Eiffel Tower, seen from the champ de Mars, Paris, France")
   property var levels: [
      {
         "pixmapfile" : "image/TourEiffel_background.webp",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/TourEiffel_0.webp",
         "x" : "0.493",
         "y" : "0.09",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/TourEiffel_1.webp",
         "x" : "0.489",
         "y" : "0.524",
         "dropAreaSize" : "8"
      }
   ]
}
