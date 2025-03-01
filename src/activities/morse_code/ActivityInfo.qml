/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 SOURADEEP BARUA <sourad97@gmail.com>
 *
 * Authors:
 *   SOURADEEP BARUA <sourad97@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "morse_code/MorseCode.qml"
  difficulty: 3
  icon: "morse_code/morse_code.svg"
  author: "Souradeep Barua &lt;sourad97@gmail.com&gt;, Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Discover the International Morse code")
  //: Help title
  description: qsTr("Communicate with the International Morse code.")
  //intro: "Learn and practice the International Morse code"
  //: Help goal
  goal: qsTr("Learn how to send and receive messages using the International Morse code.")
  //: Help prerequisite
  prerequisite: qsTr("Knowledge of alphabets and digits.")
  //: Help manual
  manual: qsTr("You are either asked to send a message in Morse code or convert the received Morse code message to letters or digits. To learn Morse code, you can click on the Morse key icon to have a look at the translation map which contains the code for all the letters and digits.")
  credit: ""
  section: "reading letters"
  createdInVersion: 30000
  levels: ["1", "2", "3"]
}
