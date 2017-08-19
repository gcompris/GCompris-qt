/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
  name: "canal_lock/CanalLock.qml"
  difficulty: 2
  icon: "canal_lock/canal_lock.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Operate a canal lock")
  //: Help title
  description: qsTr("Tux is in trouble, and needs to take his boat through a lock. Help Tux and find out how a canal lock works.")
  //intro: "You are responsible for the lock and you must help Tux pass through. Click on the valves to cause either a drop or an increase in the water level, and click on the gates to open or close a path."
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("You are in charge of the canal lock. Open the gates and the locks in the right order, so Tux can travel through the gates in both directions.")
  credit: qsTr("Drawing by Stephane Cabaraux.")
  section: "experiment"
}
