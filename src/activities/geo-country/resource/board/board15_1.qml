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
   property string instruction: qsTr("Council areas of Scotland (South)")
   property var levels: [
      {
         "pixmapfile" : "scotland/scotland-south.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "scotland/angus.svgz",
         //: Council area of Scotland: Angus
         "toolTipText" : qsTr("Angus"),
         "x" : "0.8105",
         "y" : "0.1382"
      },
      {
         "pixmapfile" : "scotland/dundee.svgz",
         //: Council area of Scotland: Dundee
         "toolTipText" : qsTr("Dundee"),
         "x" : "0.7997",
         "y" : "0.2372"
      },
      {
         "pixmapfile" : "scotland/perth_and_kinross.svgz",
         //: Council area of Scotland: Perth and Kinross
         "toolTipText" : qsTr("Perth and Kinross"),
         "x" : "0.6226",
         "y" : "0.2081"
      },
      {
         "pixmapfile" : "scotland/stirling.svgz",
         //: Council area of Scotland: Stirling
         "toolTipText" : qsTr("Stirling"),
         "x" : "0.533",
         "y" : "0.3195"
      },
      {
         "pixmapfile" : "scotland/argyll_and_bute.svgz",
         //: Council area of Scotland: Argyll and Bute
         "toolTipText" : qsTr("Argyll and Bute"),
         "x" : "0.2556",
         "y" : "0.4083"
      },
      {
         "pixmapfile" : "scotland/fife.svgz",
         //: Council area of Scotland: Fife
         "toolTipText" : qsTr("Fife"),
         "x" : "0.7596",
         "y" : "0.3348"
      },
      {
         "pixmapfile" : "scotland/scottish_borders.svgz",
         //: Council areas of Scotland: Scottish Borders
         "toolTipText" : qsTr("Scottish Borders"),
         "x" : "0.8302",
         "y" : "0.6158"
      },
      {
         "pixmapfile" : "scotland/east_lothian.svgz",
         //: Council areas of Scotland: East Lothian
         "toolTipText" : qsTr("East Lothian"),
         "x" : "0.8441",
         "y" : "0.4502"
      },
      {
         "pixmapfile" : "scotland/midlothian.svgz",
         //: Council areas of Scotland: Midlothian
         "toolTipText" : qsTr("Midlothian"),
         "x" : "0.7683",
         "y" : "0.4976"
      },
      {
         "pixmapfile" : "scotland/west_lothian.svgz",
         //: Council areas of Scotland: West Lothian
         "toolTipText" : qsTr("West Lothian"),
         "x" : "0.6701",
         "y" : "0.4696"
      },
      {
         "pixmapfile" : "scotland/edinburgh.svgz",
         //: Council areas of Scotland: Edinburgh
         "toolTipText" : qsTr("Edinburgh"),
         "x" : "0.7383",
         "y" : "0.4607"
      },
      {
         "pixmapfile" : "scotland/falkirk.svgz",
         //: Council areas of Scotland: Falkirk
         "toolTipText" : qsTr("Falkirk"),
         "x" : "0.6392",
         "y" : "0.4226"
      },
      {
         "pixmapfile" : "scotland/south_lanarkshire.svgz",
         //: Council areas of Scotland: South Lanarkshire
         "toolTipText" : qsTr("South Lanarkshire"),
         "x" : "0.6234",
         "y" : "0.5939"
      },
      {
         "pixmapfile" : "scotland/north_lanarkshire.svgz",
         //: Council areas of Scotland: North Lanarkshire
         "toolTipText" : qsTr("North Lanarkshire"),
         "x" : "0.6021",
         "y" : "0.4687"
      },
      {
         "pixmapfile" : "scotland/dumfries_and_galloway.svgz",
         //: Council areas of Scotland: Dumfries and Galloway
         "toolTipText" : qsTr("Dumfries and Galloway"),
         "x" : "0.5798",
         "y" : "0.7965"
      },
      {
         "pixmapfile" : "scotland/south_ayrshire.svgz",
         //: Council areas of Scotland: South Ayrshire
         "toolTipText" : qsTr("South Ayrshire"),
         "x" : "0.441",
         "y" : "0.6943"
      },
      {
         "pixmapfile" : "scotland/east_ayrshire.svgz",
         //: Council areas of Scotland: East Ayrshire
         "toolTipText" : qsTr("East Ayrshire"),
         "x" : "0.5319",
         "y" : "0.6364"
      },
      {
         "pixmapfile" : "scotland/glasgow.svgz",
         //: Council areas of Scotland: Glasgow
         "toolTipText" : qsTr("Glasgow"),
         "x" : "0.5477",
         "y" : "0.4771"
      },
      {
         "pixmapfile" : "scotland/east_dunbartonshire.svgz",
         //: Council areas of Scotland: East Dunbartonshire
         "toolTipText" : qsTr("East Dunbartonshire"),
         "x" : "0.5495",
         "y" : "0.435"
      },
      {
         "pixmapfile" : "scotland/west_dunbartonshire.svgz",
         //: Council areas of Scotland: West Dunbartonshire
         "toolTipText" : qsTr("West Dunbartonshire"),
         "x" : "0.4918",
         "y" : "0.4229"
      },
      {
         "pixmapfile" : "scotland/east_renfrewshire.svgz",
         //: Council areas of Scotland: East Renfrewshire
         "toolTipText" : qsTr("East Renfrewshire"),
         "x" : "0.5152",
         "y" : "0.5196"
      },
      {
         "pixmapfile" : "scotland/renfrewshire.svgz",
         //: Council areas of Scotland: Renfrewshire
         "toolTipText" : qsTr("Renfrewshire"),
         "x" : "0.4806",
         "y" : "0.4784"
      },
      {
         "pixmapfile" : "scotland/inverclyde.svgz",
         //: Council areas of Scotland: Inverclyde
         "toolTipText" : qsTr("Inverclyde"),
         "x" : "0.4459",
         "y" : "0.4556"
      },
      {
         "pixmapfile" : "scotland/north_ayrshire.svgz",
         //: Council areas of Scotland: North Ayrshire
         "toolTipText" : qsTr("North Ayrshire"),
         "x" : "0.4035",
         "y" : "0.5477"
      },
      {
         "pixmapfile" : "scotland/clackmannanshire.svgz",
         //: Council areas of Scotland: Clackmannanshire
         "toolTipText" : qsTr("Clackmannanshire"),
         "x" : "0.6493",
         "y" : "0.3642"
      }
   ]
}
