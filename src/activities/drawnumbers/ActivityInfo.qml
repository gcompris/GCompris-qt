/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Nitish Chauhan <nitish.nc18@gmail.com>
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
  name: "drawnumbers/Drawnumbers.qml"
  difficulty: 1
  icon: "drawnumbers/drawnumbers.svg"
  author: "Nitish Chauhan &lt;nitish.nc18@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Draw Numbers")
  //: Help title
  description: qsTr("Connect the dots to draw numbers from 0 to 9")
  // intro: "Draw the numbers by connecting the dots in the correct order."
  //: Help goal
  goal: qsTr("Learning how to draw the numbers in a funny way.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Draw the numbers by connecting the dots in the correct order")
  credit: ""
  section: "math numeration"
  createdInVersion: 7000
}
