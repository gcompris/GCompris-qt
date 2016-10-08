/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 UTKARSH TIWARI <iamutkarshtiwari@kde.org>
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
  name: "bargame/Bargame.qml"
  difficulty: 1
  icon: "bargame/bargame.svg"
  author: "Utkarsh Tiwari &lt;iamutkarshtiwari@kde.org&gt;"
  demo: true
  title: qsTr("Bargame")
  description: ""
  //intro: "put here in comment the text for the intro voice"
  goal: qsTr("Don't use the last ball")
  prerequisite: qsTr("Brain")
  manual: qsTr("Place balls in the holes. You win if the computer has to place the last ball. If you want Tux to begin, just click on him")
  credit: ""
  section: "strategy"
  createdInVersion: 7000
}
