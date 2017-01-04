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
  demo: false
  title: qsTr("Ascending Order")
  description: qsTr("Arrange the given numbers in ascending order")
  //intro: "click on the numbers in ascending order"
  goal: qsTr("arranging numbers in ascending order")
  prerequisite: qsTr("Move a mouse and click on the correct place")
  manual: qsTr("You are provided with few numbers. Click on the smallest number first, second smallest number second, and the largest number in the last")
  credit: "openclipart.org"
  section: qsTr("math")
}
