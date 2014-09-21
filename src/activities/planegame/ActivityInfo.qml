/* gcompris - ActivityInfo.qml

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import GCompris 1.0

ActivityInfo {
    name: "planegame/Sequence.qml"
    difficulty: 2
    icon: "planegame/planegame.svg"
    author: "Johnny Jazeix <jazeix@gmail.com>"
    demo: false
    title: qsTr("Numbers in Order")
    description: qsTr("Move the helicopter to catch the clouds in the correct order")
//  intro: "Move the helicopter with the arrow keys and catch the number in the clouds in numerical order."
    goal: qsTr("Numeration training")
    prerequisite: qsTr("Number")
    manual: qsTr("Catch the numbers in increasing order, using the up, down, right and left arrows on the keyboard to move the helicopter.")
    credit: ""
  section: "/math/numeration"
}
