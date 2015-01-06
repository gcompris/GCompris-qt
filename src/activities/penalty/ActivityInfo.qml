import GCompris 1.0

ActivityInfo {
  name: "penalty/Penalty.qml"
  difficulty: 1
  icon: "penalty/penalty.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: false
  title: qsTr("Penalty kick")
  description: qsTr("Double click the mouse on the ball to score a goal.")
//  intro: "Double click on the ball to shoot it."
  goal: ""
  prerequisite: ""
  manual: qsTr("Double click the mouse on the ball to kick it. " +
               "You can double click the left right or middle mouse button. " +
               "If you lose, Tux catches the ball. You must click on it to " +
               "bring it back to its former position")
  credit: ""
  section: "/computer/mouse"
}
