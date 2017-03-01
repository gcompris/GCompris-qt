/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
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
  name: "ascending_order/Ascending_order.qml"
  difficulty: 2
  icon: "ascending_order/ascending_order.svg"
  author: "Rudra Nil Basu &lt;rudra.nil.basu.1996@gmail.com&gt;"
  demo: true
  title: qsTr("Ascending Order")
  description: qsTr("Arrange the given numbers in ascending order")
//  intro: "arrange the numbers in ascending order by placing a number in it's correct position"
  goal: qsTr("arranging numbers in ascending order")
  prerequisite: qsTr("Move, drag and drop using mouse")
  manual: qsTr("You are provided with few numbers. Drag and Drop the numbers in it's correct position to reorder the numbers in ascending order")
  section: "math"
  createdInVersion: 8000
}
