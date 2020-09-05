/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *    Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "solar_system/SolarSystem.qml"
  difficulty: 5
  icon: "solar_system/solar_system.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  //: Activity title
  title: qsTr("Solar System")
  //: Help title
  description: qsTr("Answer the questions with a correctness of 100%.")
  //intro: "Answer the questions presented and get a 100% correctness among the options."
  //: Help goal
  goal: qsTr("Learn information about the solar system. If you want to learn more about astronomy, try downloading KStars (https://edu.kde.org/kstars/) or Stellarium (https://stellarium.org/) which are astronomy Free Software.")
  //: Help prerequisite
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
