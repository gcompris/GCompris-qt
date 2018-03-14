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
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Southern Scotland")
   property var levels: [
      {
         "pixmapfile" : "scotland/bg_south_blank.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "scotland/s_borders.png",
         "toolTipText" : "Scottish Borders",
         "x" : "0.803",
         "y" : "0.564"
      },
      {
         "pixmapfile" : "scotland/s_east_lothian.png",
         "toolTipText" : "East Lothian",
         "x" : "0.813",
         "y" : "0.413"
      },
      {
         "pixmapfile" : "scotland/s_midlothian.png",
         "toolTipText" : "Midlothian",
         "x" : "0.749",
         "y" : "0.458"
      },
      {
         "pixmapfile" : "scotland/s_west_lothian.png",
         "toolTipText" : "West Lothian",
         "x" : "0.666",
         "y" : "0.433"
      },
      {
         "pixmapfile" : "scotland/s_edinburgh.png",
         "toolTipText" : "Edinburgh",
         "x" : "0.723",
         "y" : "0.424"
      },
      {
         "pixmapfile" : "scotland/s_falkirk.png",
         "toolTipText" : "Falkirk",
         "x" : "0.638",
         "y" : "0.391"
      },
      {
         "pixmapfile" : "scotland/s_south_lanarkshire.png",
         "toolTipText" : "South Lanarkshire",
         "x" : "0.626",
         "y" : "0.551"
      },
      {
         "pixmapfile" : "scotland/s_north_lanarkshire.png",
         "toolTipText" : "North Lanarkshire",
         "x" : "0.607",
         "y" : "0.433"
      },
      {
         "pixmapfile" : "scotland/s_dumfries_galloway.png",
         "toolTipText" : "Dumfries and Galloway",
         "x" : "0.597",
         "y" : "0.74"
      },
      {
         "pixmapfile" : "scotland/s_south_ayrshire.png",
         "toolTipText" : "South Ayrshire",
         "x" : "0.476",
         "y" : "0.649"
      },
      {
         "pixmapfile" : "scotland/s_east_ayrshire.png",
         "toolTipText" : "East Ayrshire",
         "x" : "0.55",
         "y" : "0.593"
      },
      {
         "pixmapfile" : "scotland/s_glasgow.png",
         "toolTipText" : "Glasgow",
         "x" : "0.561",
         "y" : "0.444"
      },
      {
         "pixmapfile" : "scotland/s_east_dunbartonshire.png",
         "toolTipText" : "East Dunbartonshire",
         "x" : "0.561",
         "y" : "0.407"
      },
      {
         "pixmapfile" : "scotland/s_west_dunbartonshire.png",
         "toolTipText" : "West Dunbartonshire",
         "x" : "0.512",
         "y" : "0.398"
      },
      {
         "pixmapfile" : "scotland/s_east_renfrewshire.png",
         "toolTipText" : "East Renfrewshire",
         "x" : "0.536",
         "y" : "0.484"
      },
      {
         "pixmapfile" : "scotland/s_renfrewshire.png",
         "toolTipText" : "Renfrewshire",
         "x" : "0.505",
         "y" : "0.449"
      },
      {
         "pixmapfile" : "scotland/s_inverclyde.png",
         "toolTipText" : "Inverclyde",
         "x" : "0.474",
         "y" : "0.429"
      },
      {
         "pixmapfile" : "scotland/s_north_ayrshire.png",
         "toolTipText" : "North Ayrshire",
         "x" : "0.441",
         "y" : "0.516"
      },
      {
         "pixmapfile" : "scotland/s_clackmannanshire.png",
         "toolTipText" : "Clackmannanshire",
         "x" : "0.644",
         "y" : "0.34"
      },
      {
         "pixmapfile" : "scotland/s_fife.png",
         "toolTipText" : "Fife",
         "x" : "0.739",
         "y" : "0.307"
      },
      {
         "pixmapfile" : "scotland/s_dundee.png",
         "toolTipText" : "Dundee",
         "x" : "0.772",
         "y" : "0.218"
      },
      {
         "pixmapfile" : "scotland/s_angus.png",
         "toolTipText" : "Angus",
         "x" : "0.782",
         "y" : "0.127"
      },
      {
         "pixmapfile" : "scotland/s_perth_kinross.png",
         "toolTipText" : "Perth and Kinross",
         "x" : "0.618",
         "y" : "0.193"
      },
      {
         "pixmapfile" : "scotland/s_stirling.png",
         "toolTipText" : "Stirling",
         "x" : "0.545",
         "y" : "0.3"
      },
      {
         "pixmapfile" : "scotland/s_argyll_bute.png",
         "toolTipText" : "Argyll and Bute",
         "x" : "0.301",
         "y" : "0.396"
      }
   ]
}
