/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0

ActivityInfo {
  name: "geo-country/GeoCountry.qml"
  difficulty: 2
  icon: "geo-country/geo-country.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Locate the region")
  //: Help title
  description: qsTr("Place the regions on the country maps.")
//  intro: "Drag and drop the regions to complete the country maps."
  //: Help goal
  goal: qsTr("Learn to locate and place the regions of countries.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Drag and drop the regions to their correct location to complete the map.")
  credit: ""
  section: "sciences geography"
  createdInVersion: 4000
  levels: "1,2,3,4"
}
