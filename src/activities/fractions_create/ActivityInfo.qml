/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "fractions_create/FractionsCreate.qml"
  difficulty: 5
  icon: "fractions_create/fractions_create.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Create the fractions")
  //: Help title
  description: qsTr("A shape split in equal parts is displayed on screen.") +
    "<br>" +
    qsTr("Select the appropriate number of parts as described in the instructions.")
  //intro: "Select the appropriate number of parts as described in the instructions."
  goal: ""
  prerequisite: ""
  manual: ""
  credit: ""
  section: "math arithmetic"
  createdInVersion: 30000
  levels: "1,2,3,4,5,6,7,8,9,10"
}
