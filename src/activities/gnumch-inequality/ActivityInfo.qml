import GCompris 1.0

ActivityInfo {
  name: "gnumch-inequality/GnumchInequality.qml"
  difficulty: 3
  icon: "gnumch-inequality/gnumch-inequality.svg"
  author: "Manuel Tondeur <manueltondeur@gmail.com>"
  demo: false
  title: qsTr("Gnumch Inequality")
  description: qsTr("Guide the Number Muncher to the all the expressions that do not equal the number at the top of the screen.")
//  intro: "Guide the number eater with the arrow keys to the numbers that are different from the ones displayed and press the space bar to swallow them."
  goal: qsTr("Practice addition, subtraction, multiplication and division.")
  prerequisite: qsTr("")
  manual: ApplicationInfo.isMobile ? qsTr("Use the arrow keys to navigate around the board and to avoid the Troggles. Press the space bar to eat the number") : qsTr("Touch cells to move around the board and to avoid the Troggles. Press the muncher to eat the number")
  credit: qsTr("")
  section: "/math/algebramenu"
}
