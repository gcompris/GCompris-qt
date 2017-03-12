/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2017 Johnny Jazeix <jazeix@gmail.com>
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
    name: "checkers/Checkers.qml"
    difficulty: 4
    icon: "checkers/checkers.svg"
    author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
    demo: true
    title: qsTr("Play checkers against the computer")
    description: ""
    //intro: "play checkers against the computer"
    goal: ""
    prerequisite: ""
    manual: ""
    credit: qsTr("The checkers library is draughts.js &lt;https://github.com/shubhendusaurabh/draughts.js&gt;.")
    section: "strategy"
    createdInVersion: 8000
}
