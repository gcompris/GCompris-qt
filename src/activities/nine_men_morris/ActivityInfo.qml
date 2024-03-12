/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "nine_men_morris/NineMenMorris.qml"
  difficulty: 2
  icon: "nine_men_morris/nine_men_morris.svg"
  author: "Pulkit Gupta &lt;pulkitnsit@gmail.com&gt;"
  //: Activity title
  title: qsTr("Nine men's morris (against Tux)")
  //: Help title
  description: qsTr("Play the game Nine men's morris against Tux.")
  //intro: "Click on the dot where you wish to place your piece and try to take all Tux's pieces."
  //: Help goal
  goal: qsTr("Develop strategic and spatial visualization skills.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Play with Tux. First take turns to place nine pieces, and then take turns to move your pieces. If you have only 3 pieces left, you can make them fly to any vacant spot. A player wins when the other player can't move any piece or has only 2 pieces left.") + ("<br>") +
    qsTr("You can use the arrow buttons to manually select the difficulty level. Tux will play better when you increase the level.")
  credit: ""
  section: "strategy"
  createdInVersion: 7000 
}
