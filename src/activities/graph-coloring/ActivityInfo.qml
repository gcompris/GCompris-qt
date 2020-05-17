/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "graph-coloring/GraphColoring.qml"
  difficulty: 1
  icon: "graph-coloring/graph-coloring.svg"
  author: "Akshat Tandon &lt;akshat.tandon@research.iiit.ac.in&gt;"
  //: Activity title
  title: qsTr("Graph Coloring")
  //: Help title
  description: qsTr("Color the graph so that no two adjacent nodes have the same color.")
  //intro: "Color the graph so that no two adjacent nodes have the same color."
  //: Help goal
  goal: qsTr("Learn to distinguish between different colors/shapes and learn about relative positions.")
  //: Help prerequisite
  prerequisite: qsTr("Ability to distinguish different colors/shapes, sense of positions")
  //: Help manual
  manual: qsTr("Place colors/shapes on the graph so that no two adjacent nodes have the same color. Select a node, then select an item in the list to place it on the node.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<br>") +
          qsTr("-Use Right and Left arrow keys to navigate") + ("<br>") +
          qsTr("-Use Space key to select an item")
  credit: ""
  section: "discovery logic"
  createdInVersion: 6000
}
