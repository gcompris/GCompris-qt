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
    name: "alphabet-sequence/AlphabetSequence.qml"
    difficulty: 2
    icon: "alphabet-sequence/alphabet-sequence.svg"
    author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
    demo: false
    //: Activity title
    title: qsTr("Alphabet sequence")
    //: Help title
    description: qsTr("Move the helicopter to catch the clouds following the order of the alphabet")
//    intro: "Move the helicopter to catch the clouds following the order of the alphabet."
    //: Help goal
    goal: qsTr("Alphabet sequence")
    //: Help prerequisite
    prerequisite: qsTr("Can decode letters")
    //: Help manual
    manual: qsTr("Catch the alphabet letters. With a keyboard use the arrow keys to move the helicopter. With a pointing device you just click or tap on the target location. To know which letter you have to catch you can either remember it or check the bottom right corner.")
    credit: ""
    section: "reading"
}
