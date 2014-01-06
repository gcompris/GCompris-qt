import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "imagename"
  dir: "src/activities/imagename"
  difficulty: 3
  icon: "menus/imagename.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Image Name")
  description: qsTr("Drag and Drop each item above its name")
  goal: qsTr("Vocabulary and reading")
  prerequisite: qsTr("Reading")
  manual: qsTr("Drag each image from the (vertical) box on the left to its (corresponding) name on the right. Click the OK button to check your answer.")
  credit: ""
}
