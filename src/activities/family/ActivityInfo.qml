/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2016 Rajdeep Kaur <rajdeep.kaur@kde.org>
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
  name: "family/Family.qml"
  difficulty: 2
  icon: "family/family.svg"
  author: "Rajdeep Kaur &lt;rajdeep.kaur@kde.org&gt;"
  demo: true
  //: Activity title
  title: qsTr("Family")
  //: Help title
  description: qsTr("Select the name you should call this family member")
  //intro: "Let us understand what to call our relatives"
  //: Help goal
  goal: qsTr("Learn the relationships in a family, according to the lineal system used in most Western societies")
  //: Help prerequisite
  prerequisite: qsTr("Reading skills")
  //: Help manual
  manual: qsTr("A family tree is shown.\n" +
  "The circles are linked with lines to mark the relations. Married couples are marked with a ring on the link.\n" +
  "You are the person in the white circle. Select the name you should call the person in the orange circle.\n")
  credit: ""
  section: "sciences history"
  createdInVersion: 9000
}
