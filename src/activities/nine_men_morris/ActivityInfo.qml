/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
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
  description: ""
  //intro: "Click on the dot where you wish to place your piece and try to take all Tux's pieces."
  //: Help goal
  goal: qsTr("Form mills (lines of 3 pieces) to remove Tux's pieces until he has only 2 pieces left or can not move anymore.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Play with the computer. First take turns to place nine pieces, and then take turns to move your pieces.")
  credit: ""
  section: "strategy"
  createdInVersion: 7000 
}
