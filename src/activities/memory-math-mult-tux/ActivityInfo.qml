import GCompris 1.0

ActivityInfo {
  name: "memory-math-mult-tux/MemoryMathMultTux.qml"
  difficulty: 5
  icon: "memory-math-mult-tux/memory-math-mult-tux.svg"
  author: "JB BUTET <ashashiwa@gmail.com>"
  demo: false
  title: qsTr("Multiplication memory game against Tux")
  description: qsTr("Turn the cards over to find two numbers which multiply the same, until all the cards are gone.")
//  intro: "Turn over two cards to match the calculation with its answer."
  goal: qsTr("Practise multiplication, until all the cards are gone.")
  prerequisite: qsTr("Multiplication")
  manual: qsTr("You can see some cards, but you can't see what's on the other side of them. Each card is hiding an operation, or the answer to it.

In this game, these cards are hiding the two parts of an operation. You need to find the two parts of the operation, and bring them together again. Click on a card to see what number it's hiding, then try to find the other card that goes with it, to make a whole operation. You can only turn over two cards in one go, so you need to remember where the numbers are hiding, then you can match them when you find their other half. You're doing the job of the equals sign, and the numbers need you to put them together and make a proper equality. When you do that, both those cards disappear! When you've made them all disappear, found more then Tux and you've won the game! :)")
  credit: ""
  section: "/math/algebramenu/memory_op_group"
}
