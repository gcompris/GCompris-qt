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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "color_mix/ColorMix.qml"
  difficulty: 4
  icon: "color_mix/color_mix.svg"
  author: "Stephane Mankowski &lt;stephane@mankowski.fr&gt;"
  //: Activity title
  title: qsTr("Mixing paint colors")
  //: Help title
  description: qsTr("Discover paint color mixing.")
//  intro: "Match the colour by moving the sliders on the tubes of paint"
  //: Help goal
  goal: qsTr("Mix primary colors to match the given color.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("This activity teaches how mixing primary paint colors works (subtractive mixing).") + ("<br><br>") +
          qsTr("Paints and inks absorb different colors of the light falling on it, subtracting it from what you see. The more ink you add, the more light is absorbed, and the darker the resulting color becomes. We can mix just three primary colors to make many new colors. The primary colors for paint/ink are cyan (a special shade of blue), magenta (a special shade of pink), and yellow.")
  credit: ""
  section: "sciences experiment color"
  createdInVersion: 0
}
