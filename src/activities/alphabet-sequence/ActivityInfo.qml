/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "alphabet-sequence/AlphabetSequence.qml"
    difficulty: 2
    icon: "alphabet-sequence/alphabet-sequence.svg"
    author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
    //: Activity title
    title: qsTr("Alphabet sequence")
    //: Help title
    description: qsTr("Move the helicopter to catch the clouds following the order of the alphabet.")
//    intro: "Move the helicopter to catch the clouds following the order of the alphabet."
    //: Help goal
    goal: qsTr("Alphabet sequence.")
    //: Help prerequisite
    prerequisite: qsTr("Can decode letters.")
    //: Help manual
    manual: qsTr("Catch the alphabet letters. With a keyboard use the arrow keys to move the helicopter. With a pointing device you just click or tap on the target location. To know which letter you have to catch you can either remember it or check the bottom right corner.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: move the helicopter") + ("</li></ul>")
    credit: ""
    section: "reading letters"
    createdInVersion: 0
}
