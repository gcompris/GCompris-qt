import GCompris 1.0

ActivityInfo {
  name: "fifteen/Fifteen.qml"
  difficulty: 5
  icon: "fifteen/fifteen.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("The fifteen game")
  description: qsTr("Move each item to make an increasing series: from the smallest to the largest")
//  intro: "Click on an element next to a free space, the element will move and release its space. You must put all the elements into the correct order."
  goal: ""
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Click on any item that has a free block beside it, and it will be swapped with the empty block.")
  credit: qsTr("")
  section: "puzzle"
}
