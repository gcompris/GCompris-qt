/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Ayush Agrawal <ayushagrawal288@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "explore_monuments/Explore_monuments.qml"
  difficulty: 3
  icon: "explore_monuments/explore_monuments.svg"
  author: "Ayush Agrawal &lt;ayushagrawal288@gmail.com&gt;"
  //: Activity title
  title: qsTr("Explore monuments")
  //: Help title
  description: qsTr("Explore monuments around the world.")
  //intro: "Explore Monuments around the world."
  //: Help goal
  goal: qsTr("Learn about various monuments from around the world and remember their location.")
  //: Help prerequisite
  prerequisite: qsTr("Knowledge of different monuments.")
  //: Help manual
  manual: qsTr("Click on the spots to learn about the monuments and then locate them on the map.")
  credit: qsTr("Photos taken from Wikipedia.") + ("<ul><li>") +
          ('"Chichen Itza 3" by Daniel Schwen (https://commons.wikimedia.org/wiki/File:Chichen_Itza_3.jpg), CC BY-SA 4.0') + ("</li><li>") +
          ('"1 cristor redentor 2014" by Chensiyuan (https://commons.wikimedia.org/wiki/File:1_cristor_redentor_2014.jpg), CC BY-SA 4.0') + ("</li><li>") +
          ('"Taj Mahal, Agra, India" by Yann (https://commons.wikimedia.org/wiki/File:Taj_Mahal,_Agra,_India.jpg), CC BY-SA 4.0') + ("</li></ul>")
  section: "sciences geography"
  createdInVersion: 6000
}
