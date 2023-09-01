/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "explore_world_music/ExploreWorldMusic.qml"
  difficulty: 4
  icon: "explore_world_music/explore_world_music.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Explore world music")
  //: Help title
  description: qsTr("Learn about the music of the world.")
  // intro: "Click on the suitcases to learn about music from around the world."
  //: Help goal
  goal: qsTr("Develop a better understanding of the variety of music present in the world.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("There are three levels in this activity.") + ("<br><br>") +
          qsTr("In the first level, enjoy exploring music from around the world. Click on each suitcase to learn about the music from that area, and listen to a short sample. Study well, because you will be tested in level 2 and 3.") + ("<br><br>") +
          qsTr("In the second level you will hear a sample of music, and you must select the location that corresponds to this music. Click on the play button if you'd like to hear the music again.") + ("<br><br>") +
          qsTr("In the third level, you must select the location that matches the text description on the screen.")
  credit: qsTr("Images from https://commons.wikimedia.org/wiki, https://archive.org") + ("<ul><li>") +
          ('"Onalaska-Practice6" by Tom Harpel (https://commons.wikimedia.org/wiki/File:Onalaska-Practice6.jpg), CC BY 2.0') + ("</li><li>") +
          ('"Australia Aboriginal Culture 009" by Steve Evans (https://commons.wikimedia.org/wiki/File:Australia_Aboriginal_Culture_009.jpg), CC BY 2.0') + ("</li><li>") +
          ('"Lunny irvine o flynn glackin" by candyschwartz (https://commons.wikimedia.org/wiki/File:Lunny_irvine_o_flynn_glackin.jpg), CC BY 2.0') + ("</li><li>") +
          ('"08-rock-n-roll" by Karel Schmiedberger (https://commons.wikimedia.org/wiki/File:08-rock-n-roll.ogg), CC BY 3.0') + ("</li><li>") +
          ('"The Wind that Shakes the Barley" by peakfiddler (https://commons.wikimedia.org/wiki/File:The_Wind_that_Shakes_the_Barley.ogg), CC BY 3.0') + ("</li></ul>")
  section: "discovery music"
  createdInVersion: 0
}
