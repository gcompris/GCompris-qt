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
import QtQuick 2.0

QtObject {
   property string instruction: qsTr("Asia")
   property variant levels: [
      {
         "pixmapfile": "asia/background.png",
         "type": "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile": "asia/russia.png",
         "toolTipText": qsTr("Russia"),
         "x": "0.497",
         "y": "0.215"
      },
      {
         "pixmapfile": "asia/mongolia.png",
         "toolTipText": qsTr("Mongolia"),
         "x": "0.562",
         "y": "0.341"
      },
      {
         "pixmapfile": "asia/japan.png",
         "toolTipText": qsTr("Japan"),
         "x": "0.855",
         "y": "0.437"
      },
      {
         "pixmapfile": "asia/north_korea.png",
         "toolTipText": qsTr("North Korea"),
         "x": "0.768",
         "y": "0.415"
      },
      {
         "pixmapfile": "asia/south_korea.png",
         "toolTipText": qsTr("South Korea"),
         "x": "0.79",
         "y": "0.459"
      },
      {
         "pixmapfile": "asia/kazakhstan.png",
         "toolTipText": qsTr("Kazakhstan"),
         "x": "0.293",
         "y": "0.328"
      },
      {
         "pixmapfile": "asia/uzbekistan.png",
         "toolTipText": qsTr("Uzbekistan"),
         "x": "0.289",
         "y": "0.403"
      },
      {
         "pixmapfile": "asia/taiwan.png",
         "toolTipText": qsTr("Taiwan"),
         "x": "0.772",
         "y": "0.603"
      },
      {
         "pixmapfile": "asia/vietnam.png",
         "toolTipText": qsTr("Vietnam"),
         "x": "0.661",
         "y": "0.691"
      },
      {
         "pixmapfile": "asia/cambodia.png",
         "toolTipText": qsTr("Cambodia"),
         "x": "0.658",
         "y": "0.732"
      },
      {
         "pixmapfile": "asia/laos.png",
         "toolTipText": qsTr("Laos"),
         "x": "0.644",
         "y": "0.664"
      },
      {
         "pixmapfile": "asia/thailand.png",
         "toolTipText": qsTr("Thailand"),
         "x": "0.627",
         "y": "0.723"
      },
      {
         "pixmapfile": "asia/sri_lanka.png",
         "toolTipText": qsTr("Sri Lanka"),
         "x": "0.465",
         "y": "0.785"
      },
      {
         "pixmapfile": "asia/china.png",
         "toolTipText": qsTr("China"),
         "x": "0.577",
         "y": "0.466"
      },
      {
         "pixmapfile": "asia/india.png",
         "toolTipText": qsTr("India"),
         "x": "0.465",
         "y": "0.624"
      },
      {
         "pixmapfile": "asia/bangladesh.png",
         "toolTipText": qsTr("Bangladesh"),
         "x": "0.532",
         "y": "0.602"
      },
      {
         "pixmapfile": "asia/bhutan.png",
         "toolTipText": qsTr("Bhutan"),
         "x": "0.523",
         "y": "0.561"
      },
      {
         "pixmapfile": "asia/nepal.png",
         "toolTipText": qsTr("Nepal"),
         "x": "0.472",
         "y": "0.55"
      },
      {
         "pixmapfile": "asia/pakistan.png",
         "toolTipText": qsTr("Pakistan"),
         "x": "0.344",
         "y": "0.527"
      },
      {
         "pixmapfile": "asia/myanmar.png",
         "toolTipText": qsTr("Myanmar"),
         "x": "0.579",
         "y": "0.65"
      },
      {
         "pixmapfile": "asia/philippines.png",
         "toolTipText": qsTr("Philippines"),
         "x": "0.8",
         "y": "0.736"
      },
      {
         "pixmapfile": "asia/indonesia.png",
         "toolTipText": qsTr("Indonesia"),
         "x": "0.727",
         "y": "0.9"
      },
      {
         "pixmapfile": "asia/malaysia.png",
         "toolTipText": qsTr("Malaysia"),
         "x": "0.699",
         "y": "0.831"
      },
      {
         "pixmapfile": "asia/afghanistan.png",
         "toolTipText": qsTr("Afghanistan"),
         "x": "0.328",
         "y": "0.487"
      },
      {
         "pixmapfile": "asia/tajikistan.png",
         "toolTipText": qsTr("Tajikistan"),
         "x": "0.35",
         "y": "0.429"
      },
      {
         "pixmapfile": "asia/kyrgyzstan.png",
         "toolTipText": qsTr("Kyrgyzstan"),
         "x": "0.371",
         "y": "0.404"
      },
      {
         "pixmapfile": "asia/turkmenistan.png",
         "toolTipText": qsTr("Turkmenistan"),
         "x": "0.26",
         "y": "0.428"
      },
      {
         "pixmapfile": "asia/iran.png",
         "toolTipText": qsTr("Iran"),
         "x": "0.224",
         "y": "0.505"
      },
      {
         "pixmapfile": "asia/azerbaijan.png",
         "toolTipText": qsTr("Azerbaijan"),
         "x": "0.163",
         "y": "0.414"
      },
      {
         "pixmapfile": "asia/georgia.png",
         //: Translators: Strip Asia| and translate only Georgia
         "toolTipText": qsTr("Asia|Georgia"),
         "x": "0.133",
         "y": "0.389"
      },
      {
         "pixmapfile": "asia/turkey.png",
         "toolTipText": qsTr("Turkey"),
         "x": "0.077",
         "y": "0.428"
      },
      {
         "pixmapfile": "asia/syria.png",
         "toolTipText": qsTr("Syria"),
         "x": "0.108",
         "y": "0.478"
      },
      {
         "pixmapfile": "asia/iraq.png",
         "toolTipText": qsTr("Iraq"),
         "x": "0.15",
         "y": "0.492"
      },
      {
         "pixmapfile": "asia/jordan.png",
         "toolTipText": qsTr("Jordan"),
         "x": "0.1",
         "y": "0.517"
      },
      {
         "pixmapfile": "asia/saudi_arabia.png",
         "toolTipText": qsTr("Saudi Arabia"),
         "x": "0.167",
         "y": "0.592"
      },
      {
         "pixmapfile": "asia/yemen.png",
         "toolTipText": qsTr("Yemen"),
         "x": "0.192",
         "y": "0.692"
      },
      {
         "pixmapfile": "asia/united_arab_emirates.png",
         "toolTipText": qsTr("United Arab Emirates"),
         "x": "0.236",
         "y": "0.598"
      },
      {
         "pixmapfile": "asia/oman.png",
         "toolTipText": qsTr("Oman"),
         "x": "0.255",
         "y": "0.628"
      },
      {
         "pixmapfile": "asia/armenia.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.15",
         "y": "0.415"
      },
      {
         "pixmapfile": "asia/kuwait.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.18",
         "y": "0.538"
      },
      {
         "pixmapfile": "asia/cyprus.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.065",
         "y": "0.472"
      },
      {
         "pixmapfile": "asia/lebanon.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.086",
         "y": "0.487"
      },
      {
         "pixmapfile": "asia/bahrain.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.208",
         "y": "0.575"
      },
      {
         "pixmapfile": "asia/qatar.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.214",
         "y": "0.586"
      },
      {
         "pixmapfile": "asia/brunei.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.744",
         "y": "0.821"
      },
      {
         "pixmapfile": "asia/israel.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.08",
         "y": "0.517"
      },
      {
         "pixmapfile": "asia/palestine.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.081",
         "y": "0.516"
      },
      {
         "pixmapfile": "asia/red_sea.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.128",
         "y": "0.662"
      },
      {
         "pixmapfile": "asia/africa2.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.176",
         "y": "0.808"
      },
      {
         "pixmapfile": "asia/africa.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.054",
         "y": "0.769"
      },
      {
         "pixmapfile": "asia/persian_gulf.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.223",
         "y": "0.563"
      },
      {
         "pixmapfile": "asia/mediteranean_sea.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.042",
         "y": "0.485"
      },
      {
         "pixmapfile": "asia/black_sea.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.059",
         "y": "0.344"
      },
      {
         "pixmapfile": "asia/caspian_sea.png",
         "type": "SHAPE_BACKGROUND",
         "x": "0.189",
         "y": "0.398"
      }
   ]
}
