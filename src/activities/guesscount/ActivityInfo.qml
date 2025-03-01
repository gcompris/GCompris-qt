/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Rahul Yadav <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
    name: "guesscount/Guesscount.qml"
    difficulty: 3
    icon: "guesscount/guesscount.svg"
    author: "Rahul Yadav &lt;rahulyadav170923@gmail.com&gt;"
    //: Activity title
    title: qsTr("Guesscount")
    //: Help title
    description:qsTr("Find the operations to get the required result.")
    //intro: "Use the numbers and operations suggested to find the results proposed above."
    //: Help goal
    goal: qsTr("Practice decomposed calculation.")
    //: Help prerequisite
    prerequisite: qsTr("Knowledge of arithmetic operations.")
    //: Help manual
    manual: qsTr("Drag the numbers and operators to the boxes to obtain the number given in the instructions.")
    credit: ""
    section: "math arithmetic"
    createdInVersion: 8000
    levels: ["1", "2", "3", "4"]
}
