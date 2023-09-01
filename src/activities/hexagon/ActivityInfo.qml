/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "hexagon/Hexagon.qml"
  difficulty: 2
  icon: "hexagon/hexagon.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Hexagon")
  //: Help title
  description: qsTr("Find the strawberry by clicking on the blue fields.")
//  intro: "Click on the hexagons to find the hidden object, the red zone indicates that you're close to it!"
  //: Help goal
  goal: qsTr("Logic-training activity.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Try to find the strawberry under the blue fields. The fields become redder as you get closer.")
  credit: ""
  section: "fun"
  createdInVersion: 0
}
