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
    difficulty: 1
    icon: "watercycle/watercycle.svg"
    author: qsTr("Sagar Chand Agarwal")
    demo: true
    title: "Watercycle activity"
    description: qsTr("Help Tux to take bath by completing the water cycle, and giving water to Tux's home ,before Tux reaches shore.")
    //intro: "put here in comment the text for the intro voice"
    goal: qsTr("Understand the water cycle and how it works.")
    prerequisite: "none"
    manual: ""
    credit: ""
    section: "fun"
}
