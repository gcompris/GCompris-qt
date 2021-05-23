/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 * SPDX-FileCopyrightText: 2018,2020 Karl Ove Hufthammer <karl@huftis.org>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Karl Ove Hufthammer <karl@huftis.org> (updated map for new counties in 2018 and 2020)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Counties of Norway")
   property var levels: [
      {
         "pixmapfile" : "norway/norway.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "norway/vestfold-og-telemark.png",
         //: County of Norway: Vestfold og Telemark
         "toolTipText" : qsTr("Vestfold og Telemark"),
         "x" : "0.19238",
         "y" : "0.89286"
      },
      {
         "pixmapfile" : "norway/viken.png",
         //: County of Norway: Viken
         "toolTipText" : qsTr("Viken"),
         "x" : "0.23848",
         "y" : "0.85869"
      },
      {
         "pixmapfile" : "norway/nordland.png",
         //: County of Norway: Nordland
         "toolTipText" : qsTr("Nordland"),
         "x" : "0.47548",
         "y" : "0.33265"
      },
      {
         "pixmapfile" : "norway/troms-og-finnmark.png",
         //: County of Norway: Troms og Finnmark
         "toolTipText" : qsTr("Troms og Finnmark"),
         "x" : "0.74997",
         "y" : "0.12058"
      },
      {
         "pixmapfile" : "norway/trondelag.png",
         //: County of Norway: Trøndelag
         "toolTipText" : qsTr("Trøndelag"),
         "x" : "0.32640",
         "y" : "0.58464"
      },
      {
         "pixmapfile" : "norway/oslo.png",
         //: County of Norway: Oslo
         "toolTipText" : qsTr("Oslo"),
         "x" : "0.28460",
         "y" : "0.86196"
      },
      {
         "pixmapfile" : "norway/more-og-romsdal.png",
         //: County of Norway: Møre og Romsdal
         "toolTipText" : qsTr("Møre og Romsdal"),
         "x" : "0.15511",
         "y" : "0.64797"
      },
      {
         "pixmapfile" : "norway/agder.png",
         //: County of Norway: Agder
         "toolTipText" : qsTr("Agder"),
         "x" : "0.13720",
         "y" : "0.93488"
      },
      {
         "pixmapfile" : "norway/innlandet.png",
         //: County of Norway: Innlandet
         "toolTipText" : qsTr("Innlandet"),
         "x" : "0.26955",
         "y" : "0.76638"
      },
      {
         "pixmapfile" : "norway/vestland.png",
         //: County of Norway: Vestland
         "toolTipText" : qsTr("Vestland"),
         "x" : "0.10232",
         "y" : "0.77636"
      },
      {
         "pixmapfile" : "norway/rogaland.png",
         //: County of Norway: Rogaland
         "toolTipText" : qsTr("Rogaland"),
         "x" : "0.06099",
         "y" : "0.91454"
      },
   ]
}
