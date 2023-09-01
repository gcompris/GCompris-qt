/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Rajdeep Kaur <rajdeep1994@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "hangman/Hangman.qml"
  difficulty: 5
  icon: "hangman/hangman.svg"
  author: "Rajdeep kaur &lt;rajdeep1994@gmail.com&gt;"
  //: Activity title
  title: qsTr("The classic hangman game")
  //: Help title
  description: qsTr("Guess the letters of the given word.")
  //: Help goal
  goal: qsTr("This is a good exercise to improve reading and spelling skills.")
  prerequisite: ""
  // intro: "A word is hidden, you must discover it letter by letter."
  //: Help manual
  manual: qsTr("You can enter the letters using the virtual keyboard on the screen or with the real keyboard.") + ("<br><br>") +
          qsTr("If the option 'Display the image to find as hint' is activated, on every wrong try a part of the image representing the word will be revealed.") + ("<br><br>") +
          qsTr("If the option 'Speak the words to find...' is activated, and if the corresponding voice is available, you will hear the word to find when three attempts are remaining.")
  credit: ""
  section: "keyboard reading words"
  createdInVersion: 5000
}
