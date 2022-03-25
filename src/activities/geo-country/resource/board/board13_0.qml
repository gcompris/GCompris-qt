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
   property string instruction: qsTr("States and Territories of Australia")
   property var levels: [
      {
         "pixmapfile" : "australia/australia.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "australia/western_australia.svgz",
         //: State of Australia: Western Australia
         "toolTipText" : qsTr("Western Australia"),
         "x" : "0.2137",
         "y" : "0.4461"
      },
      {
         "pixmapfile" : "australia/northern_territory.svgz",
         //: Territory of Australia: Northern Territory
         "toolTipText" : qsTr("Northern Territory"),
         "x" : "0.5062",
         "y" : "0.2723"
      },
      {
         "pixmapfile" : "australia/south_australia.svgz",
         //: State of Australia: South Australia
         "toolTipText" : qsTr("South Australia"),
         "x" : "0.5438",
         "y" : "0.639"
      },
      {
         "pixmapfile" : "australia/queensland.svgz",
         //: State of Australia: Queensland
         "toolTipText" : qsTr("Queensland"),
         "x" : "0.7975",
         "y" : "0.3064"
      },
      {
         "pixmapfile" : "australia/new_south_wales.svgz",
         //: State of Australia: New South Wales
         "toolTipText" : qsTr("New South Wales"),
         "x" : "0.8236",
         "y" : "0.6816"
      },
      {
         "pixmapfile" : "australia/victoria.svgz",
         //: State of Australia: Victoria
         "toolTipText" : qsTr("Victoria"),
         "x" : "0.7629",
         "y" : "0.7679"
      },
      {
         "pixmapfile" : "australia/tasmania.svgz",
         //: State of Australia: Tasmania
         "toolTipText" : qsTr("Tasmania"),
         "x" : "0.7712",
         "y" : "0.9067"
      },
      {
         "pixmapfile" : "australia/capital.svgz",
         //: Territory of Australia: Australian Capital Territory
         "toolTipText" : qsTr("Australian Capital Territory"),
         "x" : "0.8462",
         "y" : "0.7495"
      }
   ]
}
