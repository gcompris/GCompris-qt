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
  name: "menu/Menu.qml"
  difficulty: 0
  title: qsTr("GCompris Main Menu")
  description: qsTr("Select an activity to run it.")
  goal: qsTr("GCompris is a high quality educational software suite comprising of numerous activities for children aged 2 to 10.")
  prerequisite: qsTr("Some of the activities are game orientated, but nonetheless still educational.")
  manual: qsTr("Select an icon to enter an activity or to display a list of activities in a category.
At the bottom of the screen is the GCompris control bar. Notice that you can hide or show the bar by touching its anchor.
The following icons are displayed from right to left.
(note that each icon is displayed only if available in the current activity)
    Home - Exit an activity, go back to menu (ctrl-w and escape key)
    Arrows - Display the current level. Click to select another level
    Lips - Repeat the question
    Question Mark - Help
    Tool - The configuration menu
    Tux Plane - About GCompris
    Quit - Quit GCompris (ctrl-q)
The stars show suitable age groups for each game:
    1, 2 or 3 simple stars - from 2 to 6 years old
    1, 2 or 3 complex stars - 7 years and up
Shortcuts:
    ctrl-b Show or Hide the control bar
    ctrl-f Toggle full screen
    ctrl-m Toggle mute for the background music" )
  credit: ""
  section: "/"
}
