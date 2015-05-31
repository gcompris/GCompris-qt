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
   property string instruction: qsTr("Northern Africa")
   property variant levels: [
      {
         "pixmapfile": "africa/north_africa.png",
         "type": "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile": "africa/western_sahara.png",
         "toolTipText": qsTr("Western Sahara"),
         "x": "0.114",
         "y": "0.307"
      },
      {
         "pixmapfile": "africa/uganda.png",
         "toolTipText": qsTr("Uganda"),
         "x": "0.737",
         "y": "0.878"
      },
      {
         "pixmapfile": "africa/tunisia.png",
         "toolTipText": qsTr("Tunisia"),
         "x": "0.425",
         "y": "0.139"
      },
      {
         "pixmapfile": "africa/togo.png",
         "toolTipText": qsTr("Togo"),
         "x": "0.27",
         "y": "0.689"
      },
      {
         "pixmapfile": "africa/sudan.png",
         "toolTipText": qsTr("Sudan"),
         "x": "0.694",
         "y": "0.599"
      },
      {
         "pixmapfile": "africa/somalia.png",
         "toolTipText": qsTr("Somalia"),
         "x": "0.926",
         "y": "0.792"
      },
      {
         "pixmapfile": "africa/sierra_leone.png",
         "toolTipText": qsTr("Sierra Leone"),
         "x": "0.093",
         "y": "0.672"
      },
      {
         "pixmapfile": "africa/senegal.png",
         "toolTipText": qsTr("Senegal"),
         "x": "0.055",
         "y": "0.536"
      },
      {
         "pixmapfile": "africa/rwanda.png",
         "toolTipText": qsTr("Rwanda"),
         "x": "0.706",
         "y": "0.959"
      },
      {
         "pixmapfile": "africa/niger.png",
         "toolTipText": qsTr("Niger"),
         "x": "0.384",
         "y": "0.491"
      },
      {
         "pixmapfile": "africa/nigeria.png",
         "toolTipText": qsTr("Nigeria"),
         "x": "0.388",
         "y": "0.68"
      },
      {
         "pixmapfile": "africa/moroco.png",
         "toolTipText": qsTr("Morocco"),
         "x": "0.205",
         "y": "0.159"
      },
      {
         "pixmapfile": "africa/mauritania.png",
         "toolTipText": qsTr("Mauritania"),
         "x": "0.133",
         "y": "0.395"
      },
      {
         "pixmapfile": "africa/mali.png",
         "toolTipText": qsTr("Mali"),
         "x": "0.215",
         "y": "0.479"
      },
      {
         "pixmapfile": "africa/libya.png",
         "toolTipText": qsTr("Libya"),
         "x": "0.517",
         "y": "0.313"
      },
      {
         "pixmapfile": "africa/liberia.png",
         "toolTipText": qsTr("Liberia"),
         "x": "0.12",
         "y": "0.727"
      },
      {
         "pixmapfile": "africa/ivory_coast.png",
         "toolTipText": qsTr("Ivory Coast"),
         "x": "0.177",
         "y": "0.706"
      },
      {
         "pixmapfile": "africa/guinea.png",
         "toolTipText": qsTr("Guinea"),
         "x": "0.099",
         "y": "0.639"
      },
      {
         "pixmapfile": "africa/guinea_bissau.png",
         "toolTipText": qsTr("Guinea Bissau"),
         "x": "0.05",
         "y": "0.599"
      },
      {
         "pixmapfile": "africa/ghana.png",
         "toolTipText": qsTr("Ghana"),
         "x": "0.24",
         "y": "0.704"
      },
      {
         "pixmapfile": "africa/ganbia.png",
         "toolTipText": qsTr("Gambia"),
         "x": "0.048",
         "y": "0.564"
      },
      {
         "pixmapfile": "africa/gabon.png",
         "toolTipText": qsTr("Gabon"),
         "x": "0.455",
         "y": "0.933"
      },
      {
         "pixmapfile": "africa/eritrea.png",
         "toolTipText": qsTr("Eritrea"),
         "x": "0.833",
         "y": "0.571"
      },
      {
         "pixmapfile": "africa/ethiopia.png",
         "toolTipText": qsTr("Ethiopia"),
         "x": "0.843",
         "y": "0.706"
      },
      {
         "pixmapfile": "africa/equatorial_guinea.png",
         "toolTipText": qsTr("Equatorial Guinea"),
         "x": "0.433",
         "y": "0.878"
      },
      {
         "pixmapfile": "africa/egypt.png",
         "toolTipText": qsTr("Egypt"),
         "x": "0.697",
         "y": "0.294"
      },
      {
         "pixmapfile": "africa/djibouti.png",
         "toolTipText": qsTr("Djibouti"),
         "x": "0.874",
         "y": "0.637"
      },
      {
         "pixmapfile": "africa/chad.png",
         "toolTipText": qsTr("Chad"),
         "x": "0.537",
         "y": "0.545"
      },
      {
         "pixmapfile": "africa/central_african_republic.png",
         "toolTipText": qsTr("Central African Republic"),
         "x": "0.564",
         "y": "0.736"
      },
      {
         "pixmapfile": "africa/cameroon.png",
         "toolTipText": qsTr("Cameroon"),
         "x": "0.448",
         "y": "0.751"
      },
      {
         "pixmapfile": "africa/burkina_faso.png",
         "toolTipText": qsTr("Burkina Faso"),
         "x": "0.239",
         "y": "0.607"
      },
      {
         "pixmapfile": "africa/benin.png",
         "toolTipText": qsTr("Benin"),
         "x": "0.294",
         "y": "0.674"
      },
      {
         "pixmapfile": "africa/algeria.png",
         "toolTipText": qsTr("Algeria"),
         "x": "0.31",
         "y": "0.264"
      }
   ]
}
