import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "wordsgame"
  dir: "src/activities/wordsgame"
  difficulty: 2
  icon: "menus/wordsgame.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Falling Words")
  description: qsTr("Type the falling words before they reach the ground")
  goal: qsTr("Keyboard training")
  prerequisite: qsTr("Keyboard manipulation")
  manual: qsTr("Type the complete word as it falls, before it reaches the ground")
  credit: ""
}
