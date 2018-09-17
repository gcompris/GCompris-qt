/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bharath M S <brat.197@gmail.com>
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
  name: "align4/Align4.qml"
  difficulty: 2
  icon: "align4/align4.svg"
  author: "Bharath M S &lt;brat.197@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Align four (against Tux)")
  //: Help title
  description: qsTr("Arrange four tokens in a row")
//  intro: "Click on the column where you wish your token to fall and try to align of 4 tokens before Tux."
  //: Help goal
  goal: qsTr("Create a line of 4 tokens either horizontally (lying down), vertically (standing up) or diagonally.")
  //: Help manual
  manual: qsTr("Play with the computer. Take turns to click the line in which you want to drop a token. You can also use the arrow keys to move the token left or right, and the down or space key to drop a token. First player to create a line of 4 tokens wins")
  credit: ""
  section: "strategy"
  createdInVersion: 0
}
