/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "path_encoding/PathEncoding.qml"
  difficulty: 1
  icon: "path_encoding/path_encoding.svg"
  author: "Harsh Kumar &lt;hadron43@yahoo.com&gt;"
  //: Activity title
  title: qsTr("Path encoding")
  //: Help title
  description: qsTr("Move Tux along the path to reach the target.")
  //intro: "Use the arrows to move Tux along the path and reach the target."
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("Use the arrow buttons to move Tux along the path until he reaches the target.") + "<br><br>" +
          qsTr("The directions are absolute, they do not depend on the current orientation of Tux.") + "<br><br>" +
          "<b>" + qsTr("Keyboard controls:") + "</b>" + ("<ul><li>") +
          qsTr("Arrows: directions") + ("</li></ul>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 20000
  levels: "1,2,3,4"
}
