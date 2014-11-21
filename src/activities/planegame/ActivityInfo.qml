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
    prerequisite: ""
    manual: qsTr("Catch the clouds in increasing order. With a keyboard use the arrow keys to move the helicopter. On a touch screen place a finger on the screen and quickly swipe it in the desired direction. To know which number you have to catch you can either remember it or check the bottom right corner.")
    credit: ""
  section: "math numeration"
}
