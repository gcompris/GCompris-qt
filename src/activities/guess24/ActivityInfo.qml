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
import GCompris 1.0

ActivityInfo {
    name: "guess24/Guess24.qml"
    difficulty: 3
    icon: "guess24/guesscount.svg"
    author: "Rahul Yadav &lt;rahulyadav170923@gmail.com&gt;"
    //: Activity title
    title: qsTr("Guess24")
    //: Help title
    description:qsTr("Guess the algebraic expression and drag the tiles to get a result equal to the Guesscount.")
    //intro: "Use the numbers and operations suggested to find the results proposed above."
    //: Help goal
    goal: qsTr("Intuition and practice of algebraic-like calculations.")
    //: Help prerequisite
    prerequisite: qsTr("Knowledge of arithmetic operations.")
    //: Help manual
    manual: qsTr("Drag the appropriate numbers and the operators to the boxes to obtain the number to guess in the instruction.")
    credit: ""
    section: "math arithmetic"
    createdInVersion: 8000
    levels: "1,2,3,4"
}
