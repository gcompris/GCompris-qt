import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "planegame"
  dir: "src/activities/planegame"
  difficulty: 2
  icon: "menus/helicogame.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Numbers in Order")
  description: qsTr("Move the helicopter to catch the clouds in the correct order")
  goal: qsTr("Numeration training")
  prerequisite: qsTr("Number")
  manual: qsTr("Catch the numbers in increasing order, using the up, down, right and left arrows on the keyboard to move the helicopter.")
  credit: ""
}
