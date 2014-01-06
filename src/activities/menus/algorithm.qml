import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "algorithm"
  dir: "src/activities/algorithm"
  difficulty: 2
  icon: "menus/algorithm.svg"
  author: "Christof Petig and Ingo Konrad"
  demo: true
  title: qsTr("algorithm")
  description: qsTr("Complete a list of symbols")
  goal: qsTr("Logic training activity")
  prerequisite: qsTr("Move and click the mouse")
  manual: qsTr("Find the next symbol in a list.")
  credit: ""
}
