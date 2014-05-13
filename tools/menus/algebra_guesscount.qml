import GCompris 1.0

ActivityInfo {
  name: "algebra_guesscount/AlgebraGuesscount.qml"
  difficulty: 3
  icon: "algebra_guesscount/algebra_guesscount.svg"
  author: "Pascal Georges <pascal.georges1@free.fr>"
  demo: true
  title: qsTr("Find the series of correct operations that matches the given answer")
  description: qsTr("Work out the right combination of numbers and operations to match the given value")
  goal: qsTr("Deploy a strategy to arrange a set of arithmetic operations to match a given value.")
  prerequisite: qsTr("The four arithmetic operations. Combine several arithmetic operations.")
  manual: qsTr("At the top of the board area, choose the numbers and arithmetic operators that give the specified result. You can deselect a number or operator by clicking on it again.")
  credit: qsTr("Animal pictures come from the Animal Photography Page of Ralf Schmode (http://schmode.net/). Ralf has kindly permitted GCompris to include his pictures. Thanks a lot, Ralf.")
  section: "/math/algebramenu"
}
