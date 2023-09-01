/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "nine_men_morris_2players/NineMenMorris2players.qml"
  difficulty: 2
  icon: "nine_men_morris_2players/nine_men_morris_2players.svg"
  author: "Pulkit Gupta &lt;pulkitnsit@gmail.com&gt;"
  //: Activity title
  title: qsTr("Nine men's morris (with a friend)")
  description: ""
  //intro: "Click on the dot where you wish to place your piece and try to take all your friend's pieces."
  //: Help goal
  goal: qsTr("Form mills (lines of 3 pieces) to remove your opponent's pieces until your opponent has only 2 pieces left or can not move anymore.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Play with a friend. First take turns to place nine pieces, and then take turns to move your pieces.")
  credit: ""
  section: "strategy"
  createdInVersion: 7000 
}
