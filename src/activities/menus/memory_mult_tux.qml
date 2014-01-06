import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "memory_mult_tux"
  dir: "src/activities/memory_mult_tux"
  difficulty: 1
  icon: "menus/mem_tux_mult.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Multiplication memory game against Tux")
  description: qsTr("Turn the cards over to find a matching operation, until all the cards are gone.")
  goal: qsTr("Practise multiplication until all the cards are gone.")
  prerequisite: qsTr("Additions")
  manual: qsTr("You can see some cards, but you can't see what's on the other side of them. Each card is hiding an operation, or the answer to it.

In this game, these cards are hiding the two parts of an operation. You need to find the two parts of the operation, and bring them together again. Click on a card to see what number it's hiding, then try to find the other card that goes with it, to make a whole operation. You can only turn over two cards in one go, so you need to remember where the numbers are hiding, then you can match them when you find their other half. You're doing the job of the equals sign, and the numbers need you to put them together and make a proper equality. When you do that, both those cards disappear! When you've made them all disappear, found all the operations, you've won the game! :)")
  credit: ""
}
