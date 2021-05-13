/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Stephane Mankowski <stephane@mankowski.fr>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "clockgame/Clockgame.qml"
  difficulty: 2
  icon: "clockgame/clockgame.svg"
  author: "Stephane Mankowski &lt;stephane@mankowski.fr&gt;"
  //: Activity title
  title: qsTr("Learning clock")
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
