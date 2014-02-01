import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "hexagon"
  dir: "src/activities/hexagon"
  difficulty: 2
  icon: "hexagon/hexagon.svg"
  author: "Christof Petig and Ingo Konrad"
  demo: true
  title: qsTr("hexagon")
  description: qsTr("Find the strawberry by clicking on the blue fields")
  goal: qsTr("Logic-training activity")
  prerequisite: qsTr("Move and click the mouse")
  manual: qsTr("Try to find the strawberry under the blue fields. The fields become redder as you get closer.")
  credit: ""
}
