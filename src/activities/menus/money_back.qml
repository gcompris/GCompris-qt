import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "money_back"
  dir: "src/activities/money_back"
  difficulty: 3
  icon: "menus/money_back.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Give tux his change")
  description: qsTr("Practice money usage by giving Tux his change")
  goal: qsTr("Tux bought you different items and shows you his money. You must give him back his change. At higher levels, several items are displayed, and you must first calculate the total price.")
  prerequisite: qsTr("Can count")
  manual: qsTr("Click on the coins or paper money at the bottom of the screen to pay. If you want to remove a coin or note, click on it on the upper screen area.")
  credit: ""
}
