/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <mudithkr@gmail.com>
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
  name: "mudit_test/Mudit_test.qml"
  difficulty: 1
  icon: "mudit_test/mudit_test.svg"
  author: "Mudit Sharma &lt;mudithkr@gmail.com&gt;"
  demo: true
  title: qsTr("Recognizing Shapes")
  description: qsTr("Select the correct shape")
  //intro: "Pick the right shape"
  goal: qsTr("This activity teaches you to recognize different shapes,Click the correct shape as asked in question")
  prerequisite: qsTr("Recognize color")
  manual: qsTr("read the question and select the correct image")
  credit: ""
  section: "fun"
}
