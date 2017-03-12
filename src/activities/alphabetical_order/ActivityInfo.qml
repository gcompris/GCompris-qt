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
  name: "alphabetical_order/Alphabetical_order.qml"
  difficulty: 2
  icon: "alphabetical_order/alphabetical_order.svg"
  author: "Rudra Nil Basu &lt;rudra.nil.basu.1996@gmail.com&gt;"
  demo: true
  title: "Alphabetical Order"
  description: qsTr("Arrange the given alphabets in ascending or descending order as instructed")
  //intro: "arrange the alphabets in the correct order by placing an alphabet in it's correct position"
  goal: qsTr("arranging alphabets in ascending or descending order as instructed")
  prerequisite: qsTr("Move, drag and drop using mouse")
  manual: qsTr("You are provided with few alphabets. Drag and Drop the alphabets in its correct position to reorder the numbers in ascending or descending order as instructed")
  section: "math"
  createdInVersion: 8000
}
