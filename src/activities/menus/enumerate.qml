import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "enumerate"
  dir: "src/activities/enumerate"
  difficulty: 1
  icon: "menus/enumerate.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Count the items")
  description: qsTr("Place the items in the best way to count them")
  goal: qsTr("Numeration training")
  prerequisite: qsTr("Basic enumeration")
  manual: qsTr("First, properly organize the items so that you can count them. Then, select the item you want to answer in the bottom right area. Enter the answer with the keyboard and press the OK button or the 'Enter' key.")
  credit: ""
}
