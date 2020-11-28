/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Rajdeep Kaur <rajdeep.kaur@kde.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "family/Family.qml"
  difficulty: 2
  icon: "family/family.svg"
  author: "Rajdeep Kaur &lt;rajdeep.kaur@kde.org&gt;"
  //: Activity title
  title: qsTr("Family")
  //: Help title
  description: qsTr("Select the name you should call this family member.")
  //intro: "Let us understand what to call our relatives"
  //: Help goal
  goal: qsTr("Learn the relationships in a family, according to the lineal system used in most Western societies.")
  //: Help prerequisite
  prerequisite: qsTr("Reading skills.")
  //: Help manual
  manual: qsTr("A family tree is shown.\n" +
  "The circles are linked with lines to mark the relations. Married couples are marked with a ring on the link.\n" +
  "You are the person in the white circle. Select the name you should call the person in the orange circle.\n")
  credit: ""
  section: "sciences history"
  createdInVersion: 9000
}
