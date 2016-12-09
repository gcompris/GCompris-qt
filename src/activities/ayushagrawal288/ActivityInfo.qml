/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
 *
 * Authors:
 *  Ayush Agrawal <ayushagrawal288@gmail.com>
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
  name: "ayushagrawal288/Ayushagrawal288.qml"
  difficulty: 1
  icon: "ayushagrawal288/ayushagrawal288.png"
  author: "Ayush Agrawal &lt;ayushagrawal288@gmail.com&gt;"
  demo: true
  title: qsTr("Monuments")
  description: qsTr("Drag n Drop the Monuments according to where are they situated.")
  //intro: "Drag n Drop the Monuments according to which state of India are they situated."
  goal: qsTr("To Drag n Drop monuments on the Map of World")
  prerequisite: qsTr("Knowlegde of different monuments.")
  manual: qsTr("Catch the monuments. With the mouse drag it to the appropiate state. Then just release the mouse.")
  credit: qsTr("Photos taken from Wikipedia.")
  section: "discovery"
}
