/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "drawing_wheels/DrawingWheels.qml"
  difficulty: 1
  icon: "drawing_wheels/be.root.svg"
  author: "Bruno Anselme &lt;be.root@free.fr&gt;"
  //: Activity title
  title: qsTr("Drawing wheels")
  //: Help title
  description: ""
  //intro: "put here in comment the text for the intro voice"
  //: Help goal
  goal: qsTr("Make beautiful drawings by turning the gear in the cogwheel with the chosen pen.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Select wheel, gear, pen's position and color from the foldable panels and start the gear.<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Ctrl + Z: undo last action") + ("</li><li>") +
          qsTr("Ctrl + Y: redo last action") + ("</li><li>") +
          qsTr("Ctrl + S: save the image") + ("</li><li>") +
          qsTr("Ctrl + D: save the drawing") + ("</li><li>") +
          qsTr("Ctrl + O: open an image") + ("</li></ul>")
  credit: ""
  section: "discovery arts fun"
  createdInVersion: 260000
}
