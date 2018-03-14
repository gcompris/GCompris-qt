/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
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
