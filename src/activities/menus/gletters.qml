import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "gletters"
  dir: "src/activities/gletters"
  difficulty: 1
  icon: "menus/gletters.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: true
  title: qsTr("Simple Letters")
  description: qsTr("Type the falling letters before they reach the ground")
  goal: qsTr("Letter association between the screen and the keyboard")
  prerequisite: qsTr("Keyboard manipulation")
  manual: qsTr("Type the falling letters before they reach the ground")
  credit: ""
}
