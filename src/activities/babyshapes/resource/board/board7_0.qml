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
   property int numberOfSubLevel: 4
   property string instruction: qsTr("Paul Gauguin, Arearea - 1892")
   property var levels: [
	  {
          "pixmapfile" : "image/Paul_Gauguin_006_background.png",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "image/Paul_Gauguin_006_chien.png",
          "dropAreaSize" : "10",
          "x" : "0.278",
          "y" : "0.807"
      },
      {
          "pixmapfile" : "image/Paul_Gauguin_006_jeunes_filles.png",
          "dropAreaSize" : "10",
          "x" : "0.666",
          "y" : "0.46"
      },
      {
          "pixmapfile" : "image/Paul_Gauguin_006_statue.png",
          "dropAreaSize" : "10",
          "x" : "0.19",
          "y" : "0.133"
      }
   ]
}
