/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (complete activity rewrite)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "gravity/Gravity.qml"
  difficulty: 3
  icon: "gravity/gravity.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Gravity")
  //: Help title
  description: qsTr("Introduction to the concept of gravity.")
  //intro: "Move the spaceship to avoid hitting the planets and reach the space station."
  //: Help goal
  goal: qsTr("Move the spaceship to avoid hitting the planets and reach the space station.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Move the spaceship with the left and right keys, or with the buttons on the screen for mobile devices. Try to stay near the center of the screen and anticipate by looking at the size and direction of the arrow showing the gravity force.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Left and Right arrows: move the spaceship") + ("</li></ul>")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 10000
}
