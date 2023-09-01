/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2017 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
 * SPDX-FileCopyrightText: 2018 Amit Sagtani <asagtani06@gmail.com>
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
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
  description: qsTr("Rebuild the train model at the top of the screen.")
  //intro: "Observe the train and then click on the items to set up a similar train"
  //: Help goal
  goal: qsTr("Memory training.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("A train is displayed for a few seconds. Rebuild it at the top of the screen by dragging the appropriate items. Remove an item from the answer area by dragging it down.") + ("<br><br>") +
          qsTr("<b>Keyboard Controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate in the sample area and in the answer area") + ("</li><li>") +
          qsTr("Space: add an item from the samples to the answer area, or swap two items in the answer area") + ("</li><li>") +
          qsTr("Delete or Backspace: remove the selected item from the answer area") + ("</li><li>") +
          qsTr("Enter or Return: submit your answer") + ("</li></ul>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 9500
}
