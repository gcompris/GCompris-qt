import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "imageid"
  dir: "src/activities/imageid"
  difficulty: 2
  icon: "menus/imageid.svg"
  author: "Pascal Georges <pascal.georges1@free.fr>"
  demo: true
  title: qsTr("Reading practice")
  description: qsTr("Practice reading by finding the word matching an image")
  goal: ""
  prerequisite: qsTr("Reading")
  manual: qsTr("Click on the word corresponding to the printed image.")
  credit: ""
}
