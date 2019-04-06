/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
  name: "reversecount/Reversecount.qml"
  difficulty: 2
  icon: "reversecount/reversecount.svg"
  author: "Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
  demo: false
  //: Activity title
  title: qsTr("Practice subtraction with a fun game")
  //: Help title
  description: qsTr("Tux is hungry. Help him find fish by counting to the correct ice spot.")
//  intro: "Click on the domino and validate your choice with the OK button to indicate the number of ice blocks Tux will have to follow to eat a fish."
  //: Help goal
  goal: qsTr("Tux is hungry. Help him find fish by counting to the correct ice spot.")
  //: Help prerequisite
  prerequisite: qsTr("Can read numbers on a domino, and count intervals up to 10 for the first level")
  //: Help manual
  manual: qsTr("Click on the domino to show how many ice spots there are between Tux and the fish. Click the domino with the right mouse button to count backwards. When done, click on the OK button or hit the Enter key.")
  credit: ""
  section: "math numeration"
  createdInVersion: 0
  levels: "1,2"
}
