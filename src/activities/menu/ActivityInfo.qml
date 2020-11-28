/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "menu/Menu.qml"
  difficulty: 0
  //: Activity title
  title: qsTr("GCompris Main Menu")
  //: Help title
  description: qsTr("Select an activity to run it.")
  //: Help goal
  goal: qsTr("GCompris is a high quality educational software suite, including a large number of activities for children aged 2 to 10.")
  //: Help prerequisite
  prerequisite: qsTr("Some of the activities are game orientated, but still educational.")
  //: Help manual
  manual: qsTr("Select an icon to enter an activity or to display a list of activities in a category.
At the bottom of the screen is the GCompris control bar. Notice that you can hide or show the bar by touching its anchor.") + ("<br><br>") +
          qsTr("The following icons are displayed:
(note that each icon is displayed only if available in the current activity)") + ("<ul><li>") +
    qsTr("Home - Exit an activity, go back to menu (Ctrl+W or Escape key)") + ("</li><li>") +
    qsTr("Arrows - Display the current level. Click to select another level") + ("</li><li>") +
    qsTr("Lips - Repeat the question") + ("</li><li>") +
    qsTr("Question Mark - Help") + ("</li><li>") +
    qsTr("Reload - Start the activity from the beginning again") + ("</li><li>") +
    qsTr("Tool - The configuration menu") + ("</li><li>") +
    qsTr("Three lines - The activity settings menu") + ("</li><li>") +
    qsTr("G - About GCompris") + ("</li><li>") +
    qsTr("Quit - Quit GCompris (Ctrl+Q)") + ("</li></ul>") +
    qsTr("The stars show suitable age groups for each activity:") + ("<ul><li>") +
    qsTr("1, 2 or 3 yellow stars - from 2 to 6 years old")+ ("</li><li>") +
    qsTr("1, 2 or 3 red stars - 7 years and up")+ ("</li></ul>") +
    qsTr("If there are two different star icons on an activity, the first one shows the minimum difficulty, and the second one the maximum difficulty.") + ("<br><br>") +
    qsTr("<b>Keyboard shortcuts:</b>") + ("<ul><li>") +
    qsTr("Ctrl+B: Show or Hide the control bar") + ("</li><li>") +
    qsTr("Ctrl+F: Toggle full screen") + ("</li><li>") +
    qsTr("Ctrl+S: Toggle the activity section bar") + ("</li></ul>")
  credit: ""
  section: "/"
  createdInVersion: 0
}
