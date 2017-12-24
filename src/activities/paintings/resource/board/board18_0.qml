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
   property int numberOfSubLevel: 1
   property string instruction: qsTr("Pierre-Auguste Renoir, Girls At The Piano - 1892")
   property var levels : [
      {
         "pixmapfile" : "image/bg.svg",
         "type" : "SHAPE_BACKGROUND_IMAGE",
         "width": 702,
         "height": 515
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-8.png",
         "x" : "0.608",
         "y" : "0.799"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-7.png",
         "x" : "0.387",
         "y" : "0.801"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-6.png",
         "x" : "0.608",
         "y" : "0.593"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-5.png",
         "x" : "0.387",
         "y" : "0.595"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-4.png",
         "x" : "0.577",
         "y" : "0.36"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-3.png",
         "x" : "0.356",
         "y" : "0.36"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-2.png",
         "x" : "0.608",
         "y" : "0.125"
      },
      {
         "pixmapfile" : "image/renoir-filles_piano-1.png",
         "x" : "0.387",
         "y" : "0.125"
      }
   ]
}
