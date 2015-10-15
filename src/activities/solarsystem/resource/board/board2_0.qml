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
import QtQuick 2.0

QtObject {
   property string instruction: qsTr("Drag and Drop the planets to their respective position")
   property variant levels: [

      {
          "pixmapfile" : "images/Mercury.png",
          "x" : "0.16",
          "y" : "0.5",
          "height":"0.07",
          "width":"0.07"
      },
      {
          "pixmapfile" : "images/vinus.png",
          "x" : "0.24",
          "y" : "0.5",
          "height":"0.07",
          "width":"0.07"
      },
      {
          "pixmapfile" : "images/earth.png",
          "x" : "0.32",
          "y" : "0.5",
          "height":"0.07",
          "width":"0.07"
      },
      {
          "pixmapfile" : "images/Mars.png",
          "x" : "0.4",
          "y" : "0.5",
          "height":"0.07",
          "width":"0.07"      },
        {
            "pixmapfile" : "images/ceres.png",
            "x" : "0.48",
            "y" : "0.5",
            "height":"0.07",
            "width":"0.07"
        },
      {
          "pixmapfile" : "images/jupiter.png",
          "x" : "0.56",
          "y" : "0.5",
          "height":"0.1",
          "width":"0.1"
      },
      {
          "pixmapfile" : "images/planet-saturn.png",
          "x" : "0.64",
          "y" : "0.5",
          "height":"0.1",
          "width":"0.1"
      },
      {
          "pixmapfile" : "images/uranus.png",
          "x" : "0.72",
          "y" : "0.5",
          "height":"0.1",
          "width":"0.1"
      },
      {
          "pixmapfile" : "images/neptune.png",
          "x" : "0.8",
          "y" : "0.5",
          "height":"0.1",
          "width":"0.1"
      },
        {
            "pixmapfile" : "images/pluto.png",
            "x" : "0.88",
            "y" : "0.5",
            "height":"0.1",
            "width":"0.1"
        },
        {
            "pixmapfile" : "images/eris.png",
            "x" : "0.96",
            "y" : "0.5",
            "height":"0.1",
            "width":"0.1"
        },
       {
            "pixmapfile" : "images/circ.png",
            "x" : "0.16",
            "y" : "0.5",
            "type" : "SHAPE_BACKGROUND",
            "height":"0.1",
            "width":"0.1"
        },
        {
             "pixmapfile" : "images/circ.png",
             "x" : "0.24",
             "y" : "0.5",
             "type" : "SHAPE_BACKGROUND",
            "height":"0.1",
            "width":"0.1"
         },
        {
             "pixmapfile" : "images/circ.png",
             "x" : "0.32",
             "y" : "0.5",
             "type" : "SHAPE_BACKGROUND",
            "height":"0.1",
            "width":"0.1"
         },

        {
             "pixmapfile" : "images/circ.png",
             "x" : "0.4",
             "y" : "0.5",
             "type" : "SHAPE_BACKGROUND",
            "height":"0.1",
            "width":"0.1"
         },

        {
             "pixmapfile" : "images/circ.png",
             "x" : "0.48",
             "y" : "0.5",
             "type" : "SHAPE_BACKGROUND",
            "height":"0.1",
            "width":"0.1"
         },

        {
             "pixmapfile" : "images/circ.png",
             "x" : "0.56",
             "y" : "0.5",
             "type" : "SHAPE_BACKGROUND",
            "height":"0.1",
            "width":"0.1"
         },

        {
             "pixmapfile" : "images/circ.png",
             "x" : "0.64",
             "y" : "0.5",
             "type" : "SHAPE_BACKGROUND",
            "height":"0.1",
            "width":"0.1"
         },

        {
             "pixmapfile" : "images/circ.png",
             "x" : "0.72",
             "y" : "0.5",
             "type" : "SHAPE_BACKGROUND",
            "height":"0.1",
            "width":"0.1"
         },

        {
             "pixmapfile" : "images/circ.png",
             "x" : "0.80",
             "y" : "0.5",
             "type" : "SHAPE_BACKGROUND",
            "height":"0.1",
            "width":"0.1"
         },

        {
             "pixmapfile" : "images/circ.png",
             "x" : "0.88",
             "y" : "0.5",
             "type" : "SHAPE_BACKGROUND",
             "height":"0.1",
             "width":"0.1"
         },
        {
             "pixmapfile" : "images/circ.png",
             "x" : "0.96",
             "y" : "0.5",
             "type" : "SHAPE_BACKGROUND",
             "height":"0.1",
             "width":"0.1"
         },

   ]
}
