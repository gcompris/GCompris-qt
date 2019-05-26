/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Siddhesh suthar<siddhesh.it@gmail.com>
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
  name: "intro_gravity/IntroGravity.qml"
  difficulty: 4
  icon: "intro_gravity/intro_gravity.svg"
  author: "Siddhesh suthar &lt;siddhesh.it@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Intro gravity")
  //: Help title
  description: qsTr("Introduction to the concept of gravity")
  //intro: "Change the planets' gravitational force by moving the sliders up and down. Be careful not to crash Tux's spaceship."
  //: Help goal
  goal: qsTr("Maintain the spaceship in the middle without crashing into the planets or the asteroids")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Follow the instructions when you run the activity.")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 4000
}
