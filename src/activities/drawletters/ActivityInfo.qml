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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
    name: "drawletters/Drawletters.qml"
      difficulty: 1
      icon: "drawletters/drawletters.svg"
      author: "Nitish Chauhan &lt;nitish.nc18@gmail.com&gt;"
      demo: true
      title: "Draw Letters"
      description: qsTr("Connect the dots to draw some alphabets")
      //intro: "put here in comment the text for the intro voice"
      goal: qsTr("Children will learn about different letters & alphabets in a fun way.")
      prerequisite: ""
      manual: qsTr("Draw the figure by connecting the dots in the correct order")
      credit: ""
      section: "reading"
      createdInVersion: 7000

}
