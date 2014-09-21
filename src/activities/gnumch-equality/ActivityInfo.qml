import GCompris 1.0

ActivityInfo {
  name: "gnumch-equality/GnumchEquality.qml"
  difficulty: 3
  icon: "gnumch-equality/gnumch-equality.svg"
  author: "Manuel Tondeur <manueltondeur@gmail.com>"
  demo: false
  title: qsTr("Gnumch Equality")
  description: qsTr("Guide the Number Muncher to the expressions that equal the number at the top of the screen.")
//  intro: "Guide the number eater with the arrow keys to the required numbers and press the space bar to swallow them."
  goal: qsTr("Practice addition, multiplication, division and subtraction.")
  prerequisite: qsTr("")
  manual: ApplicationInfo.isMobile ? qsTr("Use the arrow keys to navigate around the board and to avoid the Troggles. Press the space bar to eat a number") : qsTr("Touch cells to move around the board and to avoid the Troggles. Press the muncher to eat the number")
  credit: qsTr("")
  section: "/math/algebramenu"
}
