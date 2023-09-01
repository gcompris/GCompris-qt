/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "canal_lock/CanalLock.qml"
  difficulty: 2
  icon: "canal_lock/canal_lock.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Operate a canal lock")
  //: Help title
  description: qsTr("Tux is in trouble, and needs to take his boat through a lock. Help Tux and find out how a canal lock works.")
  //intro: "You are responsible for the lock and you must help Tux pass through. Click on the valves to cause either a drop or an increase in the water level, and click on the gates to open or close a path."
  //: Help goal
  goal: qsTr("Understand how a canal lock works.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("You are in charge of the canal lock. Open the gates and the locks in the right order, so that Tux can travel through the gates in both directions.")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 0
}
