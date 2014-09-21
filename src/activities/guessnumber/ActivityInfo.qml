import GCompris 1.0

ActivityInfo {
  name: "guessnumber/Guessnumber.qml"
  difficulty: 3
  icon: "guessnumber/guessnumber.svg"
  author: "Thib ROMAIN <thibrom@gmail.com>"
  demo: true
  title: qsTr("Guess a number")
  description: qsTr("Help Tux escape the cave. Tux hides a number for you to find.")
//  intro: "Find out the number by typing a number from the range proposed and click on the thumb to validate your answer."
  goal: ""
  prerequisite: qsTr("Numbers from 1 to 1000 for the last level.")
  manual: qsTr("Read the instructions that give you the range of the number to find. Enter a number in the top right blue entry box. Tux will tell you if your number is higher or lower. Then enter another number. The distance between Tux and the escape area on the right represents how far you are from the correct number. If Tux is over or under the escape area, it means your number is over or under the correct number.")
  credit: ""
  section: "/math/numeration"
}
