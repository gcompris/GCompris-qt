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
import QtQuick 2.9

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
         "x" : "0.175",
         "y" : "0.8528"
      },
      {
         "pixmapfile" : "norway/viken.svgz",
         //: County of Norway: Viken
         "toolTipText" : qsTr("Viken"),
         "x" : "0.2072",
         "y" : "0.818"
      },
      {
         "pixmapfile" : "norway/nordland.svgz",
         //: County of Norway: Nordland
         "toolTipText" : qsTr("Nordland"),
         "x" : "0.3968",
         "y" : "0.3232"
      },
      {
         "pixmapfile" : "norway/troms_og_finnmark.svgz",
         //: County of Norway: Troms og Finnmark
         "toolTipText" : qsTr("Troms og Finnmark"),
         "x" : "0.6981",
         "y" : "0.1401"
      },
      {
         "pixmapfile" : "norway/trondelag.svgz",
         //: County of Norway: Trøndelag
         "toolTipText" : qsTr("Trøndelag"),
         "x" : "0.2623",
         "y" : "0.5599"
      },
      {
         "pixmapfile" : "norway/oslo.svgz",
         //: County of Norway: Oslo
         "toolTipText" : qsTr("Oslo"),
         "x" : "0.2437",
         "y" : "0.8184"
      },
      {
         "pixmapfile" : "norway/more_og_romsdal.svgz",
         //: County of Norway: Møre og Romsdal
         "toolTipText" : qsTr("Møre og Romsdal"),
         "x" : "0.1235",
         "y" : "0.6299"
      },
      {
         "pixmapfile" : "norway/agder.svgz",
         //: County of Norway: Agder
         "toolTipText" : qsTr("Agder"),
         "x" : "0.1418",
         "y" : "0.8979"
      },
      {
         "pixmapfile" : "norway/innlandet.svgz",
         //: County of Norway: Innlandet
         "toolTipText" : qsTr("Innlandet"),
         "x" : "0.2221",
         "y" : "0.7287"
      },
      {
         "pixmapfile" : "norway/vestland.svgz",
         //: County of Norway: Vestland
         "toolTipText" : qsTr("Vestland"),
         "x" : "0.0928",
         "y" : "0.7582"
      },
      {
         "pixmapfile" : "norway/rogaland.svgz",
         //: County of Norway: Rogaland
         "toolTipText" : qsTr("Rogaland"),
         "x" : "0.08",
         "y" : "0.8812"
      },
   ]
}
