/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bharath M S <brat.197@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "algorithm/Algorithm.qml"
  difficulty: 2
  icon: "algorithm/algorithm.svg"
  author: "Bharath M S &lt;brat.197@gmail.com&gt;"
  //: Activity title
  title: qsTr("Logical associations")
  //: Help title
  description: qsTr("Complete the arrangement of fruit.")
//  intro: "Click on the missing items on the table and follow the logical sequence displayed above it."
  //: Help goal
  goal: qsTr("Logic training activity.")
  //: Help manual
  manual: qsTr("Look at the two sequences. Each fruit in the first sequence has been replaced by another fruit in the second sequence. Complete the second sequence by using the correct fruit, after studying this pattern.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: select an item") + ("</li></ul>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 0
}
