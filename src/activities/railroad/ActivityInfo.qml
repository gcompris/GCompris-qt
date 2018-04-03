/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
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
  name: "railroad/Railroad.qml"
  difficulty: 1
  icon: "railroad/railroad.svg"
  author: "Utkarsh Tiwari &lt;iamutkarshtiwari@kde.org&gt;"
  demo: true
  title: qsTr("Railroad activity")
  description: qsTr("Rebuild the displayed locomotive at the top of the screen by selecting the appropriate carriages and locomotive. Deselect an item by clicking on it again.")
  //intro: "Observe the train and then click on the items to set up a similar train"
  goal: qsTr("Memory training")
  prerequisite: ""
  manual: qsTr("A train - a locomotive and carriage(s) - is displayed at the top of the main area for a few seconds. Rebuild it at the top of the screen by selecting the appropriate carriages and locomotive. Deselect an item by clicking on it again.")
  credit: ""
  section: "discovery memory"
  createdInVersion: 8000
}
