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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property var levels: [
      {
          "pixmapfile" : "food/bread_slice.svg",
          "x" : "0.5",
          "y" : "0.75"
      },
      {
          "pixmapfile" : "food/banana.svg",
          "x" : "0.8",
          "y" : "0.25"
      },
      {
          "pixmapfile" : "food/yogurt.svg",
          "x" : "0.5",
          "y" : "0.25"
      },
      {
          "pixmapfile" : "food/sugar_box.svg",
          "x" : "0.2",
          "y" : "0.75"
      },
      {
          "pixmapfile" : "food/french_croissant.svg",
          "x" : "0.2",
          "y" : "0.25"
      },
      {
          "pixmapfile" : "food/baby_bottle.svg",
          "x" : "0.8",
          "y" : "0.75"
      },
      {
          "pixmapfile" : "shapeBackground/T_french_croissant.svg",
          "x" : "0.2",
          "y" : "0.25",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_yogurt.svg",
          "x" : "0.5",
          "y" : "0.25",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_banana.svg",
          "x" : "0.8",
          "y" : "0.25",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_sugar_box.svg",
          "x" : "0.2",
          "y" : "0.75",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_bread_slice.svg",
          "x" : "0.5",
          "y" : "0.75",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_baby_bottle.svg",
          "x" : "0.8",
          "y" : "0.75",
          "type" : "SHAPE_BACKGROUND"
      }
   ]
}
