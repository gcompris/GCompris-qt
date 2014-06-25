import GCompris 1.0

ActivityInfo {
  name: "gnumch-factors/Gnumch-factors.qml"
  difficulty: 5
  icon: "gnumch-factors/gnumch-factors.svg"
  author: "Qt Quick port by Manuel Tondeur <manueltondeur@gmail.com>"
  demo: false
  title: qsTr("Gnumch Factors")
  description: qsTr("")
  goal: qsTr("Practice addition, multiplication, division and subtraction.")
  prerequisite: qsTr("")
  manual: ApplicationInfo.isMobile ? qsTr("Use the arrow keys to navigate around the board and to avoid the Troggles. Press the space bar to eat the number") : qsTr("Touch cells to move around the board and to avoid the Troggles. Press the muncher to eat the number")
  credit: qsTr("")
  section: "/math/algebramenu"
}
