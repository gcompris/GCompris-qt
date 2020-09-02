/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Stephane Mankowski <stephane@mankowski.fr>
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
  name: "clockgame/Clockgame.qml"
  difficulty: 2
  icon: "clockgame/clockgame.svg"
  author: "Stephane Mankowski &lt;stephane@mankowski.fr&gt;"
  //: Activity title
  title: qsTr("Learning Clock")
  //: Help title
  description: qsTr("Learn how to tell the time on an analog clock.")
//  intro: "Drag and drop the needles of the clock to display the required time"
  //: Help goal
  goal: qsTr("Learn units of time (hours, minutes and seconds). Set the time on an analog clock.")
  //: Help prerequisite
  prerequisite: qsTr("The concept of time.")
  //: Help manual
  manual: qsTr("Set the clock to the given time. Drag the different hands to control their respective unit.") + " " +
          qsTr("The shortest hand indicates the hours, a longer hand indicates the minutes, and the longest hand indicates the seconds.")
  credit: ""
  section: "math measures"
  createdInVersion: 0
  levels: "1,2,3,4,5,6"
}
