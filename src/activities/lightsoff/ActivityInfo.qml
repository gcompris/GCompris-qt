import GCompris 1.0

ActivityInfo {
  name: "lightsoff/Lightsoff.qml"
  difficulty: 6
  icon: "lightsoff/lightsoff.svg"
  author: "Stephane Mankowski <stephane@mankowski.fr>"
  demo: false
  title: qsTr("Lights Off")
  description: qsTr("The aim is to switch off all the lights.")
//  intro: "Click on the lamps to turn them off."
  goal: qsTr("The aim is to switch off all the lights.")
  prerequisite: ""
  manual: qsTr("The effect of pressing a button is to toggle the state of that button, and of its immediate vertical and horizontal neighbors. The sun and the color of the sky depend on the number of clicks needed to solve the puzzle. If you click on Tux, the solution is shown.")
  credit: qsTr("The solver algorithm is described on Wikipedia. To know more about the Lights Off game: &lt;http://en.wikipedia.org/wiki/Lights_Out_(game)&gt;")
  section: "/puzzle"
}
