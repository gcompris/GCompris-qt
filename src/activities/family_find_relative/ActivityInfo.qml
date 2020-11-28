/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "family_find_relative/Family_find_relative.qml"
  difficulty: 2
  icon: "family_find_relative/family_find_relative.svg"
  author: "Rudra Nil Basu &lt;rudra.nil.basu.1996@gmail.com&gt;"
  //: Activity title
  title: qsTr("Point the relatives")
  //: Help title
  description: qsTr("Click on a pair corresponding to the given relation.")
  //intro: "Click on a pair that defines the given relation"
  //: Help goal
  goal: qsTr("Learn the relationships in a family, according to the lineal system used in most Western societies.")
  //: Help prerequisite
  prerequisite: qsTr("Reading, moving and clicking with the mouse.")
  //: Help manual
  manual: qsTr("A family tree is shown, with some instructions.\n" +
  "The circles are linked with lines to mark the relations. Married couples are marked with a ring on the link.\n" +
  "Click on a pair of family members which corresponds to the given relation.")
  credit: ""
  section: "sciences history"
  createdInVersion: 9000
}
