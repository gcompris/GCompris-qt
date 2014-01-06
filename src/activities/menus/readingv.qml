import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "readingv"
  dir: "src/activities/readingv"
  difficulty: 2
  icon: "menus/reading.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Vertical-reading practice")
  description: qsTr("Read a vertical list of words and work out if a given word is in it")
  goal: qsTr("Read training in a limited time")
  prerequisite: qsTr("Reading")
  manual: qsTr("A word is shown at the top right of the board. A list of words will appear and disappear on the left. Does the given word belong to the list?")
  credit: ""
}
