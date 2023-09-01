/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "scalesboard/ScaleNumber.qml"
  difficulty: 2
  icon: "scalesboard/scalesboard.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Balance the scales properly")
  //: Help title
  description: qsTr("Drag and Drop some weights to balance the scales.")
//  intro: "Drag the weights up to balance the scales."
  //: Help goal
  goal: qsTr("Mental calculation, arithmetic equality.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("To balance the scales, move some weights to the left or the right side (on higher levels). The weights can be arranged in any order.")
  credit:""
  section: "math measures"
  createdInVersion: 0
  levels: "1,2,3,4,5,6,7,8"
}
