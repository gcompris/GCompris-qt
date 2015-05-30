/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin
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
   property string instruction: qsTr("Western Europe")
   property variant levels: [
      {
         "pixmapfile" : "europe/europe.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "europe/united_kingdom.png",
         "toolTipText" : "United Kingdom",
         "x" : "0.215",
         "y" : "0.439"
      },
      {
         "pixmapfile" : "europe/switz.png",
         "toolTipText" : "Switzerland",
         "x" : "0.409",
         "y" : "0.644"
      },
      {
         "pixmapfile" : "europe/sweden.png",
         "toolTipText" : "Sweden",
         "x" : "0.523",
         "y" : "0.247"
      },
      {
         "pixmapfile" : "europe/spain.png",
         "toolTipText" : "Spain",
         "x" : "0.23",
         "y" : "0.835"
      },
      {
         "pixmapfile" : "europe/portugal.png",
         "toolTipText" : "Portugal",
         "x" : "0.134",
         "y" : "0.844"
      },
      {
         "pixmapfile" : "europe/norway.png",
         "toolTipText" : "Norway",
         "x" : "0.516",
         "y" : "0.188"
      },
      {
         "pixmapfile" : "europe/netherland.png",
         "toolTipText" : "The Netherlands",
         "x" : "0.353",
         "y" : "0.502"
      },
      {
         "pixmapfile" : "europe/luxembourg.png",
         "type" : "SHAPE_BACKGROUND",
         "x" : "0.369",
         "y" : "0.568"
      },
      {
         "pixmapfile" : "europe/italy.png",
         "toolTipText" : "Italy",
         "x" : "0.485",
         "y" : "0.78"
      },
      {
         "pixmapfile" : "europe/ireland.png",
         "toolTipText" : "Ireland",
         "x" : "0.14",
         "y" : "0.48"
      },
      {
         "pixmapfile" : "europe/iceland.png",
         "toolTipText" : "Iceland",
         "x" : "0.078",
         "y" : "0.133"
      },
      {
         "pixmapfile" : "europe/germany.png",
         "toolTipText" : "Germany",
         "x" : "0.439",
         "y" : "0.53"
      },
      {
         "pixmapfile" : "europe/france.png",
         "toolTipText" : "France",
         "x" : "0.312",
         "y" : "0.662"
      },
      {
         "pixmapfile" : "europe/finland.png",
         "toolTipText" : "Finland",
         "x" : "0.642",
         "y" : "0.17"
      },
      {
         "pixmapfile" : "europe/denmark.png",
         "toolTipText" : "Denmark",
         "x" : "0.43",
         "y" : "0.398"
      },
      {
         "pixmapfile" : "europe/belgium.png",
         "toolTipText" : "Belgium",
         "x" : "0.343",
         "y" : "0.546"
      },
      {
         "pixmapfile" : "europe/austria.png",
         "toolTipText" : "Austria",
         "x" : "0.49",
         "y" : "0.621"
      }
   ]
}
