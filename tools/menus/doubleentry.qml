/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Your Name <yy@zz.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "doubleentry/Doubleentry.qml"
  difficulty: 2
  icon: "doubleentry/doubleentry.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  title: qsTr("Double-entry table")
  description: qsTr("Drag and Drop the items in the double-entry table")
  goal: qsTr("Move the items on the left to their proper position in the double-entry table.")
  prerequisite: qsTr("Basic counting skills")
  manual: qsTr("Drag and Drop each proposed item on its destination")
  credit: ""
  section: "/discovery/miscellaneous"
}
