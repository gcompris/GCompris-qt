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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
    name: "numbers-odd-even/NumbersOddEven.qml"
    difficulty: 2
    icon: "numbers-odd-even/numbers-odd-even.svg"
    author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
    demo: false
    //: Activity title
    title: qsTr("Even and Odd Numbers")
    //: Help title
    description: qsTr("Move the helicopter to catch the clouds having even or odd numbers")
//  intro: "Move the helicopter to catch the clouds having even or odd numbers"
    //: Help goal
    goal: qsTr("Numeration training")
    //: Help prerequisite
    prerequisite: ""
    //: Help manual
    manual: qsTr("Catch the odd or even number clouds. With a keyboard use the arrow keys to move the helicopter. With a pointing device you just click or tap on the target location. To know which number you have to catch you can either remember it or check the bottom right corner.")
    credit: ""
    section: "math numeration"
}
