/* GCompris - ActivityInfo.qml
*
* SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import GCompris 1.0

ActivityInfo {
  name: "explore_world_animals/ExploreWorldAnimals.qml"
  difficulty: 4
  icon: "explore_world_animals/explore_world_animals.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Explore world animals")
  //: Help title
  description: qsTr("Learn about world animals, interesting facts and their location on a map.")
  // intro: "Learn about world animals and locate them on a map."
  //: Help goal
  goal: qsTr("Learn about various wild animals from around the world and remember where they live.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("There are two levels in this game.") + ("<br><br>") +
          qsTr("In level one, players enjoy exploring each animal on the screen. Click on the question mark, and learn about the animal, what its name is, and what it looks like. Study well this information, because you will be tested in level 2.") + ("<br><br>") +
          qsTr("In level two, a random text prompt is displayed and you must click on the animal that matches the text.")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 0
}
