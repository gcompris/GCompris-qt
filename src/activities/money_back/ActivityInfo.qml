import GCompris 1.0

ActivityInfo {
  name: "money_back/MoneyBack.qml"
  difficulty: 3
  icon: "money_back/money_back.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Give tux his change")
  description: qsTr("Practice money usage by giving Tux his change")
//  intro: "Click on the money at the bottom of the screen to give Tux his change."
  goal: qsTr("Tux bought you different items and shows you his money. You must give him back his change. At higher levels, several items are displayed, and you must first calculate the total price.")
  prerequisite: qsTr("Can count")
  manual: qsTr("Click on the coins or paper money at the bottom of the screen to pay. If you want to remove a coin or note, click on it on the upper screen area.")
  credit: ""
  section: "/math/numeration/money_group"
}
