import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "chess_partyend"
  dir: "src/activities/chess_partyend"
  difficulty: 2
  icon: "menus/chess_partyend.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Learning chess")
  description: qsTr("Play the end of the chess game against the computer")
  goal: ""
  prerequisite: qsTr("Mouse-manipulation")
  manual: ""
  credit: qsTr("The chess engine is from gnuchess.")
}
