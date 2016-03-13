/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Komal Parmaar <parmaark@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "jumbled_words/Jumbled_words.qml"
  difficulty: 1
  icon: "jumbled_words/jumbled_words.svg"
  author: "Komal Parmaar &lt;parmaark@gmail.com&gt;"
  demo: false
  title: qsTr("Jumbled letters")
  description: qsTr("A set of jumbled letters is presented. Guess the correct word forming
  from the jumbled letters and write it in the Input Box. ")
  //intro: "put here in comment the text for the intro voice"
  goal: qsTr("Identify the correct word and its spelling from the jumbled set of letters provided.")
  prerequisite: qsTr("None")
  manual: qsTr("Type the word. Click on the Submit button to check whether the word
  and its spelling is correct or not. You can use the Hint option to get a visual hint for the word.")
  credit: ""
  section: "reading"
  createdInVersion: 6000
}
