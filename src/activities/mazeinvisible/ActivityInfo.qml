/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Stephane Mankowski <stephane@mankowski.fr>
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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "mazeinvisible/Mazeinvisible.qml"
  difficulty: 4
  icon: "mazeinvisible/mazeinvisible.svg"
  author: "Stephane Mankowski &lt;stephane@mankowski.fr&gt;"
  demo: true
  //: Activity title
  title: qsTr("Invisible Maze")
  //: Help title
  description: qsTr("Guide Tux out of the invisible maze")
//  intro: "Use the arrow keys or swipe the touch screen to guide Tux out. Use the maze icon or the space key to see the map."
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Use the arrow keys or swipe the touch screen to move Tux up to the door. Use the maze icon or the spacebar to switch between invisible and visible modes. Visible mode just gives you an indication of your position, like a map. You cannot move Tux in visible mode.") + "<br><br>" +
          qsTr("At the first levels, Tux walks comfortably, one step on each move request, through the maze.") + "<br><br>" +
          qsTr("For larger mazes, there is a special walking mode, called \"run-fast-mode\". If this run-fast-mode is enabled, Tux will run all the way automatically until he reaches a fork and you have to decide which way to go further.")  + "<br><br>" +
          qsTr("You can see whether this mode is enabled or not, by looking at Tux's feet: If Tux is barefooted, \"run-fast-mode\" is disabled. And if he wears red sport shoes, \"run-fast-mode\" is enabled.") + "<br><br>" +
          qsTr("At higher levels, run-fast-mode will be enabled automatically. If you want to use this feature in earlier levels or want to disable it in advanced levels, click on the \"barefoot / sportshoe\"-icon in the upper left corner of the screen to toggle the run-fast-mode.
\t")
  credit: ""
  section: "discovery maze"
}
