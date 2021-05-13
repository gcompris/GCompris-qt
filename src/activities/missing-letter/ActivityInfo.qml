/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Amit Tomar <a.tomar@outlook.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo
{
  name: "missing-letter/MissingLetter.qml"
  difficulty: 2
  icon: "missing-letter/missing-letter.svg"
  author: "Amit Tomar &lt;a.tomar@outlook.com&gt;"
  //: Activity title
  title: qsTr("Missing letter")
  //: Help title
  description: qsTr("Find the missing letter to complete the word.")
//  intro: "Find the missing letter and complete the word by clicking on one of the letters proposed on the side."
  //: Help goal
  goal: qsTr("Training reading skills.")
  //: Help prerequisite
  prerequisite: qsTr("Word reading.")
  //: Help manual
  manual: qsTr("A picture is displayed in the main area, and an incomplete word is written under the picture. Click on the missing letter to complete the word, or type the letter on your keyboard.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Tab: repeat the word") + ("</li></ul>")
  credit: ""
  section: "reading words"
  createdInVersion: 0
}
