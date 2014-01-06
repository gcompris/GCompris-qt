import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "gnumch-equality"
  dir: "src/activities/gnumch-equality"
  difficulty: 3
  icon: "menus/gnumch-equal.svg"
  author: "Joe Neeman <spuzzzzzzz@gmail.com>"
  demo: true
  title: qsTr("Equality Number Munchers")
  description: qsTr("Guide the Number Muncher to the expressions that equal the number at the top of the screen.")
  goal: qsTr("Practice addition, multiplication, division and subtraction.")
  prerequisite: ""
  manual: qsTr("Use the arrow keys to navigate around the board and to avoid the Troggles. Press the spacebar to eat a number.")
  credit: ""
}
