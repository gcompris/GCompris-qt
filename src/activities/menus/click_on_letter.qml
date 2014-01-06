import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "click_on_letter"
  dir: "src/activities/click_on_letter"
  difficulty: 1
  icon: "menus/click_on_letter.svg"
  author: "Pascal Georges <pascal.georges1@free.fr>"
  demo: true
  title: qsTr("Click on a lowercase letter")
  description: qsTr("Listen to a letter and click on the right one")
  goal: qsTr("Letter-name recognition")
  prerequisite: qsTr("Visual letter-recognition. Can move the mouse.")
  manual: qsTr("A letter is spoken. Click on the matching letter in the main area. You can listen to the letter again, by clicking on the mouth icon in the bottom box.")
  credit: ""
}
