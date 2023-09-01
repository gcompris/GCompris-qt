/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Djalil Mesli <djalilmesli@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "explore_farm_animals/ExploreFarmAnimals.qml"
  difficulty: 2
  icon: "explore_farm_animals/explore_farm_animals.svg"
  author: "Djalil Mesli &lt;djalilmesli@gmail.com&gt;"
  //: Activity title
  title: qsTr("Explore farm animals")
  //: Help title
  description: qsTr("Learn about farm animals, what sounds they make, and interesting facts.")
  // intro: "Learn about farmyard animals and the noises that they make."
  //: Help goal
  goal: qsTr("Learn to associate animal sounds with the animal name and what the animal looks like.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("There are three levels in this game.") + ("<br><br>") +
          qsTr("In level one, players enjoy exploring each animal on the screen. Click on an animal and learn about it, what its name is, what sound it makes, and what it looks like. Study well this information, because you will be tested in level 2 and 3.")  + ("<br><br>") +
          qsTr("In level two, a random animal sound is played and you must find which animal makes this sound. Click on the corresponding animal. If you'd like to hear the animal sound repeated, click on the play button.") + ("<br><br>") +
          qsTr("In level three, a random text prompt is displayed and you must click on the animal that matches the text.")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 0
}
