/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (new SVG map)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property int numberOfSubLevel: 1
   property string instruction: qsTr("Council areas of Scotland (North)")
   property var levels: [
      {
         "pixmapfile" : "scotland/scotland-north.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "scotland/aberdeenshire.svgz",
         //: Council area of Scotland: Aberdeenshire
         "toolTipText" : qsTr("Aberdeenshire"),
         "x" : "0.6993",
         "y" : "0.578"
      },
      {
         "pixmapfile" : "scotland/aberdeen.svgz",
         //: Council area of Scotland: Aberdeen
         "toolTipText" : qsTr("Aberdeen"),
         "x" : "0.7793",
         "y" : "0.5884"
      },
      {
         "pixmapfile" : "scotland/moray.svgz",
         //: Council area of Scotland: Moray
         "toolTipText" : qsTr("Moray"),
         "x" : "0.6411",
         "y" : "0.5514"
      },
      {
         "pixmapfile" : "scotland/na_h-eileanan_siar.svgz",
         //: Council area of Scotland: Na h-Eileanan Siar
         "toolTipText" : qsTr("Na h-Eileanan Siar"),
         "x" : "0.132",
         "y" : "0.512"
      },
      {
         "pixmapfile" : "scotland/orkney_islands.svgz",
         //: Council area of Scotland: Orkney Islands
         "toolTipText" : qsTr("Orkney Islands"),
         "x" : "0.6829",
         "y" : "0.2968"
      },
      {
         "pixmapfile" : "scotland/shetland_islands.svgz",
         //: Council area of Scotland: Shetland Islands
         "toolTipText" : qsTr("Shetland Islands"),
         "x" : "0.882",
         "y" : "0.1293"
      },
      {
         "pixmapfile" : "scotland/highland.svgz",
         //: Council area of Scotland: Highland
         "toolTipText" : qsTr("Highland"),
         "x" : "0.4069",
         "y" : "0.523"
      },
      {
         "pixmapfile" : "scotland/angus.svgz",
         //: Council area of Scotland: Angus
         "toolTipText" : qsTr("Angus"),
         "x" : "0.6811",
         "y" : "0.6544"
      },
      {
         "pixmapfile" : "scotland/dundee.svgz",
         //: Council area of Scotland: Dundee
         "toolTipText" : qsTr("Dundee"),
         "x" : "0.6742",
         "y" : "0.6925"
      },
      {
         "pixmapfile" : "scotland/perth_and_kinross.svgz",
         //: Council area of Scotland: Perth and Kinross
         "toolTipText" : qsTr("Perth and Kinross"),
         "x" : "0.5477",
         "y" : "0.6827"
      },
      {
         "pixmapfile" : "scotland/stirling.svgz",
         //: Council area of Scotland: Stirling
         "toolTipText" : qsTr("Stirling"),
         "x" : "0.4868",
         "y" : "0.7269"
      },
      {
         "pixmapfile" : "scotland/argyll_and_bute.svgz",
         //: Council area of Scotland: Argyll and Bute
         "toolTipText" : qsTr("Argyll and Bute"),
         "x" : "0.2863",
         "y" : "0.767"
      },
      {
         "pixmapfile" : "scotland/fife.svgz",
         //: Council area of Scotland: Fife
         "toolTipText" : qsTr("Fife"),
         "x" : "0.647",
         "y" : "0.7304"
      }
   ]
}
