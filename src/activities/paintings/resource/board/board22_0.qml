/* GCompris
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
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
   property string instruction: qsTr("Vincent Van Gogh, Village Street in Auvers - 1890")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/gogh_auvert_2.jpg",
         "x" : "0.489",
         "y" : "0.224"
      },
      {
         "pixmapfile" : "image/gogh_auvert_6.jpg",
         "x" : "0.774",
         "y" : "0.681"
      },
      {
         "pixmapfile" : "image/gogh_auvert_5.jpg",
         "x" : "0.489",
         "y" : "0.681"
      },
      {
         "pixmapfile" : "image/gogh_auvert_1.jpg",
         "x" : "0.204",
         "y" : "0.224"
      },
      {
         "pixmapfile" : "image/gogh_auvert_4.jpg",
         "x" : "0.204",
         "y" : "0.681"
      },
      {
         "pixmapfile" : "image/gogh_auvert_3.jpg",
         "x" : "0.774",
         "y" : "0.224"
      }
   ]
}
