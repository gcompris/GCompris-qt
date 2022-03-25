/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 * SPDX-FileCopyrightText: 2018,2020 Karl Ove Hufthammer <karl@huftis.org>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Karl Ove Hufthammer <karl@huftis.org> (updated map for new counties in 2018 and 2020)
 *   Timothée Giet <animtim@gmail.com> (new SVG map)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
   property string instruction: qsTr("Counties of Norway")
   property var levels: [
      {
         "pixmapfile" : "norway/norway.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "norway/vestfold_og_telemark.svgz",
         //: County of Norway: Vestfold og Telemark
         "toolTipText" : qsTr("Vestfold og Telemark"),
         "x" : "0.2109",
         "y" : "0.8757"
      },
      {
         "pixmapfile" : "norway/viken.svgz",
         //: County of Norway: Viken
         "toolTipText" : qsTr("Viken"),
         "x" : "0.2538",
         "y" : "0.8429"
      },
      {
         "pixmapfile" : "norway/nordland.svgz",
         //: County of Norway: Nordland
         "toolTipText" : qsTr("Nordland"),
         "x" : "0.4779",
         "y" : "0.3375"
      },
      {
         "pixmapfile" : "norway/troms_og_finnmark.svgz",
         //: County of Norway: Troms og Finnmark
         "toolTipText" : qsTr("Troms og Finnmark"),
         "x" : "0.7362",
         "y" : "0.1338"
      },
      {
         "pixmapfile" : "norway/trondelag.svgz",
         //: County of Norway: Trøndelag
         "toolTipText" : qsTr("Trøndelag"),
         "x" : "0.3378",
         "y" : "0.5798"
      },
      {
         "pixmapfile" : "norway/oslo.svgz",
         //: County of Norway: Oslo
         "toolTipText" : qsTr("Oslo"),
         "x" : "0.2973",
         "y" : "0.8464"
      },
      {
         "pixmapfile" : "norway/more_og_romsdal.svgz",
         //: County of Norway: Møre og Romsdal
         "toolTipText" : qsTr("Møre og Romsdal"),
         "x" : "0.1762",
         "y" : "0.6407"
      },
      {
         "pixmapfile" : "norway/agder.svgz",
         //: County of Norway: Agder
         "toolTipText" : qsTr("Agder"),
         "x" : "0.1591",
         "y" : "0.9172"
      },
      {
         "pixmapfile" : "norway/innlandet.svgz",
         //: County of Norway: Innlandet
         "toolTipText" : qsTr("Innlandet"),
         "x" : "0.2836",
         "y" : "0.7538"
      },
      {
         "pixmapfile" : "norway/vestland.svgz",
         //: County of Norway: Vestland
         "toolTipText" : qsTr("Vestland"),
         "x" : "0.1266",
         "y" : "0.7632"
      },
      {
         "pixmapfile" : "norway/rogaland.svgz",
         //: County of Norway: Rogaland
         "toolTipText" : qsTr("Rogaland"),
         "x" : "0.0865",
         "y" : "0.8966"
      },
   ]
}
