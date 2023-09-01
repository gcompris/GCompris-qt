/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *    Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "solar_system/SolarSystem.qml"
  difficulty: 5
  icon: "solar_system/solar_system.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  //: Activity title
  title: qsTr("Solar system")
  //: Help title
  description: qsTr("Answer the questions with a correctness of 100%.")
  //intro: "Answer the questions presented and get a 100% correctness among the options."
  //: Help goal
  goal: qsTr("Learn information about the solar system. If you want to learn more about astronomy, try downloading KStars (https://edu.kde.org/kstars/) or Stellarium (https://stellarium.org/) which are astronomy Free Software.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click on a planet or on the Sun, and answer the corresponding questions. Each question contains 4 options. One of those is 100% correct. Try to answer the questions until you get 100% in the closeness meter.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: select") + ("</li><li>") +
          qsTr("Escape: return to previous screen") + ("</li><li>") +
          qsTr("Tab: view the hint (only when the hint icon is visible)") + ("</li></ul>")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 9500
}
