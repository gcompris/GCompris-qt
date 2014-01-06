import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "doubleentry"
  dir: "src/activities/doubleentry"
  difficulty: 2
  icon: "menus/doubleentry.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Double-entry table")
  description: qsTr("Drag and Drop the items in the double-entry table")
  goal: qsTr("Move the items on the left to their proper position in the double-entry table.")
  prerequisite: qsTr("Basic counting skills")
  manual: qsTr("Drag and Drop each proposed item on its destination")
  credit: ""
}
