/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("Southern Scotland")
   property var levels: [
      {
         "pixmapfile" : "scotland/bg_south_blank.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "scotland/s_borders.png",
         //: District of Southern Scotland: Scottish Borders
         "toolTipText" : qsTr("Scottish Borders"),
         "x" : "0.803",
         "y" : "0.564"
      },
      {
         "pixmapfile" : "scotland/s_east_lothian.png",
         //: District of Southern Scotland: East Lothian
         "toolTipText" : qsTr("East Lothian"),
         "x" : "0.813",
         "y" : "0.413"
      },
      {
         "pixmapfile" : "scotland/s_midlothian.png",
         //: District of Southern Scotland: Midlothian
         "toolTipText" : qsTr("Midlothian"),
         "x" : "0.749",
         "y" : "0.458"
      },
      {
         "pixmapfile" : "scotland/s_west_lothian.png",
         //: District of Southern Scotland: West Lothian
         "toolTipText" : qsTr("West Lothian"),
         "x" : "0.666",
         "y" : "0.433"
      },
      {
         "pixmapfile" : "scotland/s_edinburgh.png",
         //: District of Southern Scotland: Edinburgh
         "toolTipText" : qsTr("Edinburgh"),
         "x" : "0.723",
         "y" : "0.424"
      },
      {
         "pixmapfile" : "scotland/s_falkirk.png",
         //: District of Southern Scotland: Falkirk
         "toolTipText" : qsTr("Falkirk"),
         "x" : "0.638",
         "y" : "0.391"
      },
      {
         "pixmapfile" : "scotland/s_south_lanarkshire.png",
         //: District of Southern Scotland: South Lanarkshire
         "toolTipText" : qsTr("South Lanarkshire"),
         "x" : "0.626",
         "y" : "0.551"
      },
      {
         "pixmapfile" : "scotland/s_north_lanarkshire.png",
         //: District of Southern Scotland: North Lanarkshire
         "toolTipText" : qsTr("North Lanarkshire"),
         "x" : "0.607",
         "y" : "0.433"
      },
      {
         "pixmapfile" : "scotland/s_dumfries_galloway.png",
         //: District of Southern Scotland: Dumfries and Galloway
         "toolTipText" : qsTr("Dumfries and Galloway"),
         "x" : "0.597",
         "y" : "0.74"
      },
      {
         "pixmapfile" : "scotland/s_south_ayrshire.png",
         //: District of Southern Scotland: South Ayrshire"
         "toolTipText" : qsTr("South Ayrshire"),
         "x" : "0.476",
         "y" : "0.649"
      },
      {
         "pixmapfile" : "scotland/s_east_ayrshire.png",
         //: District of Southern Scotland: East Ayrshire
         "toolTipText" : qsTr("East Ayrshire"),
         "x" : "0.55",
         "y" : "0.593"
      },
      {
         "pixmapfile" : "scotland/s_glasgow.png",
         //: District of Southern Scotland: Glasgow
         "toolTipText" : qsTr("Glasgow"),
         "x" : "0.561",
         "y" : "0.444"
      },
      {
         "pixmapfile" : "scotland/s_east_dunbartonshire.png",
         //: District of Southern Scotland: East Dunbartonshire
         "toolTipText" : qsTr("East Dunbartonshire"),
         "x" : "0.561",
         "y" : "0.407"
      },
      {
         "pixmapfile" : "scotland/s_west_dunbartonshire.png",
         //: District of Southern Scotland: West Dunbartonshire
         "toolTipText" : qsTr("West Dunbartonshire"),
         "x" : "0.512",
         "y" : "0.398"
      },
      {
         "pixmapfile" : "scotland/s_east_renfrewshire.png",
         //: District of Southern Scotland: East Renfrewshire
         "toolTipText" : qsTr("East Renfrewshire"),
         "x" : "0.536",
         "y" : "0.484"
      },
      {
         "pixmapfile" : "scotland/s_renfrewshire.png",
         //: District of Southern Scotland: Renfrewshire
         "toolTipText" : qsTr("Renfrewshire"),
         "x" : "0.505",
         "y" : "0.449"
      },
      {
         "pixmapfile" : "scotland/s_inverclyde.png",
         //: District of Southern Scotland: Inverclyde
         "toolTipText" : qsTr("Inverclyde"),
         "x" : "0.474",
         "y" : "0.429"
      },
      {
         "pixmapfile" : "scotland/s_north_ayrshire.png",
         //: District of Southern Scotland: North Ayrshire
         "toolTipText" : qsTr("North Ayrshire"),
         "x" : "0.441",
         "y" : "0.516"
      },
      {
         "pixmapfile" : "scotland/s_clackmannanshire.png",
         //: District of Southern Scotland: Clackmannanshire
         "toolTipText" : qsTr("Clackmannanshire"),
         "x" : "0.644",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "scotland/s_fife.png",
         //: District of Southern Scotland: Fife
         "toolTipText" : qsTr("Fife"),
         "x" : "0.739",
         "y" : "0.307"
      },
      {
         "pixmapfile" : "scotland/s_dundee.png",
         //: District of Southern Scotland: Dundee
         "toolTipText" : qsTr("Dundee"),
         "x" : "0.772",
         "y" : "0.218"
      },
      {
         "pixmapfile" : "scotland/s_angus.png",
         //: District of Southern Scotland: Angus
         "toolTipText" : qsTr("Angus"),
         "x" : "0.782",
         "y" : "0.127"
      },
      {
         "pixmapfile" : "scotland/s_perth_kinross.png",
         //: District of Southern Scotland: Perth and Kinross
         "toolTipText" : qsTr("Perth and Kinross"),
         "x" : "0.618",
         "y" : "0.193"
      },
      {
         "pixmapfile" : "scotland/s_stirling.png",
         //: District of Southern Scotland: Stirling
         "toolTipText" : qsTr("Stirling"),
         "x" : "0.545",
         "y" : "0.3"
      },
      {
         "pixmapfile" : "scotland/s_argyll_bute.png",
         //: District of Southern Scotland: Argyll and Bute
         "toolTipText" : qsTr("Argyll and Bute"),
         "x" : "0.301",
         "y" : "0.396"
      }
   ]
}
