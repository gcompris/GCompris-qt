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
  description: qsTr("Drag and Drop the regions to complete the country maps.")
//  intro: "Drag and drop the regions to complete the country maps."
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Drag and drop different regions of the country to their correct locations to complete the map.")
  credit: qsTr("The map of the counties of Norway is © Kartverket (the Norwegian Mapping Authority) and is released under the CC BY 4.0 license. Download links can be found at &lt;https://www.kartverket.no/til-lands/kart/illustrasjonskart&gt;.")
  section: "sciences geography"
  createdInVersion: 4000
  levels: "1,2,3,4"
}
