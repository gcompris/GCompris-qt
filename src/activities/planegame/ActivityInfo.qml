/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Johnny Jazeix <jazeix@gmail.com>
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
    name: "planegame/Sequence.qml"
    difficulty: 2
    icon: "planegame/planegame.svg"
    author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
    demo: true
    //: Activity title
    title: qsTr("Numbers in Order")
    //: Help title
    description: qsTr("Move the helicopter to catch the clouds in the correct order")
//  intro: "Move the helicopter with the arrow keys and catch the numbers in the clouds, in ascending order."
    //: Help goal
    goal: qsTr("Numeration training")
    //: Help prerequisite
    prerequisite: ""
    //: Help manual
    manual: qsTr("Catch the clouds in increasing order. With a keyboard use the arrow keys to move the helicopter. With a pointing device you just click or tap on the target location. To know which number you have to catch you can either remember it or check the bottom right corner.")
    credit: ""
  section: "math numeration"
  createdInVersion: 0
}
