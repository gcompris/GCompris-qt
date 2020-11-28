/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Thib ROMAIN <thibrom@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "enumerate/Enumerate.qml"
    difficulty: 2
    icon: "enumerate/enumerate.svg"
    author: "Thib ROMAIN &lt;thibrom@gmail.com&gt;"
    //: Activity title
    title: qsTr("Count the items")
    //: Help title
    description: qsTr("Place the items in the best way to count them.")
//  intro: "Count the elements by organizing them then type the answer on your keyboard."
    //: Help goal
    goal: qsTr("Numeration training.")
    //: Help prerequisite
    prerequisite: qsTr("Basic enumeration.")
    //: Help manual
    manual: qsTr("First, properly organize the items so that you can count them. Then, click on an item of the answers list in the top left area and enter the corresponding answer with the keyboard.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Up arrow: select next item") + ("</li><li>") +
          qsTr("Down arrow: select previous item") + ("</li><li>") +
          qsTr("Digits: enter your answer for the selected item") + ("</li><li>") +
          qsTr("Enter: validate your answer (if the 'Validate answers' option is set to 'OK button')") + ("</li></ul>")
    credit: ""
  section: "math numeration"
  createdInVersion: 0
  levels: "1,2,3,4"
}
