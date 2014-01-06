import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "traffic"
  dir: "src/activities/traffic"
  difficulty: 2
  icon: "menus/traffic.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("A sliding-block puzzle game")
  description: qsTr("Remove the red car from the parking lot through the gate on the right")
  goal: qsTr("Remove the red car from the parking lot through the gate on the right")
  prerequisite: ""
  manual: qsTr("Each car can only move either horizontally or vertically. You must make some room in order to let the red car move through the gate on the right.")
  credit: ""
}
