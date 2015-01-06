import GCompris 1.0

ActivityInfo {
  name: "target/Target.qml"
  difficulty: 2
  icon: "target/target.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Practice addition with a target game")
  description: qsTr("Hit the target and count your points")
//  intro: "Click on the target to launch darts, then count your score!"
  goal: qsTr("Throw darts at a target and count your score.")
  prerequisite: qsTr("Can move the mouse, can read numbers and count up to 15 for the first level")
  manual: qsTr("Check the wind speed and direction, and then click on the target to launch a dart. When you all your darts are thrown, a window appears asking you to count your score. Enter the score with the keyboard then press the Enter key or the OK button.")
  credit: ""
  section: "math addition"
}
