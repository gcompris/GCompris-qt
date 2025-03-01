/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "adjacent_numbers/Adjacent_numbers.qml"
  difficulty: 1
  icon: "adjacent_numbers/adjacent_numbers.svg"
  author: "Alexandre Laurent &lt;littlewhite.dev@gmail.com&gt;"
  //: Activity title
  title: qsTr("Find the adjacent numbers")
  //: Help title
  description: qsTr("Find the missing adjacent numbers.")
  //intro: "Find the missing numbers."
  //: Help goal
  goal: qsTr("Learn to order numbers.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Find the requested numbers and drag them to the corresponding spot.")
  credit: ""
  section: "math numeration"
  createdInVersion: 40000
  levels: ["1", "2", "3", "4", "5"]
}
