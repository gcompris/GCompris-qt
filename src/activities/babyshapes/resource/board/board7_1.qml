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
   property string instruction: qsTr("Pieter Bruegel the Elder, The peasants wedding - 1568")
   property var levels: [
	  {
          "pixmapfile" : "image/Pieter_Bruegel_background.png",
          "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
          "pixmapfile" : "image/Pieter_Bruegel_service.png",
          "dropAreaSize" : "10",
          "x" : "0.684",
          "y" : "0.628"
      },
      {
          "pixmapfile" : "image/Pieter_Bruegel_mur.png",
          "dropAreaSize" : "10",
          "x" : "0.866",
          "y" : "0.143"
      },
      {
          "pixmapfile" : "image/Pieter_Bruegel_musicien.png",
          "dropAreaSize" : "10",
          "x" : "0.257",
          "y" : "0.453"
      },
      {
          "pixmapfile" : "image/Pieter_Bruegel_fillette.png",
          "dropAreaSize" : "10",
          "x" : "0.354",
          "y" : "0.87"
      }
   ]
}
