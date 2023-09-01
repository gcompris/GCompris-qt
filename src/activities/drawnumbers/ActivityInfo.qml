/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Nitish Chauhan <nitish.nc18@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "drawnumbers/Drawnumbers.qml"
    difficulty: 1
    icon: "drawnumbers/drawnumbers.svg"
    author: "Nitish Chauhan &lt;nitish.nc18@gmail.com&gt;"
    //: Activity title
    title: qsTr("Draw numbers")
    //: Help title
    description: qsTr("Connect the dots to draw numbers from 0 to 9.")
    // intro: "Draw the numbers by connecting the dots in the correct order."
    //: Help goal
    goal: qsTr("Learning how to draw numbers in a funny way.")
    prerequisite: ""
    //: Help manual
    manual: qsTr("Draw the numbers by connecting the dots in the correct order.")
    credit: ""
    section: "math numeration"
    createdInVersion: 7000
}
