/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Stephane Mankowski <stephane@mankowski.fr>
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
  name: "color_mix_light/ColorMixLight.qml"
  difficulty: 4
  icon: "color_mix_light/colormixlight.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: true
  title: qsTr("Mixing colors of light")
  description: qsTr("Discover light color mixing.")
//  intro: "Match the colour by moving the sliders on the torches"
  goal: qsTr("Mix the primary colors to match to the given color.")
  prerequisite: ""
  manual: qsTr("
The activity deals with mixing primary colors of light (additive mixing).

In case of light it is just the opposite of mixing color with paints! The more light you add the lighter the resultant color will get. Primary colors of light are red, green and blue.
        ")
  credit: "http://openclipart.org"
  section: "experiment color"
}
