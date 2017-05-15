/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2014 JB Butet
 *
 * Authors:
 *   Matilda Bernard (seah4291@gmail.com) (GTK+ version)
 *   JB Butet <ashashiwa@gmail.com> (Qt Quick port)
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
  name: "place-your-satellite/PlaceYourSatellite.qml"
  difficulty: 4
  icon: "place-your-satellite/place-your-satellite.svg"
  author: "JB BUTET &lt;ashashiwa@gmail.com&gt;"
  demo: false
  title: qsTr("Place your satellite")
  description: qsTr("Understanding effect of mass and distance on orbital velocity.")
  goal: qsTr("Find good conditions for the satellite does not crash or fly away")
  prerequisite: ""
  manual: qsTr("A satellite revolves around the Earth because of the force between them. Orbital velocity of a satellite of Earth is directly proportional to the square root of the mass of Earth and inversely proportional to the square root of the distance from the center of Earth to the satellite.

In this activity, play with the speed of the satellite and mass of Earth to see what happens to the satellite. If the speed of the satellite is slower than the required orbital speed then the force applied by the Earth on the satellite is too much and thus the satellite gets pulled towards the Earth and burns in it's atmosphere. If the speed of the satellite is more than the required orbital speed then the Earth's force is not enough to keep it in orbit and thus the satellite flies away due to it's own inertia.")
  credit: ""
  section: "experiment physics"
  createdInVersion: 8000
}
