/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "mining/Mining.qml"
  difficulty: 1
  icon: "mining/mining.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Mining for gold")
  //: Help title
  description: qsTr("Use the mousewheel to approach the rockwall and look for gold nuggets.")
  //intro: "Looking at the rockwall, you can see a sparkle somewhere. Move the mouse cursor next to this sparkle and use the mousewheel or the zoom gesture to zoom in."
  //: Help goal
  goal: qsTr("Learn to use the mousewheel or the zoom / pinch gesture to zoom in and out.")
  //: Help prerequisite
  prerequisite: qsTr("You should be familiar with moving the mouse and clicking.")
  //: Help manual
  manual: qsTr("Looking at the rockwall, you can see a sparkle somewhere. Move next to this sparkle and use the mousewheel or the zoom gesture to zoom in. When you reach the maximum zoom level, a gold nugget will appear at the position of the sparkle. Click on the gold nugget to collect it.") + ("<br><br>") +
          qsTr("After collecting the nugget, use the mousewheel or the pinch gesture to zoom out again. When you reach the minimum zoom level, another sparkle will appear, showing the next gold nugget to collect. Collect enough nuggets to complete the level.") + ("<br><br>") +
          qsTr("The wagon in the lower right corner of the screen will tell you the number of already collected nuggets and the total number of nuggets to collect in this level.")
  credit: qsTr("Thanks to the Tuxpaint team for providing the following sounds under GPL:") + ("<ul><li>") +
          qsTr("realrainbow.ogg - used when a new gold nugget appears") + ("</li><li>") +
          qsTr("metalpaint.wav - remixed and used when a gold nugget is collected") + ("</li></ul>")
  section: "computer mouse"
  createdInVersion: 0
}
