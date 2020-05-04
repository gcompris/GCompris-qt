/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2018 Your Name <yy@zz.org>
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
  name: "number_click/Number_click.qml"
  difficulty: 1
  icon: "number_click/number_click.svg"
  author: "Nicolas Da Silva &lt;nicolas.ds49@gmail.com&gt;"
  //: Activity title
  title: qsTr("Numbers with Tux")
  //: Help title
  description: qsTr("Click on tux as many as the number indicates.")
  //intro: "Click on tux as many as the number indicates, then press the ok button to check your answer. Don't forget how many times you clicked !"
  //: Help goal
  goal: qsTr("Counting skills, Instant Memory")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation")
  //: Help manual
  manual: qsTr("Click on tux as many as the number indicates then press the ok button to check your answer.")
  credit: "Idea from Emmanuel Charruau &lt;echarruau@gmail.com&gt;"
  section: "computer mouse"
  createdInVersion: 9700
}
