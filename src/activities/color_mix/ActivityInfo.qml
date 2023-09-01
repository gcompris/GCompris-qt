/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Stephane Mankowski <stephane@mankowski.fr>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
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
//  intro: "Match the color by moving the sliders on the tubes of paint"
  //: Help goal
  goal: qsTr("Mix primary colors to match the given color.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("This activity teaches how mixing primary paint colors works (subtractive mixing).") + ("<br><br>") +
          qsTr("Paints and inks absorb different colors of the light falling on it, subtracting it from what you see. The more ink you add, the more light is absorbed, and the darker the resulting color becomes. We can mix just three primary colors to make many new colors. The primary colors for paint/ink are cyan (a special shade of blue), magenta (a special shade of pink), and yellow.") + ("<br><br>") +
          qsTr("Change the color by moving the sliders on the tubes of paint or by clicking on the + and - buttons. Then click on the OK button to validate your answer.")
  credit: ""
  section: "sciences experiment color"
  createdInVersion: 0
}
