/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Your Name <yy@zz.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "braille_lotto/BrailleLotto.qml"
  difficulty: 6
  icon: "braille_lotto/braille_lotto.svg"
  author: "Srishti Sethi &lt;srishakatux@gmail.com&gt;"
  demo: true
  title: qsTr("Braille Lotto")
  description: qsTr("Discover the Braille system for numbers.")
  goal: ""
  prerequisite: ""
  manual: qsTr("Each player must find if the proposed number is in their board. If the code is in the board, just click on it in order to validate it. The player who crosses all the Braille numbers correctly wins the game. Check the Braille table by clicking on the toggle button in the control bar.")
  credit: ""
  section: "/discovery/braille"
}
