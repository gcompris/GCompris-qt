/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Djalil Mesli <djalilmesli@gmail.com>
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
  name: "explore_farm_animals/ExploreFarmAnimals.qml"
  difficulty: 2
  icon: "explore_farm_animals/explore_farm_animals.svg"
  author: "Djalil Mesli &lt;djalilmesli@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Explore Farm Animals")
  //: Help title
  description: qsTr("Learn about farm animals, what sounds they make, and interesting facts.")
  // intro: "Learn about farmyard animals and the noises that they make."
  //: Help goal
  goal: qsTr("Learn to associate animal sounds with the animal name and what the animal looks like.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("There are three levels in this game.

In level one, players enjoy exploring each animal on the screen. Click on an animal and learn about it, what its name is, what sound it makes, and what it looks like. Study well this information, because you will be tested in level 2 and 3!

In level two, a random animal sound is played and you must find which animal makes this sound. Click on the corresponding animal. If you'd like to hear the animal sound repeated, click on the play button. When you have matched all animals correctly, you win!

In level three, a random text prompt is displayed and you must click on the animal that matches the text. When you have matched all texts correctly, you win!
")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 0
}
