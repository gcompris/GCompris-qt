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
          "pixmapfile" : "images/crown.svg",
          "x" : "0.2",
          "y" : "0.7",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/windflag5.svg",
          "x" : "0.5",
          "y" : "0.7",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/football.svg",
          "x" : "0.8",
          "y" : "0.7",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/castle.svg",
          "x" : "0.2",
          "y" : "0.3",
          "type" : "SHAPE_BACKGROUND",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/sailingboat.svg",
          "x" : "0.5",
          "y" : "0.3",
          "type" : "SHAPE_BACKGROUND",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/raquette.svg",
          "x" : "0.8",
          "y" : "0.3",
          "type" : "SHAPE_BACKGROUND",
          "height" : 0.25,
          "width" : 0.25
      }
   ]
}
