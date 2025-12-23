/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "drawing_wheels/DrawingWheels.qml"
  difficulty: 1
  icon: "drawing_wheels/drawing_wheels.svg"
  author: "Bruno Anselme &lt;be.root@free.fr&gt;, Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Drawing wheels")
  //: Help title
  description: qsTr("Roll the gear in the cogwheel to draw.")
  //intro: "Roll the gear in the cogwheel to draw."
  //: Help goal
  goal: qsTr("Discover hypotrochoids and use them as digital painting tools.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Make beautiful drawings by rolling the gear in the cogwheel with the chosen pen. Select a wheel size, a gear size, pen's settings and color from the popup panels, and press the play button to roll the gear. You can use the file menu to save your image, open a previously saved image, or create a new image with selected background color. Saving an image will save it in an SVG file (vector format), along with a PNG file (pixel format). Only the SVG file can be opened again from the activity.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Ctrl + Z: undo last action") + ("</li><li>") +
          qsTr("Ctrl + Y: redo last action") + ("</li><li>") +
          qsTr("Ctrl + S: save the image") + ("</li><li>") +
          qsTr("Ctrl + O: open an image") + ("</li></ul>")
  credit: ""
  section: "discovery arts fun"
  createdInVersion: 260000
  // WARNING: if devicePixelRatio is not integer or .5 value (like 2.75), and software renderer is used, it will lead to incremental blur on the image...
  // So better disable the activity in case software renderer is used.
  enabled: !ApplicationInfo.useSoftwareRenderer
}
