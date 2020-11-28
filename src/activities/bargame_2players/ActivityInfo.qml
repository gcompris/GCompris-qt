/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2017 UTKARSH TIWARI <iamutkarshtiwari@kde.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "bargame_2players/Bargame2players.qml"
  difficulty: 2
  icon: "bargame_2players/bargame_2players.svg"
  author: "Utkarsh Tiwari &lt;iamutkarshtiwari@kde.org&gt;"
  //: Activity title
  title: qsTr("Bargame (with a friend)")
  //: Help title
  description: qsTr("Select the number of balls you wish to place in the holes and then click on the OK button. The winner is the one who hasn't put a ball in the red hole.")
  // intro: "Select the number of balls you wish to place in the holes and then click on the OK button. The winner is the one who hasn't put a ball in the red hole."
  //: Help goal
  goal: qsTr("Don't put the ball in the last hole.")
  //: Help prerequisite
  prerequisite: qsTr("Ability to count.")
  //: Help manual
  manual: qsTr("Click on the ball icon to select a number of balls, then click on the OK button to place the balls in the holes. You win if your friend has to place the last ball.")
  credit: ""
  section: "strategy"
  createdInVersion: 8000
}
