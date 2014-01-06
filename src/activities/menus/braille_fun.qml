import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "braille_fun"
  dir: "src/activities/braille_fun"
  difficulty: 6
  icon: "menus/braille_fun.svg"
  author: "Srishti Sethi <srishakatux@gmail.com>"
  demo: true
  title: qsTr("Braille Fun")
  description: qsTr("Braille the falling letters")
  goal: ""
  prerequisite: qsTr("Braille Alphabet Codes")
  manual: qsTr("Enter the braille code in the tile for the corresponding falling letters. Check the braille chart by clicking on the toggle button for help.")
  credit: ""
}
