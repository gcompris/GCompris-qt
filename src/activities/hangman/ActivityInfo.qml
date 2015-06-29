/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Rajdeep Kaur <rajdeep1994@gmail.com>
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
  name: "hangman/Hangman.qml"
  difficulty: 3
  icon: "hangman/hangman.svg"
  author: "Rajdeep kaur &lt;rajdeep1994@gmail.com&gt;"
  demo: true
  title: qsTr("Hangman")
  description: qsTr("John wants to give a magical flower to marry that appears only if you guess the correct word. Help John by guess the word letter by letter")
  goal: qsTr("To enrich vocabulary")
  prerequisite: ""
  manual: qsTr("Guess the word letter by letter")
  credit: ""
  section: "computer keyboard reading"
}
