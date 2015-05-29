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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "superbrain/Superbrain.qml"
  difficulty: 2
  icon: "superbrain/superbrain.svg"
  author: "Holger Kaelberer <holger.k@elberer.de>"
  demo: true
  title: qsTr("Super Brain")
  description: qsTr("Tux has hidden several items. Find them again in the correct order")
  //intro: "Find out the right combination of colors. A black pin means you found the correct colour in the correct position, a white pin means it's the correct colour but in the wrong position."
  goal: qsTr("Tux has hidden several items. Find them again in the correct order")
  prerequisite: ""
  manual: qsTr("Click on the items until you find what you think is the correct answer. Then, click on the OK button. In the lower levels, Tux gives you an indication if you found a hiding place by marking the item with a black box. You can use the right mouse button to flip the colors in the opposite order.")
  credit: ""
  section: "puzzle"
}
