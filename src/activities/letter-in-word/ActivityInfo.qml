/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "letter-in-word/LetterInWord.qml"
  difficulty: 2
  icon: "letter-in-word/letter-in-word.svg"
  author: "Akshat Tandon &lt;akshat.tandon@research.iiit.ac.ins&gt;"
  demo: true
  //: Activity title
  title: qsTr("Letter in which word")
  //: Help title
  description: qsTr("A letter is written and/or spoken. Some words are displayed, the children must find the word or the words in which this letter appears.")
  //intro: "Click on all the words containing the wanted letter."
  //: Help goal
  goal: qsTr("Select all the words which contain the spoken letter.")
  //: Help prerequisite
  prerequisite: qsTr("spellings, letter recognition")
  //: Help manual
  manual: qsTr("A letter is displayed on the flag attached to the plane, select all the words or the objects in which the letter appears and then press OK.")
  credit: ""
  section: "reading words"
  createdInVersion: 7000
}
