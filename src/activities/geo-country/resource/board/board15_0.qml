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
import QtQuick 2.12

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
         "x" : "0.7071",
         "y" : "0.8299"
      },
      {
         "pixmapfile" : "scotland/aberdeen.svgz",
         //: Council area of Scotland: Aberdeen
         "toolTipText" : qsTr("Aberdeen"),
         "x" : "0.788",
         "y" : "0.8454"
      },
      {
         "pixmapfile" : "scotland/moray.svgz",
         //: Council area of Scotland: Moray
         "toolTipText" : qsTr("Moray"),
         "x" : "0.6522",
         "y" : "0.7892"
      },
      {
         "pixmapfile" : "scotland/na_h-eileanan_siar.svgz",
         //: Council area of Scotland: Na h-Eileanan Siar
         "toolTipText" : qsTr("Na h-Eileanan Siar"),
         "x" : "0.146",
         "y" : "0.7138"
      },
      {
         "pixmapfile" : "scotland/orkney_islands.svgz",
         //: Council area of Scotland: Orkney Islands
         "toolTipText" : qsTr("Orkney Islands"),
         "x" : "0.6982",
         "y" : "0.4188"
      },
      {
         "pixmapfile" : "scotland/shetland_islands.svgz",
         //: Council area of Scotland: Shetland Islands
         "toolTipText" : qsTr("Shetland Islands"),
         "x" : "0.8868",
         "y" : "0.1689"
      },
      {
         "pixmapfile" : "scotland/highland.svgz",
         //: Council area of Scotland: Highland
         "toolTipText" : qsTr("Highland"),
         "x" : "0.4206",
         "y" : "0.7425"
      }
   ]
}
