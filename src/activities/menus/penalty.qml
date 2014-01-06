import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "penalty"
  dir: "src/activities/penalty"
  difficulty: 2
  icon: "menus/penalty.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Penalty kick")
  description: qsTr("Double click the mouse on the ball to score a goal.")
  goal: qsTr("Motor-coordination")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Double click the mouse on the ball to kick it. You can double click the left right or middle mouse button. If you lose, Tux catches the ball. You must click on it to bring it back to its former position")
  credit: ""
}
