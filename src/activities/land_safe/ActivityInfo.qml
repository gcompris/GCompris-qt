/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Holger Kaelberer <holger.k@elberer.de>
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
  name: "land_safe/LandSafe.qml"
  difficulty: 4
  icon: "land_safe/land_safe.svg"
  author: "Matilda Bernard &lt;serah4291@gmail.com&gt; (Gtk+), Holger Kaelberer &lt;holger.k@elberer.de&gt; (Qt Quick)"
  demo: true
  //: Activity title
  title: qsTr("Land Safe")
  //: Help title
  description: qsTr("Understanding acceleration due to gravity.")
  // intro: "Use the arrow keys to pilot your spaceship safely onto the landing pad."
  //: Help goal
  goal: qsTr("Pilot the spaceship towards the green landing area.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Acceleration due to gravity experienced by the spaceship is directly proportional to the mass of the planet and inversely proportional to the square of the distance from the center of the planet. Thus, with every planet the acceleration will differ and as the spaceship comes closer and closer to the planet the acceleration increases.

Use the up/down keys to control the thrust and the right/left keys to control direction. On touch screens you can control the rocket through the corresponding on-screen buttons.

The accelerometer on the right border shows your rocket's overall vertical acceleration including gravitational force. In the upper green area of the accelerometer your acceleration is higher than the gravitational force, in the lower red area it's lower, and on the blue baseline in the yellow middle area the two forces cancel each other out.

In higher levels, you can use the right/left keys to rotate the spaceship. By rotating the spaceship you can trigger an acceleration in non-vertical direction using the up/down keys.

The landing platform is green if your speed is fine for a safe landing.")
  credit: ""
  section: "sciences experiment"
  enabled: ApplicationInfo.isBox2DInstalled //ApplicationInfo.hasShader
  createdInVersion: 6000
}
