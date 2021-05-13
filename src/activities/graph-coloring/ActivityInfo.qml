/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "graph-coloring/GraphColoring.qml"
  difficulty: 1
  icon: "graph-coloring/graph-coloring.svg"
  author: "Akshat Tandon &lt;akshat.tandon@research.iiit.ac.in&gt;"
  //: Activity title
  title: qsTr("Graph coloring")
  //: Help title
  description: qsTr("Color the graph so that no two adjacent nodes have the same color.")
  //intro: "Color the graph so that no two adjacent nodes have the same color."
  //: Help goal
  goal: qsTr("Learn to distinguish between different colors/shapes and learn about relative positions.")
  //: Help prerequisite
  prerequisite: qsTr("Ability to distinguish different colors/shapes, sense of positions.")
  //: Help manual
  manual: qsTr("Place colors/shapes on the graph so that no two adjacent nodes have the same color. Select a node, then select an item in the list to place it on the node.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Right and Left arrows: navigate") + ("</li><li>") +
          qsTr("Space: select an item") + ("</li></ul>")
  credit: ""
  section: "discovery logic"
  createdInVersion: 6000
}
