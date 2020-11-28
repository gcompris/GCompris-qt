/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "find_the_day/FindTheDay.qml"
  difficulty: 6
  icon: "find_the_day/find_the_day.svg"
  author: "Amit Sagtani &lt;asagtani06@gmail.com&gt;"
  //: Activity title
  title: qsTr("Find the day")
  //: Help title
  description: qsTr("Find the correct date and select it on the calendar.")
  //intro: "Select the required day."
  //: Help goal
  goal: qsTr("Learn how to count days and find a date on a calendar.")
  //: Help prerequisite
  prerequisite: qsTr("Basics of calendar.")
  //: Help manual
  manual: qsTr("Read the instructions and perform the requested calculation to find the date. Then select this date on the calendar, and validate your answer by clicking on the OK button.") + ("<br><br>") + qsTr("In some levels, you need to find the day of the week for a given date. In this case, click on the corresponding day of the week in the list.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate through the answers") + ("</li><li>") +
          qsTr("Space or Enter: validate your answer") + ("</li></ul>")
  credit: ""
  section: "math measures"
  createdInVersion: 9000
}
