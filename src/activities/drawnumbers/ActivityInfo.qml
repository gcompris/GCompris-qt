/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Nitish Chauhan <nitish.nc18@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

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
    goal: qsTr("Learn how to draw numbers in a fun way.")
    prerequisite: ""
    //: Help manual
    manual: qsTr("Draw the numbers by connecting the dots in the correct order. You can click and drag from one point to the next ones, or click on each point one after the other.")
    credit: ""
    section: "math numeration"
    createdInVersion: 7000
}
