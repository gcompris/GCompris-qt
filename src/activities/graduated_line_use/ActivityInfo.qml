/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "graduated_line_use/GraduatedLineUse.qml"
  difficulty: 1
  icon: "graduated_line_use/graduated_line_use.svg"
  author: "Bruno ANSELME &lt;be.root@free.fr&gt;"
  //: Activity title
  title: qsTr("Use a graduated line")
  //: Help title
  description: qsTr("Place values on a graduated line.")
  //intro: "Place the given value on the graduated line."
  //: Help goal
  goal: qsTr("Learn to use a graduated line.")
  //: Help prerequisite
  prerequisite: qsTr("Reading and ordering numbers.")
  //: Help manual
  manual: qsTr("Use the arrows to move the cursor to the position corresponding to the given value on the graduated line.") + ("<br>") +
          qsTr("<b>Keyboard controls:</b>") + "<ul>" +
          "<li>" +qsTr("Left and Right arrows: move the cursor") + "</li>" +
          "<li>" +qsTr("Space, Return or Enter: validate your answer") + "</li>" +
          ("</ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 40000
  levels: ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
}
