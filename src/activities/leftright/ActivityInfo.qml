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
    name: "leftright/Leftright.qml"
    difficulty: 2
    icon: "leftright/leftright.svg"
    author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
    demo: false
    //: Activity title
    title: qsTr("Find your left and right hands")
    //: Help title
    description: qsTr("Determine if a hand is a right or a left hand")
//  intro: "Guess if the picture presents a left or right hand and click on the correct answer."
    //: Help goal
    goal: qsTr("Distinguish right and left hands from different points of view. Spatial representation")
    //: Help prerequisite
    prerequisite: ""
    //: Help manual
    manual: qsTr("You can see a hand: is it a left hand or a right hand? Click on the left button, or the right button depending on the displayed hand.")
    credit: ""
    section: "puzzle"
    createdInVersion: 0
}
