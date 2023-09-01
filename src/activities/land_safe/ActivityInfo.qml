/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "land_safe/LandSafe.qml"
  difficulty: 4
  icon: "land_safe/land_safe.svg"
  author: "Matilda Bernard &lt;serah4291@gmail.com&gt; (Gtk+), Holger Kaelberer &lt;holger.k@elberer.de&gt; (Qt Quick)"
  //: Activity title
  title: qsTr("Land safe")
  //: Help title
  description: qsTr("Pilot the spaceship towards the green landing area.")
  // intro: "Use the arrow keys to pilot your spaceship safely onto the landing pad."
  //: Help goal
  goal: qsTr("Understand the acceleration caused by the gravity.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("The acceleration caused by the gravity experienced by the spaceship is directly proportional to the mass of the planet and inversely proportional to the square of the distance from the center of the planet. Thus, with every planet the acceleration will differ and as the spaceship comes closer and closer to the planet the acceleration increases.") + ("<br><br>") +
          qsTr("In first levels, use the up/down keys to control the thrust and the right/left keys to control the direction. On touch screens you can control the rocket through the corresponding on-screen buttons.") + ("<br><br>") +
          qsTr("In higher levels, you can use the right/left keys to rotate the spaceship. By rotating the spaceship you can trigger an acceleration in non-vertical direction using the up/down keys.") + ("<br><br>") +
          qsTr("The landing platform is green if your speed is fine for a safe landing.") + ("<br><br>") +
          qsTr("The accelerometer on the right border shows your rocket's overall vertical acceleration including gravitational force. In the upper green area of the accelerometer your acceleration is higher than the gravitational force, in the lower red area it's lower, and on the blue baseline in the yellow middle area the two forces cancel each other out.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Up and Down arrows: control the thrust of the rear engine") + ("</li><li>") +
          qsTr("Left and Right arrows: at first levels, move to the sides; at higher levels, rotate the spaceship") + ("</li></ul>")
  credit: ""
  section: "sciences experiment"
  enabled: ApplicationInfo.isBox2DInstalled //ApplicationInfo.hasShader
  createdInVersion: 6000
  levels: "1,2"
}
