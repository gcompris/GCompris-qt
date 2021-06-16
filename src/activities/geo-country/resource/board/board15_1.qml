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
   property string instruction: qsTr("Council areas of Scotland (South)")
   property var levels: [
      {
         "pixmapfile" : "scotland/scotland-south.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "scotland/scottish_borders.svgz",
         //: Council areas of Scotland: Scottish Borders
         "toolTipText" : qsTr("Scottish Borders"),
         "x" : "0.7662",
         "y" : "0.4395"
      },
      {
         "pixmapfile" : "scotland/east_lothian.svgz",
         //: Council areas of Scotland: East Lothian
         "toolTipText" : qsTr("East Lothian"),
         "x" : "0.7827",
         "y" : "0.1942"
      },
      {
         "pixmapfile" : "scotland/midlothian.svgz",
         //: Council areas of Scotland: Midlothian
         "toolTipText" : qsTr("Midlothian"),
         "x" : "0.6765",
         "y" : "0.268"
      },
      {
         "pixmapfile" : "scotland/west_lothian.svgz",
         //: Council areas of Scotland: West Lothian
         "toolTipText" : qsTr("West Lothian"),
         "x" : "0.5362",
         "y" : "0.2295"
      },
      {
         "pixmapfile" : "scotland/edinburgh.svgz",
         //: Council areas of Scotland: Edinburgh
         "toolTipText" : qsTr("Edinburgh"),
         "x" : "0.6329",
         "y" : "0.216"
      },
      {
         "pixmapfile" : "scotland/falkirk.svgz",
         //: Council areas of Scotland: Falkirk
         "toolTipText" : qsTr("Falkirk"),
         "x" : "0.4905",
         "y" : "0.1632"
      },
      {
         "pixmapfile" : "scotland/south_lanarkshire.svgz",
         //: Council areas of Scotland: South Lanarkshire
         "toolTipText" : qsTr("South Lanarkshire"),
         "x" : "0.4718",
         "y" : "0.4159"
      },
      {
         "pixmapfile" : "scotland/north_lanarkshire.svgz",
         //: Council areas of Scotland: North Lanarkshire
         "toolTipText" : qsTr("North Lanarkshire"),
         "x" : "0.44",
         "y" : "0.232"
      },
      {
         "pixmapfile" : "scotland/dumfries_and_galloway.svgz",
         //: Council areas of Scotland: Dumfries and Galloway
         "toolTipText" : qsTr("Dumfries and Galloway"),
         "x" : "0.4206",
         "y" : "0.7183"
      },
      {
         "pixmapfile" : "scotland/south_ayrshire.svgz",
         //: Council areas of Scotland: South Ayrshire
         "toolTipText" : qsTr("South Ayrshire"),
         "x" : "0.223",
         "y" : "0.5719"
      },
      {
         "pixmapfile" : "scotland/east_ayrshire.svgz",
         //: Council areas of Scotland: East Ayrshire
         "toolTipText" : qsTr("East Ayrshire"),
         "x" : "0.3435",
         "y" : "0.484"
      },
      {
         "pixmapfile" : "scotland/glasgow.svgz",
         //: Council areas of Scotland: Glasgow
         "toolTipText" : qsTr("Glasgow"),
         "x" : "0.3619",
         "y" : "0.2481"
      },
      {
         "pixmapfile" : "scotland/east_dunbartonshire.svgz",
         //: Council areas of Scotland: East Dunbartonshire
         "toolTipText" : qsTr("East Dunbartonshire"),
         "x" : "0.3641",
         "y" : "0.1846"
      },
      {
         "pixmapfile" : "scotland/west_dunbartonshire.svgz",
         //: Council areas of Scotland: West Dunbartonshire
         "toolTipText" : qsTr("West Dunbartonshire"),
         "x" : "0.282",
         "y" : "0.1715"
      },
      {
         "pixmapfile" : "scotland/east_renfrewshire.svgz",
         //: Council areas of Scotland: East Renfrewshire
         "toolTipText" : qsTr("East Renfrewshire"),
         "x" : "0.3188",
         "y" : "0.3099"
      },
      {
         "pixmapfile" : "scotland/renfrewshire.svgz",
         //: Council areas of Scotland: Renfrewshire
         "toolTipText" : qsTr("Renfrewshire"),
         "x" : "0.2677",
         "y" : "0.2541"
      },
      {
         "pixmapfile" : "scotland/inverclyde.svgz",
         //: Council areas of Scotland: Inverclyde
         "toolTipText" : qsTr("Inverclyde"),
         "x" : "0.2178",
         "y" : "0.2214"
      },
      {
         "pixmapfile" : "scotland/north_ayrshire.svgz",
         //: Council areas of Scotland: North Ayrshire
         "toolTipText" : qsTr("North Ayrshire"),
         "x" : "0.1627",
         "y" : "0.36"
      },
      {
         "pixmapfile" : "scotland/clackmannanshire.svgz",
         //: Council areas of Scotland: Clackmannanshire
         "toolTipText" : qsTr("Clackmannanshire"),
         "x" : "0.5029",
         "y" : "0.0778"
      }
   ]
}
