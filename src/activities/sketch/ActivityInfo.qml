/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Toncu Stefan <stefan.toncu29@gmail.com>
 * SPDX-FileCopyrightText: 2018 Amit Sagtani <asagtani06@gmail.com>
 * SPDX-FileCopyrightText: 2019-2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0

ActivityInfo {
  name: "sketch/Sketch.qml"
  difficulty: 1
  icon: "sketch/sketch.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;, Amit Sagtani &lt;asagtani06@gmail.com&gt;, Stefan Toncu &lt;stefan.toncu29@gmail.com&gt;"
  title: qsTr("Sketch")
  description: qsTr("Use the various tools to draw images.")
  //intro: "Use the tools to draw images."
  goal: qsTr("Learn about basic drawing tools.")
  prerequisite: ""
  manual: qsTr("Select tools and colors from the foldable panels and draw images.<br><br>") +
          qsTr("<b>Keyboard Controls:</b><br>") +
          qsTr("1. Use Ctrl + Z to undo last changes.<br>") +
          qsTr("2. Use Ctrl + Y to redo last changes.<br>") +
          qsTr("3. Use Ctrl + N to erase the drawing.<br>") +
          qsTr("4. Use Ctrl + S to save the drawing.<br>") +
          qsTr("5. Use Ctrl + O to load saved drawings.<br>")
  credit: ""
  section: "discovery arts"
  createdInVersion: 250000
  enabled: true // TODO disable if software rendering is used!
}
