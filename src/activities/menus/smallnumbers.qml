import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "smallnumbers"
  dir: "src/activities/smallnumbers"
  difficulty: 1
  icon: "menus/smallnumbers.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Numbers With Dice")
  description: qsTr("Count the number of dots on dice before they reach the ground")
  goal: qsTr("In a limited time, count the number of dots")
  prerequisite: qsTr("Counting skills")
  manual: qsTr("With the keyboard, type the number of dots you see on the falling dice.")
  credit: ""
}
