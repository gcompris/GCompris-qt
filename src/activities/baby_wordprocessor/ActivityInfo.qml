/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "baby_wordprocessor/BabyWordprocessor.qml"
  difficulty: 1
  icon: "baby_wordprocessor/baby_wordprocessor.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("A baby word processor")
  //: Help title
  description: qsTr("A simplistic word processor to let the children play around with a keyboard and see letters.")
  //intro: "A simplistic word processor to play around with the keyboard"
  //: Help goal
  goal: qsTr("Discover the keyboard and the letters.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Just type on the real or virtual keyboard like in a word processor.
    Clicking on the 'Title' button will make the text bigger. Similarly, the 'subtitle' button will make the text slightly less bigger. Clicking on 'paragraph' will remove the formatting.")+ ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate inside the text") + ("</li><li>") +
          qsTr("Shift + Arrows: select a part of the text") + ("</li><li>") +
          qsTr("Ctrl + A: select all the text") + ("</li><li>") +
          qsTr("Ctrl + C: copy selected text") + ("</li><li>") +
          qsTr("Ctrl + X: cut selected text") + ("</li><li>") +
          qsTr("Ctrl + V: paste copied or cut text") + ("</li><li>") +
          qsTr("Ctrl + D: delete selected text") + ("</li><li>") +
          qsTr("Ctrl + Z: undo") + ("</li><li>") +
          qsTr("Ctrl + Shift + Z: redo") + ("</li></ul>")
  credit: ""
  section: "computer keyboard reading letters"
  createdInVersion: 6000
}
