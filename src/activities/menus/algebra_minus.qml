import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "algebra_minus"
  dir: "src/activities/algebra_minus"
  difficulty: 2
  icon: "menus/algebra_minus.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Practice the subtraction operation")
  description: qsTr("Answer some algebra questions")
  goal: qsTr("In a limited time, find the difference between two numbers")
  prerequisite: qsTr("Simple subtraction")
  manual: qsTr("A subtraction problem with two numbers is displayed. At the right of the equals sign, give the answer, the difference. Use the left and right arrows to modify your answer and press the Enter key to check if you've got it right. If not, just try again.")
  credit: ""
}
