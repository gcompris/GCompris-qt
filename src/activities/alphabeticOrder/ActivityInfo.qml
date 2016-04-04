/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Your Name <yy@zz.org>
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
  name: "alphabeticOrder/AlphabeticOrder.qml"
  difficulty: 1
  icon: "alphabeticOrder/alphabeticOrder.svg"
  author: "Anu Mittal &lt;anu22mittal@gmail.com &gt;"
  demo: true
  title: "AlphabeticOrder activity"
  description: "Place the alphabets in increasing order where the letter 'A' has the least value and 'Z' has the highest value. The value increases on moving from A towards Z"
  //intro: "put here in comment the text for the intro voice"
  goal: "Help children to get familiarized with the ordering of alphabets."
  prerequisite: "alphabet ordering"
  manual: "Drag and drop the alphabets in position of their increasing value (A to Z)."
  section: "reading"
}
