/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
  name: "scalesboard_weight_avoirdupois/ScalesboardWeight.qml"
  difficulty: 4
  icon: "scalesboard_weight_avoirdupois/scalesboard_weight_avoirdupois.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Balance the scales properly")
  //: Help title
  description: qsTr("Drag and Drop masses to balance the scales and calculate the weight in the avoirdupois unit")
//  intro: "Drag the weights up to balance the scales."
  //: Help goal
  goal: qsTr("Mental calculation, arithmetic equality, unit conversion")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("To balance the scales, move the masses to the left or the right side (on higher levels). They can be arranged in any order. Take care of the weight and the unit of the masses, remember that a pound (lb) is 16 ounce (oz).")
  credit: ""
  section: "math measures"
  createdInVersion: 0
}
