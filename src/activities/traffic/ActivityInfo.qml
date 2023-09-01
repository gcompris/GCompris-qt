/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "traffic/Traffic.qml"
  difficulty: 2
  icon: "traffic/traffic.svg"
  author: "Holger Kaelberer &lt;holger.k@elberer.de&gt;"
  //: Activity title
  title: qsTr("A sliding-block puzzle game")
  //: Help title
  description: qsTr("Remove the red car from the parking lot through the gate on the right.")
//  intro: "Slide the cars to make a space so that the red car can go out of the box."
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("Each car can only move either horizontally or vertically. You must make some room in order to let the red car move through the gate on the right.")
  credit: ("<ul><li>") +
          ('"Car Start Engine" by henrique85n, (https://freesound.org/people/henrique85n/sounds/160442/), CC BY 3.0, extract') + ("</li></ul>")
  section: "discovery logic"
  createdInVersion: 0
}
