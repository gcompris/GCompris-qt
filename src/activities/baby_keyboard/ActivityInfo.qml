/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "baby_keyboard/Baby_keyboard.qml"
  difficulty: 1
  icon: "baby_keyboard/baby_keyboard.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Baby keyboard")
  //: Help title
  description: qsTr("A simple activity to discover the keyboard.")
  //intro: "Type any key on the keyboard and observe the result."
  //: Help goal
  goal: qsTr("Discover the keyboard.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Type any key on the keyboard.
    Letters, numbers and other character keys will display the corresponding character on the screen.
    If there is a corresponding voice it will be played, else it will play a bleep sound.
    Other keys will just play a click sound.
    ")
  credit: ""
  section: "computer keyboard letters numeration"
  createdInVersion: 10000
}
