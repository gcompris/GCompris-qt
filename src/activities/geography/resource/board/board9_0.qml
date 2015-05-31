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
   property string instruction: qsTr("Africa")
   property variant levels: [
      {
         "pixmapfile": "africa/africa.png",
         "type": "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile": "africa/zimbabwe.png",
         "toolTipText": qsTr("Zimbabwe"),
         "x": "0.676",
         "y": "0.783"
      },
      {
         "pixmapfile": "africa/zambia.png",
         "toolTipText": qsTr("Zambia"),
         "x": "0.662",
         "y": "0.704"
      },
      {
         "pixmapfile": "africa/tunisia.png",
         "toolTipText": qsTr("Tunisia"),
         "x": "0.39",
         "y": "0.051"
      },
      {
         "pixmapfile": "africa/togo.png",
         "toolTipText": qsTr("Togo"),
         "x": "0.268",
         "y": "0.403"
      },
      {
         "pixmapfile": "africa/chad.png",
         "toolTipText": qsTr("Chad"),
         "x": "0.528",
         "y": "0.306"
      },
      {
         "pixmapfile": "africa/tanzania.png",
         "toolTipText": qsTr("Tanzania"),
         "x": "0.763",
         "y": "0.609"
      },
      {
         "pixmapfile": "africa/soudan.png",
         "toolTipText": qsTr("Sudan"),
         "x": "0.69",
         "y": "0.34"
      },
      {
         "pixmapfile": "africa/somalia.png",
         "toolTipText": qsTr("Somalia"),
         "x": "0.925",
         "y": "0.449"
      },
      {
         "pixmapfile": "africa/senegal.png",
         "toolTipText": qsTr("Senegal"),
         "x": "0.049",
         "y": "0.32"
      },
      {
         "pixmapfile": "africa/rep_congo.png",
         "toolTipText": qsTr("Democratic Republic of Congo"),
         "x": "0.57",
         "y": "0.577"
      },
      {
         "pixmapfile": "africa/rep_centrafrique.png",
         "toolTipText": qsTr("Central African Republic"),
         "x": "0.563",
         "y": "0.425"
      },
      {
         "pixmapfile": "africa/uganda.png",
         "toolTipText": qsTr("Uganda"),
         "x": "0.725",
         "y": "0.5"
      },
      {
         "pixmapfile": "africa/nigeria.png",
         "toolTipText": qsTr("Nigeria"),
         "x": "0.385",
         "y": "0.395"
      },
      {
         "pixmapfile": "africa/niger.png",
         "toolTipText": qsTr("Niger"),
         "x": "0.373",
         "y": "0.277"
      },
      {
         "pixmapfile": "africa/namibia.png",
         "toolTipText": qsTr("Namibia"),
         "x": "0.516",
         "y": "0.84"
      },
      {
         "pixmapfile": "africa/mozambique.png",
         "toolTipText": qsTr("Mozambique"),
         "x": "0.768",
         "y": "0.783"
      },
      {
         "pixmapfile": "africa/mauritania.png",
         "toolTipText": qsTr("Mauritania"),
         "x": "0.099",
         "y": "0.231"
      },
      {
         "pixmapfile": "africa/moroco.png",
         "toolTipText": qsTr("Morocco"),
         "x": "0.127",
         "y": "0.123"
      },
      {
         "pixmapfile": "africa/mali.png",
         "toolTipText": qsTr("Mali"),
         "x": "0.2",
         "y": "0.273"
      },
      {
         "pixmapfile": "africa/malawi.png",
         "toolTipText": qsTr("Malawi"),
         "x": "0.751",
         "y": "0.702"
      },
      {
         "pixmapfile": "africa/madagascar.png",
         "toolTipText": qsTr("Madagascar"),
         "x": "0.927",
         "y": "0.781"
      },
      {
         "pixmapfile": "africa/libya.png",
         "toolTipText": qsTr("Libya"),
         "x": "0.502",
         "y": "0.154"
      },
      {
         "pixmapfile": "africa/liberia.png",
         "toolTipText": qsTr("Liberia"),
         "x": "0.117",
         "y": "0.433"
      },
      {
         "pixmapfile": "africa/kenya.png",
         "toolTipText": qsTr("Kenya"),
         "x": "0.81",
         "y": "0.52"
      },
      {
         "pixmapfile": "africa/guinea.png",
         "toolTipText": qsTr("Guinea"),
         "x": "0.094",
         "y": "0.381"
      },
      {
         "pixmapfile": "africa/ghana.png",
         "toolTipText": qsTr("Ghana"),
         "x": "0.237",
         "y": "0.411"
      },
      {
         "pixmapfile": "africa/gabon.png",
         "toolTipText": qsTr("Gabon"),
         "x": "0.427",
         "y": "0.538"
      },
      {
         "pixmapfile": "africa/ethiopia.png",
         "toolTipText": qsTr("Ethiopia"),
         "x": "0.845",
         "y": "0.395"
      },
      {
         "pixmapfile": "africa/eritrea.png",
         "toolTipText": qsTr("Eritrea"),
         "x": "0.831",
         "y": "0.31"
      },
      {
         "pixmapfile": "africa/egypt.png",
         "toolTipText": qsTr("Egypt"),
         "x": "0.683",
         "y": "0.152"
      },
      {
         "pixmapfile": "africa/ivory_coast.png",
         "toolTipText": qsTr("Ivory Coast"),
         "x": "0.178",
         "y": "0.417"
      },
      {
         "pixmapfile": "africa/congo.png",
         "toolTipText": qsTr("Republic of Congo"),
         "x": "0.477",
         "y": "0.528"
      },
      {
         "pixmapfile": "africa/cameroon.png",
         "toolTipText": qsTr("Cameroon"),
         "x": "0.441",
         "y": "0.427"
      },
      {
         "pixmapfile": "africa/burkina_faso.png",
         "toolTipText": qsTr("Burkina Faso"),
         "x": "0.232",
         "y": "0.35"
      },
      {
         "pixmapfile": "africa/botswana.png",
         "toolTipText": qsTr("Botswana"),
         "x": "0.608",
         "y": "0.832"
      },
      {
         "pixmapfile": "africa/benin.png",
         "toolTipText": qsTr("Benin"),
         "x": "0.291",
         "y": "0.393"
      },
      {
         "pixmapfile": "africa/angola.png",
         "toolTipText": qsTr("Angola"),
         "x": "0.514",
         "y": "0.686"
      },
      {
         "pixmapfile": "africa/algeria.png",
         "toolTipText": qsTr("Algeria"),
         "x": "0.279",
         "y": "0.128"
      },
      {
         "pixmapfile": "africa/south_africa.png",
         "toolTipText": qsTr("South Africa"),
         "x": "0.606",
         "y": "0.913"
      }
   ]
}
