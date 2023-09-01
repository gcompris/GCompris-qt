/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "path_decoding/PathDecoding.qml"
  difficulty: 1
  icon: "path_decoding/path_decoding.svg"
  author: "Harsh Kumar &lt;hadron43@yahoo.com&gt;"
  //: Activity title
  title: qsTr("Path decoding")
  //: Help title
  description: qsTr("Follow the given directions to help Tux reach the target.")
  //intro: "Click on the grid squares following the given directions to help Tux reach the target."
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click on the grid squares to move Tux following the given directions.") + "<br><br>" +
          qsTr("The directions are absolute, they do not depend on the current orientation of Tux.")
  credit: ""
  section: "discovery logic"
  createdInVersion: 20000
  levels: "1,2,3,4"
}
