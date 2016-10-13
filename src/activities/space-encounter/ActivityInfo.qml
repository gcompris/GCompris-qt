/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Varun Kumar <varun13169@iiitd.ac.in>
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
  name: "space-encounter/SpaceEncounter.qml"
  difficulty: 1
  icon: "space-encounter/space-encounter.svg"
  author: "Varun Kumar &lt;varun13169@iiitd.ac.in&gt;"
  demo: true
  title: qsTr("Space enCounter")
  description: ""
  //intro: "put here in comment the text for the intro voice"
  goal: qsTr("Press space bar as many times as possible in 10 seconds")
  prerequisite: qsTr("A little story about asteroid collision, that can be prevented by making a High Score")
  manual: qsTr("Press space bar to start the game, as soon as it is pressed for the first time a counter starts and player has to press space bar as many times as possible in 10 seconds.")
  credit: ""
  section: qsTr("fun")
  createdInVersion: 6000
}
