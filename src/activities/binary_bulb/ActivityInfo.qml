/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "binary_bulb/BinaryBulb.qml"
  difficulty: 3
  icon: "binary_bulb/binary_bulb.svg"
  author: "Rajat Asthana &lt;rajatasthana4@gmail.com&gt;"
  //: Activity title
  title: qsTr("Binary bulbs")
  //: Help title
  description: qsTr("This activity helps you to learn the concept of conversion from decimal number system to binary number system.")
  //intro: "Turn on the right bulbs to represent the binary of the given decimal number. When you have achieved it, press OK"
  //: Help goal
  goal: qsTr("To get familiar with the binary number system.")
  //: Help prerequisite
  prerequisite: qsTr("Decimal number system.")
  //: Help manual
  manual: qsTr("Turn on the right bulbs to represent the binary of the given decimal number. When you have achieved it, press OK.")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 9500
}
