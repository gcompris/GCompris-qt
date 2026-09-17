/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "polygons/Polygons.qml"
  difficulty: 4
  icon: "polygons/polygons.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;, Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Polygons")
  //: Help title
  description: qsTr("Learn about special polygons and draw them in a grid.")
  //intro: "Draw the requested polygons by clicking on the grid."
  //: Help goal
  goal: qsTr("Learn about special polygons.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click on the grid to place points corresponding to the ends of the polygon's lines. As long as the shape is not closed, the last point is of a different color to indicate that it will be connected to the next point added. After placing at least 3 points, you can close the shape by clicking on the first or the last point. When the shape is closed, you can not add new points. You can move a point by dragging it, or delete it with a double-click. You can restart the shape by clicking on the reload button. When the shape is correct, press the OK button to validate your answer.")
  credit: ""
  section: "discovery arts"
  createdInVersion: 270000
}
