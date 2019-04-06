/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "mining/Mining.qml"
  difficulty: 1
  icon: "mining/mining.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
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
  manual: qsTr("Looking at the rockwall, you can see a sparkle somewhere. Move next to this sparkle and use the mousewheel or the zoom gesture to zoom in. If you zoomed in at maximum, a gold nugget will appear at the position of the sparkle. Click on the gold nugget to collect it.

Having collected the nugget, use the mousewheel or the pinch gesture to zoom out again. If you zoomed out at maximum, another sparkle will appear, showing the next gold nugget to collect. Collect enough nuggets to complete the level.

The truck in the lower, right corner of the screen will tell you the number of already collected nuggets and the total number of nuggets to collect in this level.")
  credit: qsTr("Thanks to the Tuxpaint team for providing the following sounds under GPL:
- realrainbow.ogg - used when a new gold nugget appears
- metalpaint.wav - remixed and used when a gold nugget is collected")
  section: "computer mouse"
  createdInVersion: 0
}
