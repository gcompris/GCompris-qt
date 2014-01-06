import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "hangman"
  dir: "src/activities/hangman"
  difficulty: 5
  icon: "menus/hangman.svg"
  author: "Bruno Coudoin"
  demo: false
  title: qsTr("The classic hangman game")
  description: qsTr("A word is hidden, you must discover it letter by letter")
  goal: qsTr("This is a good exercise to improve reading and spelling skills.")
  prerequisite: qsTr("Reading skill")
  manual: qsTr("You can enter the letters using the virtual keyboard on the screen or with the real keyboard.")
  credit: ""
}
