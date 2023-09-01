/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "mosaic/Mosaic.qml"
  difficulty: 1
  icon: "mosaic/mosaic.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Rebuild the mosaic")
  //: Help title
  description: qsTr("Put each item at the same place as in the given example.")
//  intro: "Put each item at the same place as in the given example."
  goal: ""
  prerequisite: ""
  //: Help manual
  manual: qsTr("First select an item from the list, and then click on a spot of the mosaic to place the item.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate inside an area") + ("</li><li>") +
          qsTr("Space or Enter: select or place an item") + ("</li><li>") +
          qsTr("Tab: navigate between the item list and the mosaic") + ("</li></ul>")
  credit: ""
  section: "puzzle"
  createdInVersion: 0
  levels: "1,2,3,4"
}
