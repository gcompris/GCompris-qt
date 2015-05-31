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
   property string instruction: qsTr("Central America")
   property variant levels: [
      {
         "pixmapfile": "centralamerica/bg_central_america_blank.png",
         "type": "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile": "centralamerica/puerto_rico.png",
         "toolTipText": qsTr("Puerto Rico"),
         "x": "0.828",
         "y": "0.498"
      },
      {
         "pixmapfile": "centralamerica/panama.png",
         "toolTipText": qsTr("Panama"),
         "x": "0.453",
         "y": "0.929"
      },
      {
         "pixmapfile": "centralamerica/nicaragua.png",
         "toolTipText": qsTr("Nicaragua"),
         "x": "0.33",
         "y": "0.736"
      },
      {
         "pixmapfile": "centralamerica/mexico.png",
         "toolTipText": qsTr("Mexico"),
         "x": "0.161",
         "y": "0.329"
      },
      {
         "pixmapfile": "centralamerica/jamaica.png",
         "toolTipText": qsTr("Jamaica"),
         "x": "0.552",
         "y": "0.502"
      },
      {
         "pixmapfile": "centralamerica/honduras.png",
         "toolTipText": qsTr("Honduras"),
         "x": "0.31",
         "y": "0.665"
      },
      {
         "pixmapfile": "centralamerica/haiti.png",
         "toolTipText": qsTr("Haiti"),
         "x": "0.662",
         "y": "0.461"
      },
      {
         "pixmapfile": "centralamerica/guatemala.png",
         "toolTipText": qsTr("Guatemala"),
         "x": "0.211",
         "y": "0.604"
      },
      {
         "pixmapfile": "centralamerica/el_salvador.png",
         "toolTipText": qsTr("El Salvador"),
         "x": "0.242",
         "y": "0.695"
      },
      {
         "pixmapfile": "centralamerica/dominican_republic.png",
         "toolTipText": qsTr("Dominican Republic"),
         "x": "0.733",
         "y": "0.474"
      },
      {
         "pixmapfile": "centralamerica/cuba.png",
         "toolTipText": qsTr("Cuba"),
         "x": "0.507",
         "y": "0.353"
      },
      {
         "pixmapfile": "centralamerica/costa_rica.png",
         "toolTipText": qsTr("Costa Rica"),
         "x": "0.353",
         "y": "0.872"
      },
      {
         "pixmapfile": "centralamerica/belize.png",
         "toolTipText": qsTr("Belize"),
         "x": "0.26",
         "y": "0.543"
      },
      {
         "pixmapfile": "centralamerica/bahamas.png",
         "toolTipText": qsTr("Bahamas"),
         "x": "0.629",
         "y": "0.245"
      }
   ]
}
