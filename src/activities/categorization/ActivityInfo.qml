/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "categorization/Categorization.qml"
  difficulty: 4
  icon: "categorization/categorization.svg"
  author: "Divyam Madaan &lt;divyam3897@gmail.com&gt;"
  //: Activity title
  title: qsTr("Categorization")
  //: Help title
  description: qsTr("Categorize the items into correct and incorrect groups.")
  //intro: "Categorize the items into the correct group"
  //: Help goal
  goal: qsTr("Build conceptual thinking and enrich knowledge.")
  //: Help prerequisite
  prerequisite: qsTr("Can drag items using a mouse or touchscreen.")
  //: Help manual
  manual: qsTr("Review the instructions and then drag and drop the items as specified.")
  credit: ""
  section: "reading vocabulary"
  createdInVersion: 8000
  levels: "1,2,3"
}
