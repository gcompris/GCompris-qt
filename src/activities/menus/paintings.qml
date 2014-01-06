import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "paintings"
  dir: "src/activities/paintings"
  difficulty: 1
  icon: "menus/shapegame.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Assemble the puzzle")
  description: qsTr("Drag and Drop the items to rebuild the original paintings")
  goal: qsTr("Spatial representation")
  prerequisite: qsTr("Mouse-manipulation: movement, drag and drop")
  manual: qsTr("Drag the image parts from the box on the left to create a painting on the main board.")
  credit: ""
}
