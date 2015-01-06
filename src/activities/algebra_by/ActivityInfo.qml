import GCompris 1.0

ActivityInfo {
  name: "algebra_by/AlgebraBy.qml"
  difficulty: 3
  icon: "algebra_by/algebra_by.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Practice the multiplication operation")
  description: qsTr("Answer some algebra questions")
//  intro: "Multiply the two numbers together and type in your answer before the balloon lands in the water"
  goal: qsTr("In a limited time, give the product of two numbers")
  prerequisite: qsTr("Multiplication table")
  manual: qsTr("A multiplication of two numbers is displayed. At the right of the equals sign, give the answer, the product. Use the left and right arrows to modify your answer and press the Enter key to check if you've got it right. If not, just try again.")
  credit: ""
  section: "/math/algebramenu/algebra_group"
}
