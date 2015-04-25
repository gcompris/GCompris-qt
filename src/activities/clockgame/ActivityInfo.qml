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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "clockgame/Clockgame.qml"
  difficulty: 2
  icon: "clockgame/clockgame.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: true
  title: qsTr("Learning Clock")
  description: qsTr("Learn how to tell the time on an analog clock")
//  intro: "Use the mouse to drag and drop the needles of the clock and display the required time"
  goal: qsTr("Distinguish between time-units (hour, minute and second). Set and display time on an analog clock.")
  prerequisite: qsTr("The concept of time.")
  manual: qsTr("Set the clock to the given time, in the time-units shown (hours:minutes or hours:minutes:seconds). Drag the different arrows, to make the respective time unit go up or down.")
  credit: ""
  section: "discovery"
}
