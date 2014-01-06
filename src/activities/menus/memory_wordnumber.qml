import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "memory_wordnumber"
  dir: "src/activities/memory_wordnumber"
  difficulty: 1
  icon: "menus/memo_wordnumber.svg"
  author: "Yves Combe <yves@ycombe.net>"
  demo: true
  title: qsTr("Wordnumber memory game")
  description: qsTr("Turn the cards over to match the number with the word matching it.")
  goal: qsTr("Reading numbers, memory.")
  prerequisite: qsTr("Reading")
  manual: qsTr("You can see some cards, but you can't see what's on the other side of them. Each card is hiding a number of number, or the word of the number.")
  credit: ""
}
