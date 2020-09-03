/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Johnny Jazeix <jazeix@gmail.com>
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
  name: "explore_world_music/ExploreWorldMusic.qml"
  difficulty: 4
  icon: "explore_world_music/explore_world_music.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Explore World Music")
  //: Help title
  description: qsTr("Learn about the music of the world.")
  // intro: "Click on the suitcases to learn about music from around the world."
  //: Help goal
  goal: qsTr("Develop a better understanding of the variety of music present in the world.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("There are three levels in this activity.") + ("<br><br>") +
          qsTr("In the first level, enjoy exploring music from around the world. Click on each suitcase to learn about the music from that area, and listen to a short sample. Study well, because you will be tested in level 2 and 3.") + ("<br><br>") +
          qsTr("In the second level you will hear a sample of music, and you must select the location that corresponds to this music. Click on the play button if you'd like to hear the music again.") + ("<br><br>") +
          qsTr("In the third level, you must select the location that matches the text description on the screen.")
  credit: qsTr("Images from https://commons.wikimedia.org/wiki, https://archive.org")
  section: "discovery music"
  createdInVersion: 0
}
