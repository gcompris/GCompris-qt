/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
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
  name: "lang-people/Lang-people.qml"
  difficulty: 4
  icon: "lang-people/lang-people.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  title: qsTr("Enrich your vocabulary")
  description: qsTr("List of words in the 'people' category.")
  goal: qsTr("Enrich your vocabulary in your native language or in a foreign one.")
  prerequisite: qsTr("Reading")
  manual: qsTr("Review a set of words. Each word is shown with a voice a text and an image. When done you are suggested an exercice in which, given the voice, you must find the right word. In the configuration you can select the language you want to learn.")
  credit: qsTr("The images and voices come from the Art4Apps project: http://www.art4apps.org/. You can also access this activity online on http://gcompris.net/activity/lang.")
  section: "/reading/lang"
}
