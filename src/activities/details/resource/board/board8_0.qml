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
   property string instruction: qsTr("Vincent van Gogh, Portrait of Pere Tanguy 1887-8")
   property var levels: [
      {
         "pixmapfile" : "image/PortraitOfPereTanguy_background.jpg",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "image/PortraitOfPereTanguy_0.png",
         "x" : "0.112",
         "y" : "0.364",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/PortraitOfPereTanguy_1.png",
         "x" : "0.503",
         "y" : "0.252",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/PortraitOfPereTanguy_2.png",
         "x" : "0.904",
         "y" : "0.544",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/PortraitOfPereTanguy_3.png",
         "x" : "0.594",
         "y" : "0.466",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/PortraitOfPereTanguy_4.png",
         "x" : "0.107",
         "y" : "0.91",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/PortraitOfPereTanguy_5.png",
         "x" : "0.485",
         "y" : "0.814",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/PortraitOfPereTanguy_6.png",
         "x" : "0.254",
         "y" : "0.212",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/PortraitOfPereTanguy_7.png",
         "x" : "0.122",
         "y" : "0.08",
         "dropAreaSize" : "8"
      },
      {
         "pixmapfile" : "image/PortraitOfPereTanguy_8.png",
         "x" : "0.906",
         "y" : "0.824",
         "dropAreaSize" : "8"
      }
   ]
}
