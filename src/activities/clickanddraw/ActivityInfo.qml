/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Emmanuel Charruau <echarruau@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "clickanddraw/Clickanddraw.qml"
  difficulty: 1
  icon: "clickanddraw/clickanddraw.svg"
  author: "Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Click and draw")
  //: Help title
  description: qsTr("Draw the picture by clicking on the selected points.")
//  intro: "Click on the selected points and draw"
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: qsTr("Can move the mouse and click accurately on points.")
  //: Help manual
  manual: qsTr("Draw the picture by clicking on each point in sequence. Each time a point is selected the next blue one appears.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 0
}
