import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "bargame"
  dir: "src/activities/bargame"
  difficulty: 2
  icon: "menus/bargame.svg"
  author: "Yves Combe"
  demo: true
  title: qsTr("bar game")
  description: qsTr("Don't use the last ball")
  goal: qsTr("Logic-training activity")
  prerequisite: qsTr("Brain")
  manual: qsTr("Place balls in the holes. You win if the computer has to place the last ball. If you want Tux to begin, just click on him.")
  credit: ""
}
