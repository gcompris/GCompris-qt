import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "money_cents"
  dir: "src/activities/money_cents"
  difficulty: 5
  icon: "menus/money_cents.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Money")
  description: qsTr("Practice money usage including cents")
  goal: qsTr("You must buy the different items and give the exact price. At higher levels, several items are displayed, and you must first calculate the total price.")
  prerequisite: qsTr("Can count")
  manual: qsTr("Click on the coins or paper money at the bottom of the screen to pay. If you want to remove a coin or note, click on it on the upper screen area.")
  credit: ""
}
