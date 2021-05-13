/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "submarine/Submarine.qml"
  difficulty: 5
  icon: "submarine/submarine.svg"
  author: "Rudra Nil Basu &lt;rudra.nil.basu.1996@gmail.com&gt;"
  //: Activity title
  title: qsTr("Pilot a submarine")
  //: Help title
  description: qsTr("Drive the submarine to the end point.")
  //intro: "Drive the submarine to the right end of the screen without colliding with any objects"
  //: Help goal
  goal: qsTr("Learn how to control a submarine.")
  //: Help prerequisite
  prerequisite: qsTr("Move and click using the mouse, physics basics.")
  //: Help manual
  manual: qsTr("Control the various parts of the submarine (the engine, ballast tanks and diving planes) to reach the end point.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<br>") +
          qsTr("<b>Engine</b>") + ("<ul><li>") +
          qsTr("D or Right arrow: increase the velocity") + ("</li><li>") +
          qsTr("A or Left arrow: decrease the velocity") + ("</li></ul>") +
          qsTr("<b>Ballast tanks</b>") + ("<ul><li>") +
          qsTr("W or Up arrow: switch filling of the central ballast tank") + ("</li><li>") +
          qsTr("S or Down arrow: switch flushing of the central ballast tank") + ("</li><li>") +
          qsTr("R: switch filling of the left ballast tank") + ("</li><li>") +
          qsTr("F: switch flushing of the left ballast tank") + ("</li><li>") +
          qsTr("T: switch filling of the right ballast tank") + ("</li><li>") +
          qsTr("G: switch flushing of the right ballast tank") + ("</li></ul>") +
          qsTr("<b>Diving planes</b>") + ("<ul><li>") +
          qsTr("+: increase diving planes angle") + ("</li><li>") +
          qsTr("-: decrease diving planes angle") + ("</li></ul>")
  credit: ""
  section: "sciences experiment"
  enabled: ApplicationInfo.isBox2DInstalled
  createdInVersion: 9000
}
