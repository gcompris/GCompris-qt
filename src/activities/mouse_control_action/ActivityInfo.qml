/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "mouse_control_action/Mouse_control_action.qml"
  difficulty: 1
  icon: "mouse_control_action/mouse_control_action.svg"
  author: "Mariam Fahmy &lt;mariamfahmy66@gmail.com&gt;"
  //: Activity title
  title: qsTr("Move the mouse or touch the screen")
  //: Help title
  description: qsTr("Move the mouse or touch the screen and observe the result.")
  //intro: "Move the mouse or touch the screen and observe the result."
  //: Help goal
  goal: qsTr("Providing audio-visual feedback when using the mouse to help in discovering its usage for a young kid.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("The screen has 3 sections:") + ("<br><br>") +
          qsTr("the leftmost column contains 4 ducks, clicking on one of them produces a sound and an animation.") + ("<br><br>") +
          qsTr("the central area contains a blue duck, moving the mouse cursor or doing a drag gesture on a touchscreen makes the blue duck move.") + ("<br><br>") +
          qsTr("the arrows area, clicking on one of them makes the blue duck move in the corresponding direction.") + ("<br><br>") +
          qsTr("Doing a simple click in the central area shows a marker at the click position.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 20000
}
