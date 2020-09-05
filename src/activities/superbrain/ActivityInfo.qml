/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
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
  name: "superbrain/Superbrain.qml"
  difficulty: 2
  icon: "superbrain/superbrain.svg"
  author: "Holger Kaelberer &lt;holger.k@elberer.de&gt;"
  //: Activity title
  title: qsTr("Super Brain")
  //: Help title
  description: qsTr("Tux has hidden several items. Find them in the correct order.")
  //intro: "Find out the right combination of colors. A dot framed in a black square means that you found the correct colour in the correct position, while a dot framed in a white square means it's the correct colour, but in the wrong position."
  //: Help goal
  goal: qsTr("Tux has hidden several items. Find them in the correct order.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click on the items until you find what you think is the correct answer. Then, click on the OK button. A black dot means that you found the correct item in the correct position, while a white dot means an item is correct but in the wrong position. At lower levels, Tux also gives you an indication with a black square on correct items in the correct position, and a white square on the correct items in the wrong position. In the levels 4 and 8 an item may be hidden several times.<br/>You can use the right mouse button to flip the items in the opposite order, or the item chooser to directly pick an item from the list. Press two seconds on an item to automatically choose the last item selected in this position. Double click on a previously selected item in your guess history to mark it as 'correct'. Such marked items are automatically selected in your current and future guesses until you un-mark them, by double clicking on them again.")
  credit: ""
  section: "discovery logic"
  createdInVersion: 4000
}
