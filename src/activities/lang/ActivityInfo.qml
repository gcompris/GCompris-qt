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
  name: "lang/Lang.qml"
  difficulty: 1
  icon: "lang/lang.svg"
  author: "siddhesh suthar <siddhesh.it@gmail.com>"
  demo: false
  title: qsTr("Lang activity")
  description: qsTr("Complete language learning activities.")
  goal: qsTr("Enrich your vocabulary in your native language or in a foreign one.")
  prerequisite: qsTr("Reading")
  manual: qsTr("Review a set of words. Each word is shown with a voice a text and an image.")
           + "<br><br>" + qsTr("When done you are suggested an exercise in which, given the voice,")
           + "<br><br>" + qsTr("you must find the right word. In the configuration you can select the language you want to learn.")
  credit: qsTr("The images and voices come from the Art4Apps project: http://www.art4apps.org/.")
           + "<br><br>" +qsTr(" You can also access this activity online on http://gcompris.net/activity/lang.")
  section: "reading"
  enabled: DownloadManager.isDataRegistered("words") || ApplicationInfo.isDownloadAllowed
}
