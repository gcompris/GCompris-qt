/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Stephane Mankowski <stephane@mankowski.fr>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "lightsoff/Lightsoff.qml"
  difficulty: 6
  icon: "lightsoff/lightsoff.svg"
  author: "Stephane Mankowski &lt;stephane@mankowski.fr&gt;"
  //: Activity title
  title: qsTr("Lights off")
  //: Help title
  description: qsTr("The goal is to turn off all the lights.")
//  intro: "Click on the lamps to turn them off."
  //: Help goal
  goal: qsTr("The goal is to turn off all the lights.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("The effect of pressing a window is to toggle the state of that window, and of its immediate vertical and horizontal neighbors. You must turn off all the lights. If you click on Tux, the solution is shown.")
  credit: qsTr("The solver algorithm is described on Wikipedia. To know more about the Lights Off game: &lt;https://en.wikipedia.org/wiki/Lights_Out_(game)&gt;")
  section: "discovery logic"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8,9"
}
