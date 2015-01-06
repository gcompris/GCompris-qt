/* gcompris - ActivityInfo.qml

 Copyright (C)
 2014: Bruno Coudoin: initial version

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
    name: "numbers-odd-even/NumbersOddEven.qml"
    difficulty: 2
    icon: "numbers-odd-even/numbers-odd-even.svg"
    author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
    demo: false
    title: qsTr("Even and Odd Numbers")
    description: qsTr("Move the helicopter to catch the clouds having even or odd numbers")
//  intro: "Move the helicopter to catch the clouds having even or odd numbers"
    goal: qsTr("Numeration training")
    prerequisite: qsTr("Number")
    manual: qsTr("Catch the odd or even numbers, using the up, down, right and left arrows on the keyboard to move the helicopter.")
    credit: ""
    section: "math numeration"
}
