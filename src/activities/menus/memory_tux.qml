import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "memory_tux"
  dir: "src/activities/memory_tux"
  difficulty: 2
  icon: "menus/memory_tux.svg"
  author: "Yves Combe <yves@ycombe.net>"
  demo: true
  title: qsTr("Memory Game with images, against Tux")
  description: qsTr("Have a memory competition with Tux.")
  goal: qsTr("Train your memory and remove all the cards")
  prerequisite: qsTr("Mouse manipulation, Brain.")
  manual: qsTr("You can see a set of cards that all look the same. Each card has a picture on the other side, and each picture has a twin somewhere in the set. You can only turn over two cards at once, so you need to remember where the pictures are until you can find the twin. When you turn over twins, they disappear! You take turns with Tux, and to win the game, you have to find more pairs of twins than he does.")
  credit: ""
}
