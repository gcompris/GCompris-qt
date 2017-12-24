/* GCompris
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Horia PELLE <horricane@gmail.com>
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
   property string instruction: qsTr("Provinces of Romania")
   property var levels: [
      {
         "pixmapfile" : "romania/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "romania/oltenia.png",
         "toolTipText" : "Oltenia",
         "x" : "0.346",
         "y" : "0.787"
      },
      {
         "pixmapfile" : "romania/muntenia.png",
         "toolTipText" : "Muntenia",
         "x" : "0.629",
         "y" : "0.768"
      },
      {
         "pixmapfile" : "romania/dobrogea.png",
         "toolTipText" : "Dobrogea",
         "x" : "0.873",
         "y" : "0.776"
      },
      {
         "pixmapfile" : "romania/moldova.png",
         "toolTipText" : "Moldova",
         "x" : "0.693",
         "y" : "0.307"
      },
      {
         "pixmapfile" : "romania/bucovina.png",
         "toolTipText" : "Bucovina",
         "x" : "0.567",
         "y" : "0.155"
      },
      {
         "pixmapfile" : "romania/transilvania.png",
         "toolTipText" : "Transilvania",
         "x" : "0.443",
         "y" : "0.396"
      },
      {
         "pixmapfile" : "romania/maramures.png",
         "toolTipText" : "Maramureș",
         "x" : "0.386",
         "y" : "0.111"
      },
      {
         "pixmapfile" : "romania/crisana.png",
         "toolTipText" : "Crișana",
         "x" : "0.193",
         "y" : "0.290"
      },
      {
         "pixmapfile" : "romania/banat.png",
         "toolTipText" : "Banat",
         "x" : "0.128",
         "y" : "0.617"
      }
   ]
}
