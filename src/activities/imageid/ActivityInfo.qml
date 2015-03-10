/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
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
  name: "imageid/Imageid.qml"
  difficulty: 2
  icon: "imageid/imageid.svg"
  author: "Holger Kaelberer <holger.k@elberer.de>"
  demo: true
  title: qsTr("Reading practice")
  description: qsTr("Practice reading by finding the word matching an image")
//  intro: "Click on the word matching the picture."
  goal: qsTr("Letter association between the screen and the keyboard")
  prerequisite: qsTr("Reading")
  manual: qsTr("Click on the word corresponding to the printed image.")
  credit: ""
  section: "reading"
}
