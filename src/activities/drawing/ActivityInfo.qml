/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Toncu Stefan <stefan.toncu29@gmail.com>
 *               2018 Amit Sagtani <asagtani06@gmail.com>
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
  name: "drawing/Drawing.qml"
  difficulty: 1
  icon: "drawing/drawing.svg"
  author: "Stefan Toncu &lt;stefan.toncu29@gmail.com&gt;"
  demo: true
  title: qsTr("Drawing")
  description: qsTr("Use the various drawing tools to create beautiful arts.")
  //intro: "Use various graphical tools to draw beautiful arts."
  goal: qsTr("Learn about basic drawing tools.")
  prerequisite: ""
  manual: qsTr("Select tools from the foldable panels to draw beautiful arts.<br><br>") +
          qsTr("<b>Keyboard Controls:</b><br>") +
          qsTr("1. Use Ctrl + Z to undo last changes.<br>") +
          qsTr("2. Use Ctrl + Y to redo last changes.<br>") +
          qsTr("3. Use Ctrl + N to erase the drawing.<br>") +
          qsTr("4. Use Ctrl + S to save the drawing.<br>") +
          qsTr("5. Use Ctrl + O to load the saved drawings.<br>")
  credit: ""
  section: "fun"
  createdInVersion: 9500
}
