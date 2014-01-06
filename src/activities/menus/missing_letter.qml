import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "missing_letter"
  dir: "src/activities/missing_letter"
  difficulty: 2
  icon: "menus/missing_letter.svg"
  author: "Pascal Georges <pascal.georges1@free.fr>"
  demo: true
  title: qsTr("Missing Letter")
  description: qsTr("Fill in the missing letter")
  goal: qsTr("Training reading skills")
  prerequisite: qsTr("Word reading")
  manual: qsTr("An object is displayed in the main area, and an incomplete word is printed under the picture. Select the missing letter to complete the word.")
  credit: ""
}
