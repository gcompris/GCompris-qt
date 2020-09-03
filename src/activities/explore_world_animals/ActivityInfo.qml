/* GCompris - ActivityInfo.qml
*
* Copyright (C) 2015 Johnny Jazeix <jazeix@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import GCompris 1.0

ActivityInfo {
  name: "explore_world_animals/ExploreWorldAnimals.qml"
  difficulty: 4
  icon: "explore_world_animals/explore_world_animals.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Explore World Animals")
  //: Help title
  description: qsTr("Learn about world animals, interesting facts and their location on a map.")
  // intro: "Learn about world animals and locate them on a map."
  //: Help goal
  goal: "Learn about various wild animals from around the world and remember where they live."
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("There are two levels in this game.") + ("<br><br>") +
          qsTr("In level one, players enjoy exploring each animal on the screen. Click on the question mark, and learn about the animal, what its name is, and what it looks like. Study well this information, because you will be tested in level 2.") + ("<br><br>") +
          qsTr("In level two, a random text prompt is displayed and you must click on the animal that matches the text.")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 0
}
