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
   property var levels: [
      {
          "pixmapfile" : "food/yogurt.svg",
          "x" : "0.5",
          "y" : "0.75"
      },
      {
          "pixmapfile" : "food/baby_bottle.svg",
          "x" : "0.5",
          "y" : "0.25"
      },
      {
          "pixmapfile" : "food/pear.svg",
          "x" : "0.2",
          "y" : "0.75"
      },
      {
          "pixmapfile" : "food/banana.svg",
          "x" : "0.2",
          "y" : "0.25"
      },
      {
          "pixmapfile" : "food/milk_cup.svg",
          "x" : "0.8",
          "y" : "0.75"
      },
      {
          "pixmapfile" : "food/round_cookie.svg",
          "x" : "0.8",
          "y" : "0.25"
      },
      {
          "pixmapfile" : "shapeBackground/T_banana.svg",
          "x" : "0.2",
          "y" : "0.25",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_baby_bottle.svg",
          "x" : "0.5",
          "y" : "0.25",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_round_cookie.svg",
          "x" : "0.8",
          "y" : "0.25",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_pear.svg",
          "x" : "0.2",
          "y" : "0.75",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_yogurt.svg",
          "x" : "0.5",
          "y" : "0.75",
          "type" : "SHAPE_BACKGROUND"
      },
      {
          "pixmapfile" : "shapeBackground/T_milk_cup.svg",
          "x" : "0.8",
          "y" : "0.75",
          "type" : "SHAPE_BACKGROUND"
      }
   ]
}
