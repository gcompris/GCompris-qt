/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "graduated_line_read/GraduatedLineRead.qml"
  difficulty: 1
  icon: "graduated_line_read/graduated_line_read.svg"
  author: "Bruno ANSELME &lt;be.root@free.fr&gt;"
  //: Activity title
  title: qsTr("Read a graduated line")
  //: Help title
  description: qsTr("Read values on a graduated line.")
  //intro: "Find the value corresponding to the given spot on the graduated line."
  //: Help goal
  goal: qsTr("Learn to read a graduated line.")
  //: Help prerequisite
  prerequisite: qsTr("Reading and ordering numbers.")
  //: Help manual
  manual: qsTr("Use the number pad or your keyboard to enter the value corresponding to the given spot on the graduated line.") + ("<br>") +
          qsTr("<b>Keyboard controls:</b>") + "<ul>" +
          "<li>" +qsTr("Digits: enter digits") + "</li>" +
          "<li>" +qsTr("Backspace: delete the last digit") + "</li>" +
          "<li>" +qsTr("Delete: reset your answer") + "</li>" +
          "<li>" +qsTr("Space, Return or Enter: validate your answer") + "</li>" +
          ("</ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 40000
  levels: ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
}
