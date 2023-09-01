/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "instruments/Instruments.qml"
  difficulty: 4
  icon: "instruments/instruments.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Music instruments")
  //: Help title
  description: qsTr("Click on the correct musical instruments.")
//  intro: "Click on the correct musical instrument."
  //: Help goal
  goal: qsTr("Learn to recognize musical instruments.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click on the correct musical instrument.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: select an item") + ("</li><li>") +
          qsTr("Tab: repeat the instrument sound") + ("</li></ul>")
  credit: ""
  section: "discovery music"
  createdInVersion: 0
}
