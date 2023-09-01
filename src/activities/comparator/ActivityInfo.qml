/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2022 Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 * Authors:
 *   Aastha Chauhan <aastha.chauhan01@gmail.com>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "comparator/Comparator.qml"
  difficulty: 2
  icon: "comparator/comparator.svg"
  author: "Aastha Chauhan &lt;aastha.chauhan01@gmail.com&gt;, Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Compare numbers")
  //: Help title
  description: qsTr("Compare the numbers and choose the corresponding sign.")
  //intro: "Select the correct comparator sign for each pair of numbers in the list."
  //: Help goal
  goal: qsTr("Learn how to compare number values.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Select a pair of numbers in the list. Then select the correct comparison symbol for this pair. When each line contains a symbol, select the OK button to validate the answers.") + ("<br><br>") +
    qsTr("If some answers are incorrect, a cross icon will appear on the corresponding lines. Correct the errors, then select the OK button again.") + ("<br><br>") +
    qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
    qsTr("Up and Down arrows: select a pair of numbers in the list") + ("</li><li>") +
    qsTr("Left and Right arrows: select a symbol button") + ("</li><li>") +
    qsTr("Space: if a symbol button is selected, enter this symbol") + ("</li><li>") +
    qsTr("Return: validate the answers") + ("</li><li>") +
    qsTr("&lt;, &gt; or =: enter the corresponding symbol") + ("</li></ul>")
  credit: ""
  section: "math numeration"
  createdInVersion: 30000
  levels: "1,2,3,4,5,6,7,8,9,10"
}
