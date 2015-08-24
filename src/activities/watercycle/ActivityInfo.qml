/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
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
    name: "watercycle/Watercycle.qml"
    difficulty: 3
    icon: "watercycle/watercycle.svg"
    author: "Sagar Chand Agarwal &lt;atomsagar@gmail.com&gt;"
    demo: true
    title: qsTr("Watercycle")
    description: qsTr("Tux has come back from a long fishing party on his boat. Bring the water system back up so he can take a shower.")
    //intro: "Click on the various active elements that make up the water supply. Then press the shower button for Tux."
    goal: qsTr("Learn the water cycle")
    prerequisite: ""
    manual: qsTr("Click on different active elements: sun, cloud, pumping station, and the sewage treatment plant, in order to reactivate the entire water system. When the system is back up and Tux is in the shower, push the shower button for him.")
    credit: qsTr("Drawing by Stephane Cabaraux.")
    section: "experiment"
}
