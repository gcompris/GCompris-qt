/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Toncu Stefan <stefan.toncu29@gmail.com>
 * SPDX-FileCopyrightText: 2018 Amit Sagtani <asagtani06@gmail.com>
 * SPDX-FileCopyrightText: 2019-2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import core 1.0

ActivityInfo {
  name: "sketch/Sketch.qml"
  difficulty: 1
  icon: "sketch/sketch.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;, Amit Sagtani &lt;asagtani06@gmail.com&gt;, Stefan Toncu &lt;stefan.toncu29@gmail.com&gt;"
  //: Activity title
  title: qsTr("Sketch")
  //: Help title
  description: qsTr("Use the various digital painting tools to draw images.")
  //intro: "Use the tools to draw images."
  //: Help goal
  goal: qsTr("Learn about some digital painting tools.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Select tools and colors from the foldable panels and draw images.<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Ctrl + Z: undo last action") + ("</li><li>") +
          qsTr("Ctrl + Y: redo last action") + ("</li><li>") +
          qsTr("Ctrl + S: save the image") + ("</li><li>") +
          qsTr("Ctrl + O: open an image") + ("</li><li>") +
          qsTr("Ctrl + N, Delete or Backspace: create a new image") + ("</li></ul>")
  credit: qsTr("Brush smoothing concept from:") + " https://lazybrush.dulnan.net/ <br>" +
          qsTr("Sketch brush concept from:") + " https://mrdoob.com/projects/harmony/ "
  section: "discovery arts fun"
  createdInVersion: 250000
  // WARNING: if devicePixelRatio is not integer or .5 value (like 2.75), and software renderer is used, it will lead to incremental blur on the image...
  // So better disable the activity in case software renderer is used.
  enabled: !ApplicationInfo.useSoftwareRenderer
}
