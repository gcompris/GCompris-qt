import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "readingh"
  dir: "src/activities/readingh"
  difficulty: 2
  icon: "menus/readingh.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Horizontal reading practice")
  description: qsTr("Read a list of words and work out if a given word is in it")
  goal: qsTr("Reading training in a limited time")
  prerequisite: qsTr("Reading")
  manual: qsTr("A word is shown at the top right of the board. A list of words will appear and disappear on the left. Does the given word belong to the list?")
  credit: ""
}
