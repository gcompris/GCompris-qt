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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "clickanddraw/Clickanddraw.qml"
  difficulty: 1
  icon: "clickanddraw/clickanddraw.svg"
  author: "Emmanuel Charruau <echarruau@gmail.com>"
  demo: true
  title: qsTr("Click and draw")
  description: qsTr("Draw the picture by clicking on the green points.")
//  intro: "Click on the blue points and draw "
  goal: ""
  prerequisite: qsTr("Can move the mouse and click accurately on points.")
  manual: qsTr("Draw the picture by clicking on each green point in sequence. Each time a green point is selected the next green one appears.")
  credit: ""
  section: "computer mouse"
}
