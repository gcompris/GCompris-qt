/* GCompris - lang.qml
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
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
  name: "lang/Lang.qml"
  difficulty: 4
  icon: "lang/lang.svg"
  author: "siddhesh suthar &lt;siddhesh.it@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Enrich your vocabulary")
  //: Help title
  description: qsTr("Complete language learning activities.")
  // intro: "Select the language you want to learn then review the words before doing the exercises."
  //: Help goal
  goal: qsTr("Enrich your vocabulary in your native language or in a foreign one.")
  //: Help prerequisite
  prerequisite: qsTr("Reading")
  //: Help manual
  manual: qsTr("Review a set of words. Each word is shown with a voice, a text and an image.<br/>"
           + "When done, you are suggested an exercise in which, given the voice, "
           + "you must find the right word. In the configuration, you can select the language you want to learn.")
  credit: qsTr("The images and voices come from the Art4Apps project: http://www.art4apps.org/.")
  section: "reading vocabulary"
  createdInVersion: 5000
}
