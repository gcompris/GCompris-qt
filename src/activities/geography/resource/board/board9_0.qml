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
   property string instruction: qsTr("Africa")
   property variant levels: [
      {
         "pixmapfile": "africa/africa.png",
         "type": "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile": "africa/zimbabwe.png",
         "sound": "voices-$CA/$LOCALE/geography/zimbabwe.$CA",
         "toolTipText": qsTr("Zimbabwe"),
         "x": "0.676",
         "y": "0.783"
      },
      {
         "pixmapfile": "africa/zambia.png",
         "sound": "voices-$CA/$LOCALE/geography/zambia.$CA",
         "toolTipText": qsTr("Zambia"),
         "x": "0.662",
         "y": "0.704"
      },
      {
         "pixmapfile": "africa/tunisia.png",
         "sound": "voices-$CA/$LOCALE/geography/tunisia.$CA",
         "toolTipText": qsTr("Tunisia"),
         "x": "0.39",
         "y": "0.051"
      },
      {
         "pixmapfile": "africa/togo.png",
         "sound": "voices-$CA/$LOCALE/geography/togo.$CA",
         "toolTipText": qsTr("Togo"),
         "x": "0.268",
         "y": "0.403"
      },
      {
         "pixmapfile": "africa/chad.png",
         "sound": "voices-$CA/$LOCALE/geography/chad.$CA",
         "toolTipText": qsTr("Chad"),
         "x": "0.528",
         "y": "0.306"
      },
      {
         "pixmapfile": "africa/tanzania.png",
         "sound": "voices-$CA/$LOCALE/geography/tanzania.$CA",
         "toolTipText": qsTr("Tanzania"),
         "x": "0.763",
         "y": "0.609"
      },
      {
         "pixmapfile": "africa/soudan.png",
         "sound": "voices-$CA/$LOCALE/geography/soudan.$CA",
         "toolTipText": qsTr("Sudan"),
         "x": "0.69",
         "y": "0.34"
      },
      {
         "pixmapfile": "africa/somalia.png",
         "sound": "voices-$CA/$LOCALE/geography/somalia.$CA",
         "toolTipText": qsTr("Somalia"),
         "x": "0.925",
         "y": "0.449"
      },
      {
         "pixmapfile": "africa/senegal.png",
         "sound": "voices-$CA/$LOCALE/geography/senegal.$CA",
         "toolTipText": qsTr("Senegal"),
         "x": "0.049",
         "y": "0.32"
      },
      {
         "pixmapfile": "africa/rep_congo.png",
         "sound": "voices-$CA/$LOCALE/geography/democratic_republic_of_congo.$CA",
         "toolTipText": qsTr("Democratic Republic of Congo"),
         "x": "0.57",
         "y": "0.577"
      },
      {
         "pixmapfile": "africa/rep_centrafrique.png",
         "sound": "voices-$CA/$LOCALE/geography/rep_centrafrique.$CA",
         "toolTipText": qsTr("Central African Republic"),
         "x": "0.563",
         "y": "0.425"
      },
      {
         "pixmapfile": "africa/uganda.png",
         "sound": "voices-$CA/$LOCALE/geography/uganda.$CA",
         "toolTipText": qsTr("Uganda"),
         "x": "0.725",
         "y": "0.5"
      },
      {
         "pixmapfile": "africa/nigeria.png",
         "sound": "voices-$CA/$LOCALE/geography/nigeria.$CA",
         "toolTipText": qsTr("Nigeria"),
         "x": "0.385",
         "y": "0.395"
      },
      {
         "pixmapfile": "africa/niger.png",
         "sound": "voices-$CA/$LOCALE/geography/niger.$CA",
         "toolTipText": qsTr("Niger"),
         "x": "0.373",
         "y": "0.277"
      },
      {
         "pixmapfile": "africa/namibia.png",
         "sound": "voices-$CA/$LOCALE/geography/namibia.$CA",
         "toolTipText": qsTr("Namibia"),
         "x": "0.516",
         "y": "0.84"
      },
      {
         "pixmapfile": "africa/mozambique.png",
         "sound": "voices-$CA/$LOCALE/geography/mozambique.$CA",
         "toolTipText": qsTr("Mozambique"),
         "x": "0.768",
         "y": "0.783"
      },
      {
         "pixmapfile": "africa/mauritania.png",
         "sound": "voices-$CA/$LOCALE/geography/mauritania.$CA",
         "toolTipText": qsTr("Mauritania"),
         "x": "0.099",
         "y": "0.231"
      },
      {
         "pixmapfile": "africa/moroco.png",
         "sound": "voices-$CA/$LOCALE/geography/moroco.$CA",
         "toolTipText": qsTr("Morocco"),
         "x": "0.127",
         "y": "0.123"
      },
      {
         "pixmapfile": "africa/mali.png",
         "sound": "voices-$CA/$LOCALE/geography/mali.$CA",
         "toolTipText": qsTr("Mali"),
         "x": "0.2",
         "y": "0.273"
      },
      {
         "pixmapfile": "africa/malawi.png",
         "sound": "voices-$CA/$LOCALE/geography/malawi.$CA",
         "toolTipText": qsTr("Malawi"),
         "x": "0.751",
         "y": "0.702"
      },
      {
         "pixmapfile": "africa/madagascar.png",
         "sound": "voices-$CA/$LOCALE/geography/madagascar.$CA",
         "toolTipText": qsTr("Madagascar"),
         "x": "0.927",
         "y": "0.781"
      },
      {
         "pixmapfile": "africa/libya.png",
         "sound": "voices-$CA/$LOCALE/geography/libya.$CA",
         "toolTipText": qsTr("Libya"),
         "x": "0.502",
         "y": "0.154"
      },
      {
         "pixmapfile": "africa/liberia.png",
         "sound": "voices-$CA/$LOCALE/geography/liberia.$CA",
         "toolTipText": qsTr("Liberia"),
         "x": "0.117",
         "y": "0.433"
      },
      {
         "pixmapfile": "africa/kenya.png",
         "sound": "voices-$CA/$LOCALE/geography/kenya.$CA",
         "toolTipText": qsTr("Kenya"),
         "x": "0.81",
         "y": "0.52"
      },
      {
         "pixmapfile": "africa/guinea.png",
         "sound": "voices-$CA/$LOCALE/geography/guinea.$CA",
         "toolTipText": qsTr("Guinea"),
         "x": "0.094",
         "y": "0.381"
      },
      {
         "pixmapfile": "africa/ghana.png",
         "sound": "voices-$CA/$LOCALE/geography/ghana.$CA",
         "toolTipText": qsTr("Ghana"),
         "x": "0.237",
         "y": "0.411"
      },
      {
         "pixmapfile": "africa/gabon.png",
         "sound": "voices-$CA/$LOCALE/geography/gabon.$CA",
         "toolTipText": qsTr("Gabon"),
         "x": "0.427",
         "y": "0.538"
      },
      {
         "pixmapfile": "africa/ethiopia.png",
         "sound": "voices-$CA/$LOCALE/geography/ethiopia.$CA",
         "toolTipText": qsTr("Ethiopia"),
         "x": "0.845",
         "y": "0.395"
      },
      {
         "pixmapfile": "africa/eritrea.png",
         "sound": "voices-$CA/$LOCALE/geography/eritrea.$CA",
         "toolTipText": qsTr("Eritrea"),
         "x": "0.831",
         "y": "0.31"
      },
      {
         "pixmapfile": "africa/egypt.png",
         "sound": "voices-$CA/$LOCALE/geography/egypt.$CA",
         "toolTipText": qsTr("Egypt"),
         "x": "0.683",
         "y": "0.152"
      },
      {
         "pixmapfile": "africa/ivory_coast.png",
         "sound": "voices-$CA/$LOCALE/geography/ivory_coast.$CA",
         "toolTipText": qsTr("Ivory Coast"),
         "x": "0.178",
         "y": "0.417"
      },
      {
         "pixmapfile": "africa/congo.png",
         "sound": "voices-$CA/$LOCALE/geography/congo.$CA",
         "toolTipText": qsTr("Republic of Congo"),
         "x": "0.477",
         "y": "0.528"
      },
      {
         "pixmapfile": "africa/cameroon.png",
         "sound": "voices-$CA/$LOCALE/geography/cameroon.$CA",
         "toolTipText": qsTr("Cameroon"),
         "x": "0.441",
         "y": "0.427"
      },
      {
         "pixmapfile": "africa/burkina_faso.png",
         "sound": "voices-$CA/$LOCALE/geography/burkina_faso.$CA",
         "toolTipText": qsTr("Burkina Faso"),
         "x": "0.232",
         "y": "0.35"
      },
      {
         "pixmapfile": "africa/botswana.png",
         "sound": "voices-$CA/$LOCALE/geography/botswana.$CA",
         "toolTipText": qsTr("Botswana"),
         "x": "0.608",
         "y": "0.832"
      },
      {
         "pixmapfile": "africa/benin.png",
         "sound": "voices-$CA/$LOCALE/geography/benin.$CA",
         "toolTipText": qsTr("Benin"),
         "x": "0.291",
         "y": "0.393"
      },
      {
         "pixmapfile": "africa/angola.png",
         "sound": "voices-$CA/$LOCALE/geography/angola.$CA",
         "toolTipText": qsTr("Angola"),
         "x": "0.514",
         "y": "0.686"
      },
      {
         "pixmapfile": "africa/algeria.png",
         "sound": "voices-$CA/$LOCALE/geography/algeria.$CA",
         "toolTipText": qsTr("Algeria"),
         "x": "0.279",
         "y": "0.128"
      },
      {
         "pixmapfile": "africa/south_africa.png",
         "sound": "voices-$CA/$LOCALE/geography/south_africa.$CA",
         "toolTipText": qsTr("South Africa"),
         "x": "0.606",
         "y": "0.913"
      }
   ]
}
