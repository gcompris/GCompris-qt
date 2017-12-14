/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *    Aman Kumar Gupta <gupta2140@gmail.com>
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
  name: "solar_system/Solar_system.qml"
  difficulty: 3
  icon: "solar_system/solar_system.svg"
  author: "Aman Kumar Gupta &lt;gupta2140@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Solar System")
  //: Help title
  description: qsTr("Answer the questions presented and get a 100% correctness among the options.")
  //intro: "Answer the questions presented and get a 100% correctness among the options."
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click on a planet or the Sun to reveal questions. Each question contains 4 options. One of those is 100% correct. Try to answer the questions till you get a 100% closeness in the closeness meter.")
  credit: ""
  section: "fun"
  createdInVersion: 9000
}
