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
    name: "ballcatch/Ballcatch.qml"
    difficulty: 1
    icon: "ballcatch/ballcatch.svg"
    author: "Johnny Jazeix <jazeix@gmail.com>"
    demo: false
    title: qsTr("Make the ball go to Tux")
    description: qsTr("Press the two shift keys at the same time, to make the ball go in a straight line.")
//    intro: "Press the two shift keys at the same time to send the ball straight on"
    goal: ""
    prerequisite: ""
    manual: qsTr("Press the two shift keys at the same time, to make the ball go in a straight line.")
    credit: ""
    section: "/computer/keyboard"
}
