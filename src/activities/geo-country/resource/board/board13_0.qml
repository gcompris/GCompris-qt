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
   property string instruction: qsTr("Districts of Australia")
   property var levels: [
      {
         "pixmapfile" : "australia/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "australia/western_australia.png",
         "toolTipText" : "Western Australia",
         "x" : "0.217",
         "y" : "0.402"
      },
      {
         "pixmapfile" : "australia/northern_territory.png",
         "toolTipText" : "Northern Territory",
         "x" : "0.496",
         "y" : "0.246"
      },
      {
         "pixmapfile" : "australia/south_australia.png",
         "toolTipText" : "South Australia",
         "x" : "0.533",
         "y" : "0.622"
      },
      {
         "pixmapfile" : "australia/queensland.png",
         "toolTipText" : "Queensland",
         "x" : "0.779",
         "y" : "0.275"
      },
      {
         "pixmapfile" : "australia/new_south_wales.png",
         "toolTipText" : "New South Wales",
         "x" : "0.817",
         "y" : "0.637"
      },
      {
         "pixmapfile" : "australia/victoria.png",
         "toolTipText" : "Victoria",
         "x" : "0.772",
         "y" : "0.753"
      },
      {
         "pixmapfile" : "australia/tasmania.png",
         "toolTipText" : "Tasmania",
         "x" : "0.798",
         "y" : "0.933"
      }
   ]
}
