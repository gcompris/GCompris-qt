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
  name: "drawnumber/Drawnumber.qml"
  difficulty: 2
  icon: "drawnumber/drawnumber.svg"
  author: "Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
  demo: true
  title: qsTr("Number sequence")
  description: qsTr("Touch the numbers in the right sequence.")
//  intro: "Draw the picture by touching each number in the right sequence."
  goal: qsTr("Can count from 1 to 50.")
  prerequisite: ""
  manual: qsTr("Draw the picture by touching each number in the right sequence, or sliding your finger or dragging the mouse through the numbers in the correct sequence.")
  credit: ""
  section: "math numeration"
}
