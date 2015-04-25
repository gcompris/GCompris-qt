/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
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
  name: "tuxpaint/Tuxpaint.qml"
  difficulty: 1
  icon: "tuxpaint/tuxpaint.svg"
  author: "Bill Kendrick <Tuxpaint>"
  demo: true
  title: qsTr("Tuxpaint")
  description: qsTr("Launch Tuxpaint")
  goal: qsTr("Drawing activity (pixmap)")
  prerequisite: qsTr("mouse and keyboard manipulation")
  manual: qsTr("Use Tuxpaint to draw. When Tuxpaint is finished this board will end.")
  credit: ""
  section: "/fun"
}
