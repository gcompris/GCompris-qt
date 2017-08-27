/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
  name: "tangram/Tangram.qml"
  difficulty: 3
  icon: "tangram/tangram.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("The tangram puzzle game")
  //: Help title
  description: qsTr("The objective is to form a given shape")
  // intro: "Click on each object to obtain the same figure. You can change their orientation by clicking on the arrows."
  //: Help goal
  goal: qsTr("From Wikipedia, the free encyclopedia. Tangram (Chinese: literally 'seven boards of cunning') is a Chinese puzzle. While the tangram is often said to be ancient, its existence has only been verified as far back as 1800. It consists of 7 pieces, called tans, which fit together to form a square; Using the square side as 1 unit, the 7 pieces contains:
    5 right isosceles triangles, including:
        - 2 small size ones (legs of 1)
        - 1 medium size (legs of square root of 2)
        - 2 large size (legs of 2)
    1 square (side of 1) and
    1 parallelogram (sides of 1 and square root of 2)
    ")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation")
  //: Help manual
  manual: qsTr("Select the tangram to form. Move a piece by dragging it. The symmetrical button appears on items that supports it. Click on the rotation button or drag around it to show the rotation you want. At first levels, simpler objects are used to introduce the tangram concept.")
  credit: ""
  section: "puzzle"
  createdInVersion: 6000
}
