import GCompris 1.0

ActivityInfo {
  name: "algebra_minus/AlgebraMinus.qml"
  difficulty: 1
  icon: "algebra_minus/algebra_minus.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Practice the subtraction operation")
  description: qsTr("Answer some algebra questions")
//  intro: "Subtract the two numbers and type in your answer before the balloon lands in the water"
  goal: qsTr("In a limited time, find the difference between two numbers")
  prerequisite: qsTr("Simple subtraction")
  manual: qsTr("A subtraction problem with two numbers is displayed. At the right of the equals sign, give the answer, the difference. Use the left and right arrows to modify your answer and press the Enter key to check if you've got it right. If not, just try again.")
  credit: ""
  section: "/math/algebramenu/algebra_group"
}
