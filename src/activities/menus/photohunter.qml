import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "photohunter"
  dir: "src/activities/photohunter"
  difficulty: 2
  icon: "menus/photohunter.svg"
  author: "Marc Le Douarain <http://membres.lycos.fr/mavati>"
  demo: true
  title: qsTr("Photo hunter")
  description: qsTr("Find the differences between two pictures")
  goal: qsTr("Visual discrimination.")
  prerequisite: ""
  manual: qsTr("Observe the two pictures carefully. There are some slight differences. When you find a difference you must click on it.")
  credit: ""
}
