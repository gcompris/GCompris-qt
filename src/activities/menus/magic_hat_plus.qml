import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "magic_hat_plus"
  dir: "src/activities/magic_hat_plus"
  difficulty: 2
  icon: "menus/magic_hat_plus.svg"
  author: "Marc BRUN"
  demo: true
  title: qsTr("The magician hat")
  description: qsTr("Count how many items are under the magic hat")
  goal: qsTr("Learn addition")
  prerequisite: qsTr("Addition")
  manual: qsTr("Click on the hat to open or close it. Under the hat, how many stars can you see moving around? Count carefully. :) Click in the bottom-right area to input your answer.")
  credit: ""
}
