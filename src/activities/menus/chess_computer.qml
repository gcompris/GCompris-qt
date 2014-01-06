import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "chess_computer"
  dir: "src/activities/chess_computer"
  difficulty: 2
  icon: "menus/chess_computer.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Learning chess")
  description: qsTr("Play chess against the computer in a learning mode")
  goal: ""
  prerequisite: qsTr("Mouse-manipulation")
  manual: ""
  credit: qsTr("The chess engine is from gnuchess.")
}
