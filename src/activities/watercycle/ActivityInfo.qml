/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
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
  name: "watercycle/Watercycle.qml"
  difficulty: 1
  icon: "watercycle/watercycle.svg"
  author: "Sagar Chand Agarwal <atomsagar@gmail.com>"
  demo: true
  title: qsTr("Watercycle activity")
  description: qsTr("Tux is tired and is coming home.Help Tux to take bath by completing the water cycle.")
  goal: qsTr("Understand the different components that make up the water cycle.Click on different elements like sun,cloud,power station,wastewater and boat to see the progress")
  prerequisite:qsTr( "Nothing")
  manual: ""
  credit: ""
  section: "fun"
}
