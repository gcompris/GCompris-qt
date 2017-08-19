/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 JB BUTET <ashashiwa@gmail.com>
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
  name: "memory/Memory.qml"
  difficulty: 1
  icon: "memory/memory.svg"
  author: "JB BUTET &lt;ashashiwa@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Memory Game with images")
  //: Help title
  description: qsTr("Flip the cards to find the matching pairs")
//  intro: "Click on a card and find its double."
  //: Help goal
  goal: qsTr("Train your memory and remove all the cards")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("A set of blank cards is shown. Each card has a picture on the other side, and each picture card has a twin exactly the same. Click on a card to see its hidden picture, and try to match the twins. You can only turn over two cards at once, so you need to remember where a picture is, while you look for its twin. When you turn over the twins, they both disappear.")
  credit: ""
  section: "discovery memory"
}
