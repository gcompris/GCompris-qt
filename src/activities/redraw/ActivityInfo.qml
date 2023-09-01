/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "redraw/Redraw.qml"
  difficulty: 3
  icon: "redraw/redraw.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Redraw the given image")
  //: Help title
  description: qsTr("Draw perfectly the given image on the empty grid.")
  //intro: "Use the drawing tools to build an identical pattern on the right."
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
