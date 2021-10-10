/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "baby_mouse/Baby_mouse.qml"
  difficulty: 1
  icon: "baby_mouse/baby_mouse.svg"
  author: "Mariam Fahmy &lt;mariamfahmy66@gmail.com&gt;"
  //: Activity title
  title: qsTr("Baby mouse")
  //: Help title
  description: qsTr("Move the mouse or touch the screen and observe the result.")
  //intro: "Move the mouse or touch the screen and observe the result."
  //: Help goal
  goal: qsTr("Provide audio-visual feedback when using the mouse to help discovering its usage for young children.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("The screen has 3 sections:") + ("<ul><li>") +
          qsTr("The leftmost column contains 4 ducks, clicking on one of them produces a sound and an animation.") + ("</li><li>") +
          qsTr("The central area contains a blue duck, moving the mouse cursor or doing a drag gesture on a touchscreen makes the blue duck move.") + ("</li><li>") +
          qsTr("The arrows area, clicking on one of them makes the blue duck move in the corresponding direction.") + ("</li></ul>") +
          qsTr("Doing a simple click in the central area shows a marker at the click position.")
  credit: ""
  section: "computer mouse"
  createdInVersion: 20000
}
