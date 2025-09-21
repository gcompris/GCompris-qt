/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "multiple_choice_questions/Multiple_choice_questions.qml"
  difficulty: 1
  icon: "multiple_choice_questions/multiple_choice_questions.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Multiple-choice questions")
  //: Help title
  description: qsTr("A generic activity for multiple-choice questions.")
  //intro: "Answer the questions."
  //: Help goal
  goal: qsTr("Answer questions sent by the teacher.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click an answer to select it, then press the OK button to validate. Some questions require a single answer, other questions require multiple answers. For some questions, after validating the answer, a feedback text panel will be displayed: click anywhere to close this panel after reading it.")  + ("<br><br>") +
      qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
      qsTr("Up and Down arrows: navigate through the answer list") + ("</li><li>") +
      qsTr("Space: select or deselect the highlighted answer") + ("</li><li>") +
      qsTr("Enter: validate your answer, or close the feedback text panel") + ("</li></ul>")
  credit: ""
  section: "computer"
  createdInVersion: 260000
  enabled: currentLevels.length != 0
  levels: []
}
