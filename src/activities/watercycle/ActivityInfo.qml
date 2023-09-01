/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "watercycle/Watercycle.qml"
  difficulty: 3
  icon: "watercycle/watercycle.svg"
  author: "Sagar Chand Agarwal &lt;atomsagar@gmail.com&gt;"
  //: Activity title
  title: qsTr("Watercycle")
  //: Help title
  description: qsTr("Tux has come back from fishing on his boat. Bring the water system back up so he can take a shower.")
  //intro: "Click on the various active elements that make up the water supply. Then press the shower button for Tux."
  //: Help goal
  goal: qsTr("Learn the water cycle.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click on different active elements: sun, cloud, pumping station, and the sewage treatment plant, in order to reactivate the entire water system. When the system is back up and Tux is in the shower, push the shower button for him.")
  credit: ""
  section: "sciences experiment"
  createdInVersion: 5000
}
