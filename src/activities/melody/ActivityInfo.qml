/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "melody/Melody.qml"
  difficulty: 2
  icon: "melody/melody.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Melody")
  //: Help title
  description: qsTr("Reproduce a sound sequence.")
// intro: "Listen to the sound sequence played, and reproduce it by clicking on the xylophone's bars"
  //: Help goal
  goal: qsTr("Ear-training activity.")
  //: Help prerequisite
  prerequisite: qsTr("Move and click the mouse.")
  //: Help manual
  manual: qsTr("Listen to the sound sequence played, and repeat it by clicking on the xylophone's bars. You can listen again the sound sequence by clicking on the repeat button.")
  credit: ""
  section: "discovery memory music"
  createdInVersion: 5000
}
