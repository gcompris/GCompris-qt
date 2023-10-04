/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "guess24/Guess24.qml"
  difficulty: 4
  icon: "guess24/guess24.svg"
  author: "Bruno ANSELME &lt;be.root@free.fr&gt;"
  //: Activity title
  title: qsTr("Guess 24")
  //: Help title
  description: qsTr( "Calculate to find 24.")
//  intro: "Use the four numbers with given operators to find 24"
  //: Help goal
  goal: qsTr("Learn to calculate using the four operators.")
  //: Help prerequisite
  prerequisite: qsTr("Being able to calculate using additions, subtractions, multiplications and divisions.")
  //: Help manual
  manual: qsTr("Use the four numbers with given operators to find 24.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + "<ul>" +
          "<li>" +qsTr("Arrows: navigate inside numbers and operators") + "</li>" +
          "<li>" +qsTr("Space, Return or Enter: select or deselect current value or operator") + "</li>" +
          "<li>" +qsTr("Operator keys (+, -, *, /): select operator") + "</li>" +
          "<li>" +qsTr("Backspace or Delete: cancel last operation") + "</li>" +
          "<li>" +qsTr("Tabulation: switch between numbers and operators") + "</li>" +
          ("</ul>")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 40000
  levels: "1,2,3,4,5"
}
