import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "hanoi"
  dir: "src/activities/hanoi"
  difficulty: 2
  icon: "menus/hanoi.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Simplified Tower of Hanoi")
  description: qsTr("Reproduce the given tower")
  goal: qsTr("Reproduce the tower on the right in the empty space on the left")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Drag and Drop one top piece at a time, from one peg to another, to reproduce the tower on the right in the empty space on the left.")
  credit: qsTr("Concept taken from EPI games.")
}
