import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "fifteen"
  dir: "src/activities/fifteen"
  difficulty: 5
  icon: "menus/fifteen.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("The fifteen game")
  description: qsTr("Move each item to make an increasing series: from the smallest to the largest")
  goal: ""
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Click on any item that has a free block beside it, and it will be swapped with the empty block.")
  credit: qsTr("Original code taken from the libgnomecanvas demo")
}
