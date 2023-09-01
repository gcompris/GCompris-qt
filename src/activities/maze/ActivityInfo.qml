/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Stephane Mankowski <stephane@mankowski.fr>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "maze/Maze.qml"
  difficulty: 1
  icon: "maze/maze.svg"
  author: "Stephane Mankowski &lt;stephane@mankowski.fr&gt;"
  //: Activity title
  title: qsTr("Maze")
  //: Help title
  description: qsTr("Help Tux get out of this maze.")
//  intro: "Use the arrows keys or swipe the touch screen to help Tux find his way out."
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("Use the arrow keys or swipe the screen to move Tux to the door.") + "<br><br>" +
          qsTr("In first levels, Tux walks comfortably, one step on each move request, through the maze.") + "<br><br>" +
          qsTr("For larger mazes, there is a special walking mode, called \"run-fast-mode\". If this run-fast-mode is enabled, Tux will run all the way automatically until he reaches a fork and you have to decide which way to go further.")  + "<br><br>" +
          qsTr("You can see whether this mode is enabled or not, by looking at Tux's feet: If Tux is barefoot, \"run-fast-mode\" is disabled. And if he wears red sport shoes, \"run-fast-mode\" is enabled.") + "<br><br>" +
          qsTr("At higher levels, run-fast-mode will be enabled automatically. If you want to use this feature in earlier levels or want to disable it in advanced levels, click on the \"barefoot / sportshoe\" icon in the upper left corner of the screen to toggle the run-fast-mode.\t") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li></ul>")
  credit: ""
  section: "fun maze"
  createdInVersion: 0
}
