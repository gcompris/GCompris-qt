import GCompris 1.0

ActivityInfo {
  name: "memory-wordnumber/MemoryWordnumber.qml"
  difficulty: 3
  icon: "memory-wordnumber/memory_wordnumber.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: true
  title: qsTr("Wordnumber memory game")
  description: qsTr("Turn the cards over to match the number with the word matching it.")
//  intro: "Match the numeric with the word."
  goal: qsTr("Reading numbers, memory.")
  prerequisite: qsTr("Reading")
  manual: qsTr("You can see some cards, but you can't see what's on the other side of them. Each card is hiding a number of number, or the word of the number.")
  credit: ""
  section: "/reading"
}
