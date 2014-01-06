import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "chess_movelearn"
  dir: "src/activities/chess_movelearn"
  difficulty: 2
  icon: "menus/chess_movelearn.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Learning chess")
  description: qsTr("Chess training. Catch the computer's pawns.")
  goal: ""
  prerequisite: qsTr("Mouse-manipulation")
  manual: ""
  credit: qsTr("The chess engine is from gnuchess.")
}
