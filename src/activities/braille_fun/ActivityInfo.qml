/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Arkit Vora <arkitvora123@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "braille_fun/BrailleFun.qml"
  difficulty: 6
  icon: "braille_fun/braille_fun.svg"
  author: "Arkit Vora &lt;arkitvora123@gmail.com&gt;"
  //: Activity title
  title: qsTr("Braille fun")
  //: Help title
  description: qsTr("Practice braille letters.")
  //intro: "Create the Braille cell for the letter."
  goal: ""
  //: Help prerequisite
  prerequisite: qsTr("Braille alphabet.")
  //: Help manual
  manual: qsTr("Create the braille cells for the letters on the banner. Check the braille chart by clicking on the blue braille cell icon if you need some help.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Space: open or close the braille chart") + ("</li></ul>")
  credit: ""
  section: "reading braille letters"
  createdInVersion: 4000
}
