/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "path_encoding_relative/PathEncodingRelative.qml"
  difficulty: 1
  icon: "path_encoding_relative/path_encoding_relative.svg"
  author: "Harsh Kumar &lt;hadron43@yahoo.com&gt;"
  //: Activity title
  title: qsTr("Path encoding relative")
  //: Help title
  description: qsTr("Move Tux along the path to reach the target.")
  //intro: "Use the arrows to move Tux along the path and reach the target."
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("Use the arrow buttons to move Tux along the path until he reaches the target.") + "<br><br>" +
          qsTr("The directions are relative to the current orientation of Tux.") + "<br><br>" +
          qsTr("This means that UP moves forward, DOWN moves backward, LEFT moves to the left side of Tux and RIGHT moves to the right side of Tux.") + "<br><br>" +
          "<b>" + qsTr("Keyboard controls:") + "</b>" + ("<ul><li>") +
          qsTr("Arrows: directions") + ("</li></ul>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 20000
  levels: "1,2,3,4"
}
