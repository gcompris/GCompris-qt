/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "frieze/Frieze.qml"
  difficulty: 1
  icon: "frieze/frieze.svg"
  author: "Bruno ANSELME &lt;be.root@free.fr&gt;"
  //: Activity title
  title: qsTr("Frieze")
  //: Help title
  description: qsTr("Reproduce and complete the frieze.")
  //intro: "Reproduce and complete the frieze model."
  //: Help goal
  goal: qsTr("Learn algorithms.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Reproduce the frieze on top. On some levels, you may have to complete the frieze or to reproduce it after you've memorized it.") + ("<br>") +
          qsTr("<b>Keyboard controls:</b>") + "<ul>" +
          "<li>" +qsTr("Left and right arrows: select a token") + "</li>" +
          "<li>" +qsTr("Space: add selected token to the frieze") + "</li>" +
          "<li>" +qsTr("Backspace or Delete: remove last token from the frieze") + "</li>" +
          "<li>" +qsTr("Enter: validate the answer") + "</li>" +
          "<li>" +qsTr("Tab: switch between editing the frieze and viewing the model") + "</li>" +
          ("</ul>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 40000
  levels: "1,2,3,4,5,6,7,8,9,10,11,12,13,14"
}
