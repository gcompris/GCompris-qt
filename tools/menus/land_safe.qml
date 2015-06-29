/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "land_safe/LandSafe.qml"
  difficulty: 4
  icon: "land_safe/land_safe.svg"
  author: "Matilda Bernard &lt;serah4291@gmail.com&gt;"
  demo: true
  title: qsTr("Land Safe")
  description: qsTr("Understanding acceleration due to gravity.")
  goal: qsTr("Pilot the spaceship towards the green landing area.")
  prerequisite: ""
  manual: qsTr("
Acceleration due to gravity experienced by the spaceship is directly proportional to the mass of the planet and inversely proportional to the square of the distance from the center of the planet. Thus, with every planet the acceleration will differ and as the spaceship comes closer and closer to the planet the acceleration increases.

Use the up/down keys to control the thrust and the right/left keys to control direction.

The landing platform is green if your speed is fine for a safe landing.
        ")
  credit: ""
  section: "/experience"
}
