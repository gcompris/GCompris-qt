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
  demo: true
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
          qsTr("<b>Keyboard Controls:</b><br><br>") +
          qsTr("1. Use arrow keys to move in the answer or sample zone.<br>") +
          qsTr("2. Use Enter or Return key to submit the answers.<br>") +
          qsTr("3. Use Space key to swap two wagons or locomotives in answer zone.<br>") +
          qsTr("4. Use Space key to add a wagon or locomotive from samples to answer list.<br>") +
          qsTr("5. Use Delete key to remove a wagon or locomotive from answer zone.<br>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 9500
}
