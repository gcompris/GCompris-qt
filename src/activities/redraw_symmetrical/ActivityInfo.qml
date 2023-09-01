/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "redraw_symmetrical/RedrawSymmetrical.qml"
  difficulty: 4
  icon: "redraw_symmetrical/redraw_symmetrical.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Mirror the given image")
  //: Help title
  description: qsTr("Draw the image on the empty grid as if you saw it in a mirror.")
  //intro: "Use the drawing tools to reproduce symmetrically the pattern on the right."
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("First, select the proper color from the toolbar. Click on the grid and drag to paint, then release the click to stop painting.")
          + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Digits: select a color") + ("</li><li>") +
          qsTr("Arrows: navigate in the grid") + ("</li><li>") +
          qsTr("Space or Enter: paint") + ("</li></ul>")
  credit: ""
  section: "puzzle"
  createdInVersion: 0
  levels: "1,2,3"
}
