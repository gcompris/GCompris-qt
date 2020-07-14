/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
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
  name: "railroad/Railroad.qml"
  difficulty: 1
  icon: "railroad/railroad.svg"
  author: "Utkarsh Tiwari &lt;iamutkarshtiwari@kde.org&gt;"
  //: Activity title
  title: qsTr("Railroad activity")
  //: Help title
  description: qsTr("Rebuild the displayed train at the top of the screen by dragging the appropriate carriages and locomotive. Deselect an item by dragging it down.")
  //intro: "Observe the train and then click on the items to set up a similar train"
  //: Help goal
  goal: qsTr("Memory training")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("A train - a locomotive and carriage(s) - is displayed at the top of the main area for a few seconds. Rebuild it at the top of the screen by dragging the appropriate carriages and locomotive. Deselect an item by dragging it down.<br><br>") +
          qsTr("<b>Keyboard Controls:</b><br>") +
          qsTr("-Arrows: navigate in the answer or sample area<br>") +
          qsTr("-Enter or Return: submit the answer<br>") +
          qsTr("-Space: add an item from the samples to the answer area, or swap two items in the answer area<br>") +
          qsTr("-Delete: remove a wagon or locomotive from the answer area")
  credit: ""
  section: "discovery logic"
  createdInVersion: 9500
}
