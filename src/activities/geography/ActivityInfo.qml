/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import core 1.0

ActivityInfo {
  name: "geography/Geography.qml"
  difficulty: 2
  icon: "geography/geography.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  //: Activity title
  title: qsTr("Locate the countries")
  //: Help title
  description: qsTr("Place the continents and countries on the world map.")
//  intro: "Drag and drop the objects to complete the map."
  //: Help goal
  goal: qsTr("Learn to locate and place the continents and many countries on the world map.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Drag and drop the map pieces to their correct location to complete the map.")
  credit: ""
  section: "sciences geography"
  createdInVersion: 4000
}
