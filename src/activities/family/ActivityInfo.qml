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
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "family/Family.qml"
  difficulty: 2
  icon: "family/family.svg"
  author: "Rajdeep Kaur &lt;rajdeep.kaur@kde.org&gt;"
  demo: true
  title: qsTr("Family")
  description: qsTr("This activity will give teach about who we are related to our relatives")
  //intro: "Let us understand what to call our relatives"
  goal: qsTr("To get an idea about relationships in the family")
  prerequisite: qsTr("Reading skills")
  manual: qsTr("To find the relation between two family members.\n" +
     "For the married couple we have highlighted with the rings that is between two circles. For the rest of relations we have only solid lines.\n" +
  "Red circle will point to you and blue one to your relative. Now you have to find what you should call this person.\n")
  credit: ""
  section: "discovery"
  createdInVersion: 9000
}
