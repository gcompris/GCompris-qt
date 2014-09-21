import GCompris 1.0

ActivityInfo {
  name: "algebra_plus/AlgebraPlus.qml"
  difficulty: 1
  icon: "algebra_plus/algebra_plus.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Practice the addition operation")
  description: qsTr("Answer some algebra questions")
//  intro: "Add the two numbers together and type in your answer before the balloon lands in the water"
  goal: qsTr("In a limited time, find the sum of of two numbers. Introduction to simple in-line addition.")
  prerequisite: qsTr("Simple addition. Can recognize written numbers")
  manual: qsTr("An addition problem with two numbers is displayed. At the right of " +
               "the equals sign, give the answer, the sum. Use the left and right arrows " +
               "to modify your answer and press the Enter key to check if you've got it right. " +
               "If not, just try again.")
  credit: ""
  section: "/math/algebramenu/algebra_group"
}
